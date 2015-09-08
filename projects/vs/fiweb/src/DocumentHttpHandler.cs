using System;
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

                            using (SqlDataReader reader = command.ExecuteReader(
                                CommandBehavior.SingleResult /* TODO: puo' essere piu' di una lingua */
                                        | CommandBehavior.SequentialAccess
                                        | CommandBehavior.CloseConnection))
                            {
                                if (reader.Read())
                                {
                                    string filename = reader.IsDBNull(0) ? "" : reader.GetString(0);
                                    string language = reader.IsDBNull(1) ? "" : reader.GetString(1);
                                    idf = filename;
                                    // TODO: selezionare la lingua di default ma aggiungere 
                                    //       la possibilità di più lingue                                  
                                }
                                else
                                {
                                    if (Logger.Enabled)
                                        Logger.Write("No records found executing SQL > {0}", save_sql);
                                    idf = null;
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
