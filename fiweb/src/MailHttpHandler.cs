﻿using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Text;
using System.Web.Configuration;

namespace webapp
{
    public class MailHttpHandler : IHttpHandler
    {
        
        public MailHttpHandler()
        {
            //Logger.Write("creating new instance of MailHttpHandler");
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

            string transactionID = Tools.NextId();

            //
            // read configuration from web config
            //
            string mailSubject = WebConfigurationManager.AppSettings["mailSubject"];
            string mailFrom = WebConfigurationManager.AppSettings["mailFrom"];
            string mailSmtpServer = WebConfigurationManager.AppSettings["mailSmtpServer"];            
            string mailSmtpUser = WebConfigurationManager.AppSettings["mailSmtpUser"];
            string mailSmtpPassword = WebConfigurationManager.AppSettings["mailSmtpPassword"];
            string mailSmtpPort = WebConfigurationManager.AppSettings["mailSmtpPort"];
            string mailSmtpRequireSSL = WebConfigurationManager.AppSettings["mailSmtpRequireSSL"];
            string mailSmtpTimeout = WebConfigurationManager.AppSettings["mailSmtpTimeout"];
            string mailBody = WebConfigurationManager.AppSettings["mailBody"];
            string mailBodyBookmarkUrl = WebConfigurationManager.AppSettings["mailBodyBookmarkUrl"];
            
            if (mailSmtpServer == null)
            {
                if (Logger.Enabled) Logger.Write("Warning: Mail configuration missing - " +
                        "request forbidden ... {0} {1} - {2} => {3}", 
                        request.HttpMethod, request.Path, 
                        request.UserHostAddress, request.UserAgent);
                response.StatusCode = 403;
                response.StatusDescription = "Forbidden";
                Tools.ReplyJSon(response, "id", transactionID);
                response.Flush();
                return;
            }
                        
            if (mailFrom == null)
                mailFrom = "noreply@nodomain.com";
            
            int port = (mailSmtpPort != null ? 
                Int32.Parse(mailSmtpPort) : 25);

            int timeout = (mailSmtpTimeout != null ? 
                    int.Parse(mailSmtpTimeout) : -1);

            bool requireSSL = (mailSmtpRequireSSL != null ?
                    bool.Parse(mailSmtpRequireSSL) : false);

            if (mailBody == null)
                mailBody = "./mailbody.html";

            if (!Path.IsPathRooted(mailBody))
                mailBody = Path.GetFullPath(context.Server.MapPath(".") + mailBody);
            
            //
            // read request parameters
            //

            string pharmacy = Tools.GetRequestParameter(request, "pharmacy");
            string mailBox = Tools.GetRequestParameter(request, "mailbox");
            string aic = Tools.GetRequestParameter(request, "aic");
            string fid = Tools.GetRequestParameter(request, "fid"); 
            string lang = Tools.GetRequestParameter(request, "lang"); 
            
            string badreqFields = "";

            if (mailBox == null) badreqFields += "<mailbox> ";
            if (pharmacy == null) badreqFields += "<pharmacy> ";
            if (aic == null && fid == null) badreqFields += "<aic|fid> ";

            if (badreqFields.Length > 0)
            {
                if (Logger.Enabled) Logger.Write("Bad request, missing required fields: {0}", badreqFields);
                response.StatusCode = 400;
                response.StatusDescription = "Bad request";
                Tools.ReplyJSon(response, "id", transactionID);
                response.Flush();
                return;
            }

            //
            // TODO 
            // - tracciare qui la request fatta dalla farmacia
            // - possibile mappa di email --> +aic per autorizzare la visualizzazione delel pagine
            //   in un secondo momento
            //

            if (mailBodyBookmarkUrl == null) 
            {
                mailBodyBookmarkUrl = request.Url.AbsoluteUri;
                mailBodyBookmarkUrl = mailBodyBookmarkUrl.Substring(0, mailBodyBookmarkUrl.IndexOf("/mail"));            
            }
            
            try
            {
                SmtpClient client = new SmtpClient();
                client.Port = port;
                client.Host = mailSmtpServer;
                if (requireSSL) client.EnableSsl = true;
                if (timeout > 0) client.Timeout = timeout;
                client.DeliveryMethod = SmtpDeliveryMethod.Network;
                if (mailSmtpUser != null)
                {
                    client.UseDefaultCredentials = true;
                    client.Credentials = new System.Net.NetworkCredential(
                            mailSmtpUser, 
                            mailSmtpPassword);
                }

                string line = null;
                StringBuilder body = new StringBuilder();
                StreamReader sr = new StreamReader(mailBody);
                while ((line = sr.ReadLine()) != null)
                {
                    body.Append(
                            line.
                            Replace("@@aic@@", (aic != null ? aic : "")).
                            Replace("@@mailBodyBookmarkUrl@@", (mailBodyBookmarkUrl != null ? mailBodyBookmarkUrl : ""))                                        
                        );
                }
                sr.Close();

                MailMessage mm = new MailMessage(
                        mailFrom,
                        mailBox,
                        mailSubject,
                        body.ToString());

                mm.IsBodyHtml = true;
                mm.BodyEncoding = UTF8Encoding.UTF8;
                mm.DeliveryNotificationOptions = DeliveryNotificationOptions.OnFailure;

                client.Send(mm);

                response.StatusCode = 200;
                response.StatusDescription = "OK";
                Tools.ReplyJSon(response, "id", transactionID);
                response.Flush();
                
            }
            catch (Exception e)
            {
                if (Logger.Enabled) Logger.Write("MailHttpHandler error - {0}", e);
                response.StatusCode = 500;
                response.StatusDescription = "Server Error - " + e.Message;
                Tools.ReplyJSon(response, "id", transactionID);
                response.Flush();
                
            }

        }
    }
}