using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace webapp
{
    public class DocumentHttpHandler : IHttpHandler
    {
        public DocumentHttpHandler()
        {
            if (Logger.Enabled) Logger.Write("creating new instance of DocumentHttpHandler ...");
        }

        public bool IsReusable
        {
            get { return true; }
        }

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            if (Logger.Enabled) Logger.Write("{0} {1} - {2} => {3}", request.HttpMethod,
                request.Path, request.UserHostAddress, request.UserAgent);

            string aic = (request.Params["aic"] != null ? 
                request.Params["aic"] : request.QueryString["aic"]);

            if (aic != null)
            {
                string lang = request.Params["lang"];

                if (lang == null) 
                    lang = WebConfigurationManager.AppSettings["defaultLanguage"];
                
                if (lang == null || lang.ToLower().Equals("auto")) 
                    lang = FormatUtils.GetPreferredLanguageId(request.UserLanguages);
                
                if (lang == null) 
                    lang = "it";

                //
                // TODO: 
                //      1) Inserire LA QUERY PER RITROVARE l'id del foglietto dall'AIC
                //      2) Redirezionare su input se non trovato con messaggio di errore
                //      3) Tracciare richiesta (se possibile collegare all'id farmacia ottenuto in Mail Handler)
                //

                string f_id = request.Params["aic"];
                                
                response.Redirect("viewer.aspx?id=" + f_id, true);
            }
            else
            {
                response.StatusCode = 400;
                response.StatusDescription = "Bad Request";
                FormatUtils.ReplyJSon(response);
            }

        }

    }
    
}