using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Configuration;
using System.Data;
using System.IO;

namespace webapp
{
    public class PdfHttpHandler : IHttpHandler
    {
        public PdfHttpHandler()
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

            try
            {
                string pdf = request.Url.AbsolutePath;
                pdf = pdf.Substring(pdf.LastIndexOf('/') + 1);

                if (!pdf.ToLower().EndsWith(".pdf")) pdf += ".pdf";

                string documentRoot = WebConfigurationManager.AppSettings["documentRoot"];
                if (!Path.IsPathRooted(documentRoot))
                    documentRoot = Path.GetFullPath(context.Server.MapPath("..") + documentRoot);
                if (!documentRoot.EndsWith(@"\")) documentRoot += @"\";

                pdf = documentRoot + pdf;

                response.ContentType = "application/pdf";
                response.BinaryWrite(File.ReadAllBytes(pdf));
                response.StatusCode = 200;
                response.StatusDescription = "OK"; 
                response.Flush();

            }
            catch (Exception e)
            {
                if (Logger.Enabled) Logger.Write("error: {0}", e);
                response.StatusCode = 500;
                response.StatusDescription = "Server Error - " + e.Message;
                Tools.ReplyJSon(response);
            }
            
            
            
        }

    }

}