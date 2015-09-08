using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;

namespace webapp
{
    public class DocumentHttpHandler : IHttpHandler
    {
        public DocumentHttpHandler()
        {
            //if (Logger.Enabled) Logger.Write("creating new instance of DocumentHttpHandler ...");
        }

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            //if (Logger.Enabled) Logger.Write("{0} {1} - {2} => {3}", request.HttpMethod,
            //    request.Path, request.UserHostAddress, request.UserAgent);

            string idf = (request.Params["idf"] != null ?
                request.Params["idf"] : request.QueryString["idf"]);

            string aic = (request.Params["aic"] != null ?
                request.Params["aic"] : request.QueryString["aic"]);

            string connectionString = ConfigurationManager.ConnectionStrings["farmadati"].ConnectionString;

            string save_sql = "";
            Exception save_ex = null;

            if (aic != null)
            {
                if (aic.StartsWith("A")) aic = aic.Substring(1);
                while (aic.Length < 9) aic = "0" + aic;

                string lang = request.Params["lang"];

                if (lang == null)
                    lang = WebConfigurationManager.AppSettings["defaultLanguage"];

                if (lang == null || lang.ToLower().Equals("auto"))
                    lang = Tools.GetPreferredLanguageId(request.UserLanguages);

                if (lang == null)
                    lang = "it";

                try
                {

                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand command = new SqlCommand(
                            String.Concat(
                                "SELECT [FDI_T227], [FDI_T483] ",
                                "   FROM [DBFarmadati_WEB].[dbo].[TDF] ",
                                "   WHERE [FDI_T218]='", aic, "'")
                                    , connection))
                        {
                            command.CommandType = CommandType.Text;
                            connection.Open();

                            save_sql = command.CommandText;

                            Hashtable filesmap = new Hashtable();
                            
                            using (SqlDataReader reader = command.ExecuteReader())
                            {
                                while (reader.Read())
                                {
                                    string filename = reader.IsDBNull(0) ? "" : reader.GetString(0);
                                    string language = reader.IsDBNull(1) ? "" : reader.GetString(1);
                                    
                                    filesmap.Add(
                                        language, 
                                        filename
                                            .ToLower()
                                            .Replace(".pdf", "")
                                            .Replace("f", "")
                                            .TrimStart('0'));

                                }

                                if (filesmap.Count == 0)
                                {
                                    if (Logger.Enabled)
                                        Logger.Write("No records found executing SQL > {0}", save_sql);
                                }
                                else
                                {
                                    // TODO: 
                                    //      1) selezionare la lingua preferita se c'è
                                    //      2) in caso contrario restituire la default di sistema
                                    //      3) se non c'è neanche quella restituire il primo elemento (con warning su log)                                    
                                    foreach (var v in filesmap.Values)
                                    {
                                        idf = (string)v;
                                        break;
                                    }                                    
                                }

                                try
                                {
                                    if (!reader.IsClosed)
                                        reader.Close();
                                }
                                catch { }
                            }
                            try
                            {
                                if (connection.State != ConnectionState.Closed)
                                    connection.Close();
                            }
                            catch { }
                        }
                    }
                }
                catch (Exception e)
                {
                    save_ex = e;
                    idf = null;
                    if (Logger.Enabled)
                        Logger.Write(
                            "Error executing SQL > {0} - connection string: {1} reason: {2}",
                            save_sql, connectionString, save_ex);
                }

            }

            if (idf != null)
            {
                string redirect = WebConfigurationManager.AppSettings["searchRedirect"];
                if (redirect == null) redirect = "viewer.aspx";
                response.Redirect(redirect + (redirect.IndexOf('?') >= 0 ? "&" : "?") + "id=" + idf, true);
            }
            else
            {
                if (save_ex != null)
                {
                    response.StatusCode = 500;
                    response.StatusDescription = "Server Error - " + save_ex.Message;
                }
                else
                {
                    response.StatusCode = 404;
                    response.StatusDescription = "Not Found";
                }
                
                Tools.ReplyJSon(response);

            }

        }

    }

}
