using System;
using System.Collections.Generic;
using System.Web;
using System.IO;
using System.Web.Configuration;

namespace webapp
{    
    public class PagesHttpHandler : IHttpHandler
    {
        public PagesHttpHandler()
        {
            //if (Logger.Enabled) Logger.Write("creating new instance of PagesHttpHandler ...");            
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

            ITextUtils utils = new ITextUtils();            

            string documentRoot = WebConfigurationManager.AppSettings["documentRoot"];
            if (!Path.IsPathRooted(documentRoot)) 
                documentRoot = Path.GetFullPath(context.Server.MapPath("..") + documentRoot);
            if (!documentRoot.EndsWith(@"\")) documentRoot += @"\";
            
            string outputPath = WebConfigurationManager.AppSettings["outputPath"];
            if (!Path.IsPathRooted(outputPath))
                outputPath = Path.GetFullPath(context.Server.MapPath("..") + outputPath);            
            if (!outputPath.EndsWith(@"\")) outputPath += @"\";

            try
            {  
                int n = request.Path.IndexOf("/pages/");
                n += 7;

                string f_id = request.Path.Substring(n);
                if (!f_id.StartsWith("F"))
                {
                    f_id = String.Format("F{0:D7}",
                        Int32.Parse(f_id));
                }

                string pdf = documentRoot;
                pdf += f_id;
                pdf += ".pdf";

                FileInfo pdfInf = new FileInfo(pdf);

                if (!pdfInf.Exists)
                {
                    if (Logger.Enabled) Logger.Write("file {0} not found", pdf);
                    response.StatusCode = 404;
                    response.StatusDescription = "Not Found";
                    Tools.ReplyJSon(response);
                    response.Flush();
                    return;
                }

                int page = -1;

                if (request.Params["page"] != null)
                    Int32.TryParse(request.Params["page"], out page);
                else if (request.QueryString["page"] != null) 
                    Int32.TryParse(request.QueryString["page"], out page);
                                
                if (page == -1)
                {
                    response.StatusCode = 200;
                    Tools.ReplyJSon(response, "id", f_id, "pages", utils.GetNumberOfPdfPages(pdf));                    
                    response.Flush();
                }
                else
                {
                    string outfile = outputPath;
                    outfile += (Int32.Parse(
                                    f_id.Substring(5).TrimStart('0'))
                                    % 256)
                        .ToString("X2")
                        .ToUpper();                    
                    DirectoryInfo outdir = new DirectoryInfo(outfile);

                    if (!outdir.Exists) 
                    {
                        try
                        {
                            Directory.CreateDirectory(outdir.FullName);
                        }
                        catch (Exception e)
                        {
                            Logger.Write("Error: web app does not have wrtie access rigth to {0}, " +
                                "please modify directory permissions to make directory writable " + 
                                "from this Application Pool - details: {1}", outdir, e);
                            response.StatusCode = 403;
                            response.StatusDescription = "Forbidden";
                            Tools.ReplyJSon(response);
                            response.Flush();
                            return;
                        }
                    }

                    string ext = request.Params["gsext"];
                    if (ext == null) ext = request.QueryString["gsext"];
                    if (ext == null) ext = "png";
                    if (ext.StartsWith(".")) ext = ext.Substring(1);

                    string command = request.Params["gsopts"];
                    if (command == null) command = request.QueryString["gsopts"];
                    if (command == null) command = "";

                    int timeout = -1;

                    if (request.Params["timeout"] != null)
                    {
                        int.TryParse(request.Params["timeout"], out timeout);
                    }
                    else if (request.QueryString["timeout"] != null)
                    {
                        int.TryParse(request.QueryString["timeout"], out timeout);
                    }
                                        
                    outfile += @"\";
                    outfile += f_id + "[" + page + "]." + ext;
                    
                    bool nocache = false;    
                
                    if (request.Params["nocache"] != null) {
                        nocache = request.Params["nocache"].ToLower().Equals("true");
                    }
                    else if (request.QueryString["nocache"] != null)
                    {
                        nocache = request.QueryString["nocache"].ToLower().Equals("true");
                    }

                    bool cached = false;

                    if (!nocache)
                    {
                        FileInfo f = new FileInfo(outfile);
                        cached = (f.Exists ? (
                                (f.LastWriteTime.ToFileTime() > pdfInf.LastWriteTime.ToFileTime())
                                ) : false);
                    }
                    
                    if (!cached)
                    {
                        DateTime start = DateTime.Now;
                        GhostscriptWrapper wrapper = new GhostscriptWrapper();

                        if (!wrapper.ConvertPage(command, pdf, outfile, timeout))
                        {
                            if (wrapper.IsGhostscriptInstalled)
                            {
                                if (Logger.Enabled)
                                    Logger.Write(
                                        "error: conversion failure from {0} to {1}[{2}]",
                                            pdf, outfile, page);
                                response.StatusCode = 500;
                                response.StatusDescription = "Server Error";
                                Tools.ReplyJSon(response);
                                response.Flush();
                            }
                            else
                            {
                                if (Logger.Enabled) Logger.Write("error: conversion unavailable from {0} to {1}[{2}] - "
                                    + "GHOSTSCRIPT NOT INSTALLED OR NOT SET IN SYSTEM PATH!",
                                    pdf, outfile, page);
                                response.StatusCode = 503;
                                response.StatusDescription = "Service Unavailable";
                                Tools.ReplyJSon(response);
                                response.Flush();
                            }
                            return;
                        }
                        else
                        {
                            if (Logger.Enabled) 
                                Logger.Write(
                                    "conversion from {0} ({1}Kb) to {2} ({3}Kb) in {4:F2}\"",
                                    Path.GetFileName(pdf), (new FileInfo(pdf).Length / 1024),
                                    Path.GetFileName(outfile), (new FileInfo(outfile).Length / 1024),
                                    (((TimeSpan)(DateTime.Now - start)).TotalMilliseconds / 1000));
                        }
                    }

                    response.ContentType = "image/" + ext;
                    response.BinaryWrite(File.ReadAllBytes(outfile));
                    response.StatusCode = 200;
                    response.Flush();
                }

            }
            catch (Exception e)
            {
                Logger.Write("PagesHandler exception {0}", e);
                response.StatusCode = 500;
                response.StatusDescription = "SERVER ERROR - " + e.Message;
                Tools.ReplyJSon(response);
                response.Flush();
            }

        }

    }

}
