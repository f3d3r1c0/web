using System;
using System.Collections.Generic;
using System.IO;
using System.Text;

using iTextSharp.text;
using iTextSharp.text.pdf;

namespace webapp
{
    public class ITextUtils
    {

        public int GetNumberOfPdfPages(string pdfinput)
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

        public int SplitPdf(string pdfinput, string outdir)
        {
            PdfReader reader = null;
            Document document = null;
            PdfCopy pdfCopyProvider = null;
            PdfImportedPage importedPage = null;

            int count = 0;
            if (!outdir.EndsWith(@"\")) outdir += @"\";

            try
            {
                reader = new PdfReader(pdfinput);
                int n = reader.NumberOfPages;

                for (int i = 1; i <= n; i++)
                {
                    string outpath = outdir;
                    outpath += Path.GetFileNameWithoutExtension(pdfinput);
                    outpath += "-" + (i);
                    outpath += ".pdf";

                    document = new Document(reader.GetPageSizeWithRotation(i));
                    pdfCopyProvider = new PdfCopy(
                            document, new System.IO.FileStream(
                                outpath, System.IO.FileMode.Create));
                    document.Open();
                    importedPage = pdfCopyProvider.GetImportedPage(reader, i);
                    pdfCopyProvider.AddPage(importedPage);

                    try { document.Close(); }
                    catch { }

                    count++;
                }

            }
            catch
            {
                count = -1;
            }
            finally
            {
                if (reader != null) try { reader.Close(); }
                    catch { }
            }

            return count;

        }

    }

}
