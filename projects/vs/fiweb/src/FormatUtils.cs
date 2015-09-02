using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Configuration;

namespace webapp
{
    public class FormatUtils
    {
        public static void ReplyJSon(HttpResponse response, params object[] args)
        {
            response.ContentType = "application/json; charset=utf-8";
            response.Write("{ ");
            response.Write(" \"http\": { \"code\": ");
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
            response.Write("\" } ");            

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
            response.Write("}");
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

        public static string GetBaseUrl() 
        { 
            return @"https://drive.google.com/folderview?id=0B8O5tJ0cWwNLfi1xNnZ6VmZaQkp4TDRGWVdwZ3JRTE5wVUVSSkN4UGRuTk5SdDRXWVRfbjA&usp=sharing"; 
        }
        
    }

    

}
