using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Web;
using System.Text;
using System.Web.Configuration;
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using System.Globalization;
using System.Threading;

namespace webapp
{
    class MailServiceException : Exception
    {
        public int Code = -1;
        public string Description = null;

        public MailServiceException(int code, string description)
        {
            Code = code;
            Description = description;
        }
    }


    public class MailHttpHandler : IHttpHandler
    {
        private string connectionString;
        
        public MailHttpHandler()
        {
            connectionString = ConfigurationManager.ConnectionStrings["farmadati"].ConnectionString;
        }

        public bool IsReusable
        {
            get { return false; }
        }

        public void ProcessRequest(HttpContext context)
        {                   
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            DateTime start = DateTime.Now;
            string transactionID = Tools.CreateTransactionId();
                        
            //
            // read smtp configuration 
            //
            string mailSubject = Tools.GetRequestParameter(request, "mailSubject", WebConfigurationManager.AppSettings["mailSubject"]);
            string mailFrom = Tools.GetRequestParameter(request, "mailFrom", WebConfigurationManager.AppSettings["mailFrom"]);
            string mailSmtpServer = Tools.GetRequestParameter(request, "mailSmtpServer", WebConfigurationManager.AppSettings["mailSmtpServer"]);
            string mailSmtpUser = Tools.GetRequestParameter(request, "mailSmtpUser", WebConfigurationManager.AppSettings["mailSmtpUser"]);
            string mailSmtpPassword = Tools.GetRequestParameter(request, "mailSmtpPassword", WebConfigurationManager.AppSettings["mailSmtpPassword"]);
            string mailSmtpPort = Tools.GetRequestParameter(request, "mailSmtpPort", WebConfigurationManager.AppSettings["mailSmtpPort"]);
            string mailSmtpRequireSSL = Tools.GetRequestParameter(request, "mailSmtpRequireSSL", WebConfigurationManager.AppSettings["mailSmtpRequireSSL"]);
            string mailSmtpTimeout = Tools.GetRequestParameter(request, "mailSmtpTimeout", WebConfigurationManager.AppSettings["mailSmtpTimeout"]);
            string mailBody = Tools.GetRequestParameter(request, "mailBody", WebConfigurationManager.AppSettings["mailBody"]);

            //
            // read user parameters 
            //
            string pharmacy = Tools.GetRequestParameter(request, "pharmacy");
            string mailBox = Tools.GetRequestParameter(request, "mailbox");
            string aic = Tools.GetRequestParameter(request, "aic");
            string lang = Tools.GetRequestParameter(request, "lang");

            try
            {
                if (mailSmtpServer == null)
                    throw new MailServiceException(500, "bad mail configuration");

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

                if (mailBox == null)
                    throw new MailServiceException(400, "missing mailbox address");

                if (mailBox.IndexOf("@") < 0)
                    throw new MailServiceException(404, "bad mailbox address");

                if (mailBox.IndexOf("@", mailBox.IndexOf("@") + 1) > 0)
                    throw new MailServiceException(404, "bad mailbox address");

                if (mailBox.IndexOf(".", mailBox.IndexOf("@") + 1) < 0)
                    throw new MailServiceException(404, "bad mailbox address");
                
                if (pharmacy == null)
                    throw new MailServiceException(400, "missing pharmacy code");

                long ph_id = 0;
                
                if (pharmacy.Length > 6)
                    throw new MailServiceException(404, "bad pharmacy code"); 
                
                while (pharmacy.Length < 6) pharmacy = "0" + pharmacy;
                                
                if (!long.TryParse(pharmacy.TrimStart('0'), out ph_id))
                    throw new MailServiceException(404, "bad pharmacy code"); 
                
                if (aic == null)
                    throw new MailServiceException(400, "missing AIC code");

                aic = aic.ToUpper();                
                
                if (aic.StartsWith("A")) aic = aic.Substring(1);

                if (aic.Length > 9)
                    throw new MailServiceException(404, "bad AIC code"); 
                
                while (aic.Length < 9) aic = "0" + aic;

                long aic_id = 0;
                if (!long.TryParse(aic.TrimStart('0'), out aic_id))
                    throw new MailServiceException(404, "bad AIC code");

                bool aicTestPassed = false;
                
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
                        using (SqlDataReader sqlreader = command.ExecuteReader(
                            CommandBehavior.CloseConnection | CommandBehavior.SingleRow))
                        {
                            aicTestPassed = sqlreader.HasRows;
                            sqlreader.Close();
                        }
                    }
                }

                if (!aicTestPassed) throw new MailServiceException(403, "AIC not found");

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

                string baseurl = request.Url.AbsoluteUri;
                baseurl = baseurl.Substring(0, baseurl.LastIndexOf("/mail"));
                
                string dateFormat = "dddd d MMMM yyyy";
                
                string date = DateTime.Now.ToString(dateFormat);
                CultureInfo ci_global = Thread.CurrentThread.CurrentCulture;
                CultureInfo ci_local = new CultureInfo("it-IT");
                if (!ci_global.Equals(ci_local))
                {
                    Thread.CurrentThread.CurrentCulture = ci_local;
                    date = DateTime.Now.ToString(dateFormat);
                    Thread.CurrentThread.CurrentCulture = ci_global;
                }
                    
                while ((line = sr.ReadLine()) != null)
                {
                    body.Append(
                            line.
                                Replace("@date", date).
                                Replace("@baseurl", baseurl).
                                Replace("@id", aic)
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

            }
            catch (MailServiceException me)
            {
                response.StatusCode = me.Code;
                response.StatusDescription = me.Description;
            }
            catch (Exception e)
            {
                if (Logger.Enabled) Logger.Write("Error: {0}", e);
                response.StatusCode = 500;
                response.StatusDescription = "Server Error - " + e.Message;
            }
            finally
            {
                double elapsed = (double) (DateTime.Now - start).TotalMilliseconds / 1000;

                if (Logger.Enabled)
                    Logger.Write("HTTP /mail {0}\t{1:F2}\t{2}\t{3}\t{4}\t{5}\t{6}\t{7}\t{8}\t{9}",
                            response.StatusCode == 200 ? "OK": "FAIL",
                            elapsed,
                            request.UserHostAddress,
                            request.UserHostName != null && request.UserHostName.Length > 0  ? "anonymous" : request.UserHostName,
                            pharmacy,
                            aic,
                            mailBox,
                            lang,
                            response.StatusCode, 
                            response.StatusDescription
                                .Replace('\r', ' ')
                                .Replace('\n', ' ')
                                .Replace('\t', ' ')
                                .Trim()                        
                            );

                try
                {
                    Tools.ReplyJSon(response, "id", transactionID);
                    response.Flush();
                }
                catch(Exception ex)
                {
                    if (Logger.Enabled)
                        Logger.Write("Error flushing response - {0}", ex);
                }
            }

        }
    }
}