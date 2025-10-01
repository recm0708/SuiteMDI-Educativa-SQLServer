namespace bd_A7_RubenCanizares.Presentacion
{
    partial class frmCambiarPassword
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
            this.lblCodigo = new System.Windows.Forms.Label();
            this.tbCodigo = new System.Windows.Forms.TextBox();
            this.cbResetear = new System.Windows.Forms.CheckBox();
            this.lblAnterior = new System.Windows.Forms.Label();
            this.tbAnterior = new System.Windows.Forms.TextBox();
            this.lblNueva = new System.Windows.Forms.Label();
            this.tbNueva = new System.Windows.Forms.TextBox();
            this.btnOk = new System.Windows.Forms.Button();
            this.btnCancelar = new System.Windows.Forms.Button();
            this.tbConfirmar = new System.Windows.Forms.TextBox();
            this.lblConfirmar = new System.Windows.Forms.Label();
            this.SuspendLayout();
            // 
            // lblCodigo
            // 
            this.lblCodigo.AutoSize = true;
            this.lblCodigo.Location = new System.Drawing.Point(310, 154);
            this.lblCodigo.Name = "lblCodigo";
            this.lblCodigo.Size = new System.Drawing.Size(43, 13);
            this.lblCodigo.TabIndex = 0;
            this.lblCodigo.Text = "Código:";
            // 
            // tbCodigo
            // 
            this.tbCodigo.Location = new System.Drawing.Point(359, 151);
            this.tbCodigo.Name = "tbCodigo";
            this.tbCodigo.Size = new System.Drawing.Size(90, 20);
            this.tbCodigo.TabIndex = 1;
            // 
            // cbResetear
            // 
            this.cbResetear.AutoSize = true;
            this.cbResetear.Location = new System.Drawing.Point(368, 177);
            this.cbResetear.Name = "cbResetear";
            this.cbResetear.Size = new System.Drawing.Size(69, 17);
            this.cbResetear.TabIndex = 2;
            this.cbResetear.Text = "Resetear";
            this.cbResetear.UseVisualStyleBackColor = true;
            // 
            // lblAnterior
            // 
            this.lblAnterior.AutoSize = true;
            this.lblAnterior.Location = new System.Drawing.Point(307, 211);
            this.lblAnterior.Name = "lblAnterior";
            this.lblAnterior.Size = new System.Drawing.Size(46, 13);
            this.lblAnterior.TabIndex = 3;
            this.lblAnterior.Text = "Anterior:";
            // 
            // tbAnterior
            // 
            this.tbAnterior.Location = new System.Drawing.Point(359, 208);
            this.tbAnterior.Name = "tbAnterior";
            this.tbAnterior.Size = new System.Drawing.Size(90, 20);
            this.tbAnterior.TabIndex = 4;
            this.tbAnterior.UseSystemPasswordChar = true;
            // 
            // lblNueva
            // 
            this.lblNueva.AutoSize = true;
            this.lblNueva.Location = new System.Drawing.Point(307, 237);
            this.lblNueva.Name = "lblNueva";
            this.lblNueva.Size = new System.Drawing.Size(42, 13);
            this.lblNueva.TabIndex = 5;
            this.lblNueva.Text = "Nueva:";
            // 
            // tbNueva
            // 
            this.tbNueva.Location = new System.Drawing.Point(359, 234);
            this.tbNueva.Name = "tbNueva";
            this.tbNueva.Size = new System.Drawing.Size(90, 20);
            this.tbNueva.TabIndex = 6;
            this.tbNueva.UseSystemPasswordChar = true;
            // 
            // btnOk
            // 
            this.btnOk.Location = new System.Drawing.Point(287, 298);
            this.btnOk.Name = "btnOk";
            this.btnOk.Size = new System.Drawing.Size(75, 23);
            this.btnOk.TabIndex = 7;
            this.btnOk.Text = "Aceptar";
            this.btnOk.UseVisualStyleBackColor = true;
            this.btnOk.Click += new System.EventHandler(this.btnOk_Click);
            // 
            // btnCancelar
            // 
            this.btnCancelar.DialogResult = System.Windows.Forms.DialogResult.Cancel;
            this.btnCancelar.Location = new System.Drawing.Point(368, 298);
            this.btnCancelar.Name = "btnCancelar";
            this.btnCancelar.Size = new System.Drawing.Size(75, 23);
            this.btnCancelar.TabIndex = 8;
            this.btnCancelar.Text = "Cancelar";
            this.btnCancelar.UseVisualStyleBackColor = true;
            this.btnCancelar.Click += new System.EventHandler(this.btnCancelar_Click);
            // 
            // tbConfirmar
            // 
            this.tbConfirmar.Location = new System.Drawing.Point(359, 260);
            this.tbConfirmar.Name = "tbConfirmar";
            this.tbConfirmar.Size = new System.Drawing.Size(90, 20);
            this.tbConfirmar.TabIndex = 10;
            this.tbConfirmar.UseSystemPasswordChar = true;
            // 
            // lblConfirmar
            // 
            this.lblConfirmar.AutoSize = true;
            this.lblConfirmar.Location = new System.Drawing.Point(299, 263);
            this.lblConfirmar.Name = "lblConfirmar";
            this.lblConfirmar.Size = new System.Drawing.Size(54, 13);
            this.lblConfirmar.TabIndex = 9;
            this.lblConfirmar.Text = "Confirmar:";
            // 
            // frmCambiarPassword
            // 
            this.AcceptButton = this.btnOk;
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.CancelButton = this.btnCancelar;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.tbConfirmar);
            this.Controls.Add(this.lblConfirmar);
            this.Controls.Add(this.btnCancelar);
            this.Controls.Add(this.btnOk);
            this.Controls.Add(this.tbNueva);
            this.Controls.Add(this.lblNueva);
            this.Controls.Add(this.tbAnterior);
            this.Controls.Add(this.lblAnterior);
            this.Controls.Add(this.cbResetear);
            this.Controls.Add(this.tbCodigo);
            this.Controls.Add(this.lblCodigo);
            this.Name = "frmCambiarPassword";
            this.Text = "frmCambiarPassword";
            this.Load += new System.EventHandler(this.frmCambiarPassword_Load_1);
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblCodigo;
        private System.Windows.Forms.TextBox tbCodigo;
        private System.Windows.Forms.CheckBox cbResetear;
        private System.Windows.Forms.Label lblAnterior;
        private System.Windows.Forms.TextBox tbAnterior;
        private System.Windows.Forms.Label lblNueva;
        private System.Windows.Forms.TextBox tbNueva;
        private System.Windows.Forms.Button btnOk;
        private System.Windows.Forms.Button btnCancelar;
        private System.Windows.Forms.TextBox tbConfirmar;
        private System.Windows.Forms.Label lblConfirmar;
    }
}