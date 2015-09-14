﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;
using System.Configuration;
using System.Runtime.Serialization.Json;
using System.Data.SqlClient;
using System.IO;
using System.Data;
using System.Collections;
using System.Web.Configuration;

using iTextSharp.text;
using iTextSharp.text.pdf;

namespace webapp
{
    [DataContract]
    internal class DocumentRequest
    {
        [DataMember]
        internal string aic = null;
    }

    [DataContract]
    internal class DocumentResponse
    {
        [DataMember]
        internal string filename;

        [DataMember]
        internal string language;

        [DataMember]
        internal int pagesCount;

        [DataMember]
        internal bool isDefaultLanguage;
    }

    public class ArchiveHttpHandler : IHttpHandler
    {
       private string connectionString;
        private string documentRoot;

        public ArchiveHttpHandler()
        {
            connectionString = ConfigurationManager.ConnectionStrings["farmadati"].ConnectionString;
            documentRoot = WebConfigurationManager.AppSettings["documentRoot"] != null ?
                                    WebConfigurationManager.AppSettings["documentRoot"] : @"C:\Temp\";
            if (!documentRoot.EndsWith(@"\")) documentRoot += @"\";
        }

        public bool IsReusable
        {
            get { return true; }
        }

        private int countPdfPages(string pdfinput)
        { 
            PdfReader reader = null;
            try
            {
                if (!new FileInfo(pdfinput).Exists) return -1;
                reader = new PdfReader(pdfinput);
                return reader.NumberOfPages;
            }
            catch(Exception e)
            {
                if (Logger.Enabled) Logger.Write("PdfReader Error: {0}", e);
                return -2;
            }
            finally
            {
                if (reader != null) try { reader.Close(); }
                    catch { }
            }
        }

        public void ProcessRequest(HttpContext context)
        {
            HttpRequest request = context.Request;
            HttpResponse response = context.Response;

            try
            {
                DataContractJsonSerializer deserializer = new DataContractJsonSerializer(typeof(DocumentRequest));
                DocumentRequest form = (DocumentRequest) deserializer.ReadObject(request.InputStream);

                if (form.aic != null)
                {
                    Stream stream = response.OutputStream;
                    DataContractJsonSerializer serializer = new DataContractJsonSerializer(typeof(DocumentResponse));
                    
                    using (SqlConnection connection = new SqlConnection(connectionString))
                    {
                        using (SqlCommand command = new SqlCommand(
                            String.Concat(
                                "SELECT [FDI_T227], [FDI_T483] ",
                                "   FROM [DBFarmadati_WEB].[dbo].[TDF] ",
                                "   WHERE [FDI_T218]='", form.aic, "'")
                                    , connection))
                        {
                            command.CommandType = CommandType.Text;
                            connection.Open();

                            using (SqlDataReader sqlreader = command.ExecuteReader(CommandBehavior.CloseConnection))
                            {
                                if (sqlreader.HasRows)
                                {
                                    ArrayList lst = new ArrayList();
                                    response.ContentType = "application/json";
                                    
                                    while (sqlreader.Read())
                                    {
                                        DocumentResponse entry = new DocumentResponse();
                                        entry.language = sqlreader.IsDBNull(1) ? "" : sqlreader.GetString(1);
                                        entry.pagesCount = countPdfPages (documentRoot + sqlreader.GetString(0));
                                        entry.filename = sqlreader.IsDBNull(0) ? "": sqlreader.GetString(0).ToUpper().Replace(".PDF", "");
                                        lst.Add(entry);                                        
                                    }

                                    bool hasUserLanguage = false;

                                    foreach (string lang in request.UserLanguages)
                                    {
                                        for (int i = 0; !hasUserLanguage && i < lst.Count; i++)
                                        {
                                            DocumentResponse entry = (DocumentResponse) lst[i];
                                            if (lang.ToLower().StartsWith(entry.language.ToLower().Substring(0, 2)))
                                            {
                                                entry.isDefaultLanguage = true;
                                                hasUserLanguage = true;
                                                break;
                                            }
                                        }                                        
                                    }

                                    if (!hasUserLanguage) ((DocumentResponse)lst[0]).isDefaultLanguage = true;

                                    serializer.WriteObject(stream, lst.ToArray());

                                }
                                else
                                {
                                    //response.StatusCode = 404;
                                    //response.StatusDescription = "Not Found";
                                    throw new Exception("AIC not found");
                                }
                            }
                        }
                    }
                }

            }
            catch (Exception e)
            {
                response.StatusCode = 500;
                response.StatusDescription = "Server Error - " + e.Message;
            }

        }
    }
}