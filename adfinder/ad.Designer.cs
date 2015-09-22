namespace adfinder
{
    partial class ad
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.tabPage2 = new System.Windows.Forms.TabPage();
            this.txtDisplayProperty = new System.Windows.Forms.TextBox();
            this.txtFindKey = new System.Windows.Forms.TextBox();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.txtFindValue = new System.Windows.Forms.TextBox();
            this.label3 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.button2 = new System.Windows.Forms.Button();
            this.label1 = new System.Windows.Forms.Label();
            this.button1 = new System.Windows.Forms.Button();
            this.tabPage1 = new System.Windows.Forms.TabPage();
            this.txtConfigPassword = new System.Windows.Forms.TextBox();
            this.txtConfigUser = new System.Windows.Forms.TextBox();
            this.label6 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.txtConfigUrl = new System.Windows.Forms.TextBox();
            this.label4 = new System.Windows.Forms.Label();
            this.tabControl1 = new System.Windows.Forms.TabControl();
            this.tabPage2.SuspendLayout();
            this.tabPage1.SuspendLayout();
            this.tabControl1.SuspendLayout();
            this.SuspendLayout();
            // 
            // tabPage2
            // 
            this.tabPage2.Controls.Add(this.txtDisplayProperty);
            this.tabPage2.Controls.Add(this.txtFindKey);
            this.tabPage2.Controls.Add(this.textBox2);
            this.tabPage2.Controls.Add(this.txtFindValue);
            this.tabPage2.Controls.Add(this.label3);
            this.tabPage2.Controls.Add(this.label2);
            this.tabPage2.Controls.Add(this.button2);
            this.tabPage2.Controls.Add(this.label1);
            this.tabPage2.Controls.Add(this.button1);
            this.tabPage2.Location = new System.Drawing.Point(4, 22);
            this.tabPage2.Name = "tabPage2";
            this.tabPage2.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage2.Size = new System.Drawing.Size(387, 227);
            this.tabPage2.TabIndex = 1;
            this.tabPage2.Text = "LDAP Search";
            this.tabPage2.UseVisualStyleBackColor = true;
            // 
            // txtDisplayProperty
            // 
            this.txtDisplayProperty.Location = new System.Drawing.Point(128, 22);
            this.txtDisplayProperty.Name = "txtDisplayProperty";
            this.txtDisplayProperty.Size = new System.Drawing.Size(105, 20);
            this.txtDisplayProperty.TabIndex = 13;
            this.txtDisplayProperty.Text = "User";
            // 
            // txtFindKey
            // 
            this.txtFindKey.Location = new System.Drawing.Point(8, 21);
            this.txtFindKey.Name = "txtFindKey";
            this.txtFindKey.Size = new System.Drawing.Size(105, 20);
            this.txtFindKey.TabIndex = 11;
            this.txtFindKey.Text = "mail";
            // 
            // textBox2
            // 
            this.textBox2.BackColor = System.Drawing.Color.White;
            this.textBox2.Location = new System.Drawing.Point(6, 98);
            this.textBox2.Multiline = true;
            this.textBox2.Name = "textBox2";
            this.textBox2.ReadOnly = true;
            this.textBox2.Size = new System.Drawing.Size(375, 108);
            this.textBox2.TabIndex = 9;
            // 
            // txtFindValue
            // 
            this.txtFindValue.Location = new System.Drawing.Point(9, 60);
            this.txtFindValue.Name = "txtFindValue";
            this.txtFindValue.Size = new System.Drawing.Size(224, 20);
            this.txtFindValue.TabIndex = 6;
            this.txtFindValue.Text = "dispositivimedici@farmadati.it";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(125, 6);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(83, 13);
            this.label3.TabIndex = 12;
            this.label3.Text = "Display Property";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(6, 46);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(58, 13);
            this.label2.TabIndex = 10;
            this.label2.Text = "Filter value";
            // 
            // button2
            // 
            this.button2.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.button2.Location = new System.Drawing.Point(292, 8);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(89, 27);
            this.button2.TabIndex = 8;
            this.button2.Text = "Search";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click_1);
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(6, 6);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(49, 13);
            this.label1.TabIndex = 7;
            this.label1.Text = "Filter key";
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(292, 41);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(92, 27);
            this.button1.TabIndex = 5;
            this.button1.Text = "Exit";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // tabPage1
            // 
            this.tabPage1.Controls.Add(this.txtConfigPassword);
            this.tabPage1.Controls.Add(this.txtConfigUser);
            this.tabPage1.Controls.Add(this.label6);
            this.tabPage1.Controls.Add(this.label5);
            this.tabPage1.Controls.Add(this.txtConfigUrl);
            this.tabPage1.Controls.Add(this.label4);
            this.tabPage1.Location = new System.Drawing.Point(4, 22);
            this.tabPage1.Name = "tabPage1";
            this.tabPage1.Padding = new System.Windows.Forms.Padding(3);
            this.tabPage1.Size = new System.Drawing.Size(387, 227);
            this.tabPage1.TabIndex = 0;
            this.tabPage1.Text = "LDAP Config";
            this.tabPage1.UseVisualStyleBackColor = true;
            // 
            // txtConfigPassword
            // 
            this.txtConfigPassword.Location = new System.Drawing.Point(77, 68);
            this.txtConfigPassword.Name = "txtConfigPassword";
            this.txtConfigPassword.Size = new System.Drawing.Size(100, 20);
            this.txtConfigPassword.TabIndex = 6;
            this.txtConfigPassword.Text = "LDAP://";
            // 
            // txtConfigUser
            // 
            this.txtConfigUser.Location = new System.Drawing.Point(77, 39);
            this.txtConfigUser.Name = "txtConfigUser";
            this.txtConfigUser.Size = new System.Drawing.Size(100, 20);
            this.txtConfigUser.TabIndex = 5;
            this.txtConfigUser.Text = "LDAP://";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(15, 75);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(53, 13);
            this.label6.TabIndex = 4;
            this.label6.Text = "User Pwd";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(15, 47);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(43, 13);
            this.label5.TabIndex = 3;
            this.label5.Text = "User ID";
            // 
            // txtConfigUrl
            // 
            this.txtConfigUrl.Location = new System.Drawing.Point(77, 13);
            this.txtConfigUrl.Name = "txtConfigUrl";
            this.txtConfigUrl.Size = new System.Drawing.Size(235, 20);
            this.txtConfigUrl.TabIndex = 1;
            this.txtConfigUrl.Text = "LDAP://";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(15, 16);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(29, 13);
            this.label4.TabIndex = 0;
            this.label4.Text = "URL";
            // 
            // tabControl1
            // 
            this.tabControl1.Controls.Add(this.tabPage2);
            this.tabControl1.Controls.Add(this.tabPage1);
            this.tabControl1.Location = new System.Drawing.Point(3, 2);
            this.tabControl1.Name = "tabControl1";
            this.tabControl1.SelectedIndex = 0;
            this.tabControl1.Size = new System.Drawing.Size(395, 253);
            this.tabControl1.TabIndex = 5;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(401, 255);
            this.Controls.Add(this.tabControl1);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.MaximizeBox = false;
            this.Name = "Form1";
            this.Text = "Active directory Finder";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.tabPage2.ResumeLayout(false);
            this.tabPage2.PerformLayout();
            this.tabPage1.ResumeLayout(false);
            this.tabPage1.PerformLayout();
            this.tabControl1.ResumeLayout(false);
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.TabPage tabPage2;
        private System.Windows.Forms.TextBox txtDisplayProperty;
        private System.Windows.Forms.TextBox txtFindKey;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.TextBox txtFindValue;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.TabPage tabPage1;
        private System.Windows.Forms.TabControl tabControl1;
        private System.Windows.Forms.TextBox txtConfigUrl;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.TextBox txtConfigUser;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.TextBox txtConfigPassword;


    }
}

