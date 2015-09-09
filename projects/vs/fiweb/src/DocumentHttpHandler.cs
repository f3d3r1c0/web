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

            string idf = Tools.GetRequestParameter(request, "idf");
            string aic = Tools.GetRequestParameter(request, "aic");
            
            string save_sql = "";
            Exception save_ex = null;

            string redirect = "viewer.aspx";
            string redirect_opts = "";
            
            // begin parsing test string command
            if (aic != null && aic.StartsWith("test"))
            {
                int count = 0;
                string[] pz = aic.Split(' ', '\t', ',', ';');

                foreach (string p in pz)
                {
                    if (pz.Length == 0) continue;
                    if (count == 1) 
                    {
                        if (p.ToUpper().StartsWith("F")) 
                        {
                            idf = p;
                            aic = null; 
                        }
                        else
                        {
                            aic = p;
                        }
                    }
                    else if (count == 2) 
                    { 
                        redirect = "viewer" + p + ".aspx"; 
                    }                    
                    count++;
                }

                if (count < 2)
                {
                    idf = "10001";
                    redirect_opts = "&languages=itF0015000,deF0015001,frF0015002,enF0015003,esF0015004";
                    aic = null;
                }

            }
            // end parsing test string command

            string requestLang = Tools.GetRequestParameter(request, "language");

            if (aic != null)
            {
                if (aic.ToUpper().StartsWith("A")) aic = aic.Substring(1);
                while (aic.Length < 9) aic = "0" + aic;
                                
                string connectionString = ConfigurationManager.ConnectionStrings["farmadati"].ConnectionString;

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
                                    string language = reader.IsDBNull(1) ? "" : reader.GetString(1).ToLower();

                                    if (language.StartsWith("it")) language = "it";
                                    else if (language.StartsWith("es")) language = "es";
                                    else if (language.StartsWith("en")) language = "en";
                                    else if (language.StartsWith("de")) language = "de";
                                    else if (language.StartsWith("fr")) language = "fr";
                                    else if (language.StartsWith("us")) language = "en";

                                    if (filesmap.ContainsKey(language))
                                    {
                                        if (Logger.Enabled)
                                            Logger.Write("Warning: duplicate language found for AIC {0} " +
                                                "- language: {1}, filename: {2}",
                                                aic, language, filename);
                                    }
                                    else
                                    {
                                        filesmap.Add(
                                            language,
                                            filename
                                                .ToLower()
                                                .Replace(".pdf", "")
                                                .Replace("f", "")
                                                .TrimStart('0'));
                                    }

                                }

                                if (filesmap.Count == 0)
                                {
                                    if (Logger.Enabled)
                                        Logger.Write("No records found executing SQL > {0}", save_sql);
                                }
                                else
                                {   
                                    string[] browserLang = request.UserLanguages;

                                    idf = null;

                                    if (requestLang != null)
                                    {                                        
                                        idf = (string)filesmap[requestLang.Substring(0, 2).ToLower()];
                                    }

                                    // get first browser language matching 
                                    if (idf == null)
                                    {
                                        foreach (string l in browserLang)                                        
                                        {                                            
                                            if (filesmap[l.Substring(0, 2).ToLower()] != null)
                                            {
                                                idf = (string)filesmap[l.Substring(0, 2).ToLower()];
                                                break;
                                            }
                                        }
                                    }

                                    // no matching languages ... get first doc available.
                                    if (idf == null)
                                    {
                                        foreach (var f in filesmap.Values)
                                        {
                                            idf = (string)f;
                                            break;
                                        }
                                    }

                                    // create available user languages list
                                    string lkeys = "";
                                    foreach (var k in filesmap.Keys)
                                    {
                                        lkeys += k;                                        
                                        lkeys += filesmap[k].ToString().ToUpper().Replace(".PDF", "");
                                        lkeys += ",";
                                        break;
                                    }

                                    redirect_opts = "&languages=" + lkeys;                                    

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
                if (requestLang != null) redirect_opts += "&currentLanguage=" + requestLang;
                response.Redirect(redirect + "?id=" + idf + redirect_opts, true);
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
