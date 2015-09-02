using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.DirectoryServices;
using System.Threading;
using System.IO;

namespace adfinder
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();

            txtConfigPassword.PasswordChar = '*';

            txtConfigUrl.Text = "LDAP://2kfd3";
            txtConfigUser.Text = "Administrator";
            txtConfigPassword.Text = "Mariv+96";

            txtFindKey.Text = "mail";
            txtFindValue.Text = "dm@farmadati.it";
            txtDisplayProperty.Text = "CN";            

            try
            {
                StreamReader r = new StreamReader("config.ini");

                for (; ; ) 
                {
                    string line = r.ReadLine();
                    
                    if (line == null) break;                    
                    line = line.Trim(' ', '\t');
                    
                    if (line.Length == 0) continue;
                    if (line.StartsWith("#")) continue;
                    
                    string[] kv = line.Split('=');
                    string key = kv[0].Trim(' ', '\t');

                    try
                    {
                        string value = kv[1].Trim(' ', '\t');
                        switch (key)
                        { 
                            case "key":
                                txtFindKey.Text = value;
                                break;
                            case "value":
                                txtFindValue.Text = value;
                                break;
                            case "display":
                                txtDisplayProperty.Text = value;
                                break;
                        }
                    }
                    catch { }

                }

                r.Close();

            }
            catch { }

        }

        private void dowork()
        {
            try
            {
                using (DirectoryEntry adEntry = new DirectoryEntry(txtConfigUrl.Text.Trim()))
                {
                    DateTime start = DateTime.Now;

                    adEntry.Username = txtConfigUser.Text.Trim();
                    adEntry.Password = txtConfigPassword.Text;

                    using (DirectorySearcher adSearcher = new DirectorySearcher(adEntry))
                    {
                        adSearcher.Filter = (txtFindKey.Text + "=" + txtFindValue.Text);
                        SearchResultCollection coll = adSearcher.FindAll();

                        int count = 0;
                        foreach (SearchResult item in coll)
                        {
                            DirectoryEntry entry = item.GetDirectoryEntry();
                            textBox2.Text += " > ";
                            textBox2.Text += entry.Properties[txtDisplayProperty.Text.Trim()].Value;
                            textBox2.Text += "\r\n";
                        }
                        textBox2.Text += "\r\n";
                        textBox2.Text += "Total ." + (count) + " results.\r\nQuery executed in "
                            + String.Format("{0:F2}\"", ((DateTime.Now - start).TotalMilliseconds) / 1000);
                        textBox2.Select(textBox2.Text.Length, 0);
                    }

                    adEntry.Close();
                }
            }
            catch (Exception ex)
            {
                textBox2.Text += "ERROR ..:\r\n" + ex.Message;
                textBox2.Select(textBox2.Text.Length, 0);
            }

            tabControl1.Enabled = true;
        }

        private void button2_Click_1(object sender, EventArgs e)
        {            
            textBox2.Text = "";
            textBox2.Text += "Starting search ...\r\n";
            tabControl1.Enabled = false;

            dowork();
            //new Thread(w => dowork()).Start();
                        
        }

        private void button1_Click(object sender, EventArgs e)
        {
            Application.Exit();
        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            try 
            {
                StreamWriter w = new StreamWriter("config.ini");
                w.Write("key=");
                w.WriteLine(txtFindKey.Text);
                w.Write("value=");
                w.WriteLine(txtFindValue.Text);
                w.Write("display=");
                w.WriteLine(txtDisplayProperty.Text);
                w.Close();
            }
            catch{}
        }


    }
}
