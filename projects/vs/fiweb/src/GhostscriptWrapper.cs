using System;
using System.Collections.Generic;
using System.IO;
using System.Diagnostics;
using System.Web;

namespace webapp
{
    public class GhostscriptWrapper
    {        
        static readonly string GSEXE = 
            System.Environment.Is64BitOperatingSystem ?
                "gswin64c.exe" : "gswin32c.exe";

        string opts = "-dMaxBitmap=500000000 " +                    
		                "-dAlignToPixels=0 " +
                        "-dGridFitTT=0 " +          
		                "-dTextAlphaBits=4 " +
		                "-dGraphicsAlphaBits=4 " +
		                "-r120x120";        

        public string Options
        {
            get { return opts; }
            set { opts = value; }
        }

        public bool IsGhostscriptInstalled
        {
            get 
            {
                Process p = new Process();
                try
                {
                    p.StartInfo.FileName = GSEXE;
                    p.StartInfo.Arguments = "-dNOPROMPT -version";
                    p.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                    p.Start();
                    p.WaitForExit();
                    return (p.ExitCode == 0);
                }
                catch (Exception e)
                {
                    if (Logger.Enabled) Logger.Write("exception running {0} {1} - reason: {3}",
                        p.StartInfo.FileName, p.StartInfo.Arguments, e);
                    if (Logger.Enabled) Logger.Write("Error: Ghoscript seems to be missing in our System Path. Please " +
                        "install Ghostscript and add it to System Environment Path before " +
                        "running this web app !!!");
                    return false;   
                }
            }        
        }

        public bool ConvertPage(string inpdf, string outpng, int page)
        {
            Process p = new Process();

            try
            {
                DateTime start = DateTime.Now;

                string args = String.Format (
                        "-q -dQUIET -dPARANOIDSAFER -dBATCH -dNOPAUSE -dNOPROMPT " + 
                            "-sDEVICE=pngalpha " +         
                            "-dFirstPage={0} -dLastPage={0} " +
		                    opts + " -sOutputFile=\"{1}\" " +
                            "\"{2}\"",
                        page, outpng, inpdf);

                p.StartInfo.FileName = GSEXE;
                p.StartInfo.Arguments = args;
                p.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
                p.Start();
                p.WaitForExit();

                if (p.ExitCode == 0) 
                {
                    if (Logger.Enabled) Logger.Write("conversion success := {0} ({1}Kb) => {2}({3}Kb) in {4} ms",                        
                        Path.GetFileName(inpdf), (new FileInfo(inpdf).Length / 1024), 
                        Path.GetFileName(outpng), (new FileInfo(outpng).Length / 1024), 
                        ((TimeSpan)(DateTime.Now - start)).TotalMilliseconds);
                    return true;
                }
                else 
                {
                    Logger.Write("conversion failure := exit code {0} , command {1} {2}",
                        p.ExitCode, p.StartInfo.FileName, p.StartInfo.Arguments);
                    return false;
                }                
                
            }
            catch (Exception e)
            {
                Logger.Write("exception running {0} {1} - reason: {3}",
                    p.StartInfo.FileName, p.StartInfo.Arguments, e);
                return false;   
            }
        
        }

    }

}