using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;
using System.Net;
using System.IO;
using Microsoft.Win32;

namespace webapp
{
    public class ScriptsHttpHandler : IHttpHandler
    {        

        public ScriptsHttpHandler()
        {
            if (Logger.Enabled) Logger.Write("creating new instance of ScriptsHttpHandler ...");
        }

        public bool IsReusable
        {
            get { return true; }
        }

        private string mimeHelper(string filename)
        { 
            string mimeType = "application/unknown";
            string ext = System.IO.Path.GetExtension(filename).ToLower();
            RegistryKey regKey = Registry.ClassesRoot.OpenSubKey(ext);
            if (regKey != null && regKey.GetValue("Content Type") != null)
            mimeType = regKey.GetValue("Content Type").ToString();
            return mimeType;
        }

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            //if (Logger.Enabled) Logger.Write("{0} {1} - {2} => {3}", request.HttpMethod,
            //    request.Path, request.UserHostAddress, request.UserAgent);

            try {

                string path = request.Path;
                string scriptPath = WebConfigurationManager.AppSettings["scriptsPath"];
                
                if (scriptPath == null) 
                    scriptPath = "https://github.com/"
                        + "f3d3r1c0/web/tree/master/projects/vs/fiweb/js";

                if (!scriptPath.EndsWith("/")) scriptPath += "/";
                scriptPath += ((path.StartsWith("/") ? path.Substring(1) : path));

                WebRequest wreq = WebRequest.Create(scriptPath);

                //
                // override proxy settings if required from web.config
                //
                string proxyAddress = WebConfigurationManager.AppSettings["scriptsProxy"];
                if (proxyAddress != null)
                {
                    string proxyUser = WebConfigurationManager.AppSettings["scriptsProxyUser"];
                    string proxyPass = WebConfigurationManager.AppSettings["scriptsProxyPassword"];
                    if (Logger.Enabled) Logger.Write("override system proxy: {0}:****@{1}", proxyUser, proxyAddress);
                    WebProxy ovverideProxy = new WebProxy();                    
                    ovverideProxy = (WebProxy)wreq.Proxy;                    
                    Uri newUri = new Uri(proxyAddress);                    
                    ovverideProxy.Address = newUri;                    
                    ovverideProxy.Credentials = new NetworkCredential(proxyUser, proxyPass);
                    wreq.Proxy = ovverideProxy;
                }

                wreq.Credentials = CredentialCache.DefaultCredentials;
                HttpWebResponse wres = (HttpWebResponse)wreq.GetResponse();

                if (wres.StatusCode == HttpStatusCode.OK)
                {
                    Stream dataStream = wres.GetResponseStream();
                    StreamReader reader = new StreamReader(dataStream);
                    string responseFromServer = reader.ReadToEnd();
                    response.ContentType = mimeHelper(path);
                    response.Write(responseFromServer);
                    response.StatusCode = 200;
                    response.Flush();
                    reader.Close();
                    dataStream.Close();
                }
                else
                {
                    int code = 500;
                    Int32.TryParse(wres.StatusCode.ToString(), out code);
                    response.StatusCode = code;
                    response.StatusDescription = wres.StatusDescription;
                    FormatUtils.ReplyJSon(response);
                }

                wres.Close();


            }
            catch 
            {
                response.StatusCode = 404;
                response.StatusDescription = "Not Found";
                FormatUtils.ReplyJSon(response);
            }

        }

    }
    
}