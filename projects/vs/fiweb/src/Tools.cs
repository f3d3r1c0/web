using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace webapp
{
    public class Tools
    {
        static object transaction_lock = "";
        static Int32 transaction_counter = 0;
        static Random rnd = new Random(-84612123);

        public static string NextId()
        {
            lock (transaction_lock)
            {
                transaction_counter ++;
                transaction_counter %= 1000000000;
                return String.Format("{0:D9}-{1:D9}", rnd.Next(1000000000), transaction_counter);
            }            
        }
        
        public static void ReplyJSon(HttpResponse response, params object[] args)
        {
            response.ContentType = "application/json; charset=utf-8";
            response.Write("{ ");
            response.Write("\"http\": { \"code\": ");
            response.Write(response.StatusCode);
            response.Write(", ");
            response.Write(" \"description\": \"");

            if (response.StatusDescription != null)
                response.Write(response.StatusDescription
                        .Replace("'", @"\'")                
                        .Replace('"', '\'')                
                        .Replace('\r', ' ')
                        .Replace('\n', ' ')
                        .Trim(' ', '\t'));
            response.Write("\" }");            

            for (int i = 0; args != null && i < args.Length; i++)
            {
                response.Write(",");
                response.Write(" \"");
                response.Write(args[i++]);
                response.Write("\": ");
                if (args[i].GetType() == typeof(string))
                {
                    response.Write("\"");
                    response.Write(((string)args[i])
                            .Replace("'", @"\'")
                            .Replace('"', '\'')
                            .Replace('\r', ' ')
                            .Replace('\n', ' ')
                            .Trim(' ', '\t'));
                    response.Write("\"");
                }
                else
                {
                    response.Write(args[i]);
                }
            }
            response.Write(" }");
        }

        public static string GetPreferredLanguageId(string [] userLanguages)
        {
            foreach (string lang in userLanguages)
            {                
                if (lang.ToLower().StartsWith("it")) return "it";
                else if (lang.ToLower().StartsWith("en")) return "en";
                else if (lang.ToLower().StartsWith("de")) return "de";
                else if (lang.ToLower().StartsWith("es")) return "es";
                else if (lang.ToLower().StartsWith("fr")) return "fr";
            }
            return "it";
        }

        public static int GetBrowserId(HttpRequest request)
        {
            string ua = request.UserAgent.ToLower();
            if (ua.IndexOf("droid") >= 0)
            {
                return 1;
            }
            else if (ua.IndexOf("ios") >= 0
                || ua.IndexOf("osx") >= 0
                || ua.IndexOf("ipad") >= 0)
            {
                return 2;
            }
            else if (ua.IndexOf("chrome") >= 0)
            {
                return 3;
            }
            else 
            { 
                return 0;  
            }
        }

    }

    

}
