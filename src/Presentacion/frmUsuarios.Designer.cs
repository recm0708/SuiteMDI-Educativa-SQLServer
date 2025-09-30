namespace bd_A7_RubenCanizares.Presentacion
{
    partial class frmUsuarios
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
            this.btnBuscar = new System.Windows.Forms.Button();
            this.btnRefrescar = new System.Windows.Forms.Button();
            this.tbCodigo = new System.Windows.Forms.TextBox();
            this.dgvUsuarios = new System.Windows.Forms.DataGridView();
            this.btnEliminar = new System.Windows.Forms.Button();
            this.btnGuardarEdicion = new System.Windows.Forms.Button();
            this.colCodigo = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colNombre = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colSegundoNombre = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colApellido = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colSegundoApellido = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colApellidoCasada = new System.Windows.Forms.DataGridViewTextBoxColumn();
            this.colEmail = new System.Windows.Forms.DataGridViewTextBoxColumn();
            ((System.ComponentModel.ISupportInitialize)(this.dgvUsuarios)).BeginInit();
            this.SuspendLayout();
            // 
            // lblCodigo
            // 
            this.lblCodigo.AutoSize = true;
            this.lblCodigo.Location = new System.Drawing.Point(11, 15);
            this.lblCodigo.Name = "lblCodigo";
            this.lblCodigo.Size = new System.Drawing.Size(43, 13);
            this.lblCodigo.TabIndex = 0;
            this.lblCodigo.Text = "Código:";
            // 
            // btnBuscar
            // 
            this.btnBuscar.Location = new System.Drawing.Point(186, 10);
            this.btnBuscar.Name = "btnBuscar";
            this.btnBuscar.Size = new System.Drawing.Size(75, 23);
            this.btnBuscar.TabIndex = 1;
            this.btnBuscar.Text = "Buscar";
            this.btnBuscar.UseVisualStyleBackColor = true;
            this.btnBuscar.Click += new System.EventHandler(this.btnBuscar_Click);
            // 
            // btnRefrescar
            // 
            this.btnRefrescar.Location = new System.Drawing.Point(267, 10);
            this.btnRefrescar.Name = "btnRefrescar";
            this.btnRefrescar.Size = new System.Drawing.Size(75, 23);
            this.btnRefrescar.TabIndex = 2;
            this.btnRefrescar.Text = "Refrescar";
            this.btnRefrescar.UseVisualStyleBackColor = true;
            this.btnRefrescar.Click += new System.EventHandler(this.btnRefrescar_Click);
            // 
            // tbCodigo
            // 
            this.tbCodigo.Location = new System.Drawing.Point(60, 12);
            this.tbCodigo.Name = "tbCodigo";
            this.tbCodigo.Size = new System.Drawing.Size(120, 20);
            this.tbCodigo.TabIndex = 3;
            // 
            // dgvUsuarios
            // 
            this.dgvUsuarios.AllowUserToAddRows = false;
            this.dgvUsuarios.AllowUserToDeleteRows = false;
            this.dgvUsuarios.AutoSizeColumnsMode = System.Windows.Forms.DataGridViewAutoSizeColumnsMode.AllCells;
            this.dgvUsuarios.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dgvUsuarios.Columns.AddRange(new System.Windows.Forms.DataGridViewColumn[] {
            this.colCodigo,
            this.colNombre,
            this.colSegundoNombre,
            this.colApellido,
            this.colSegundoApellido,
            this.colApellidoCasada,
            this.colEmail});
            this.dgvUsuarios.Dock = System.Windows.Forms.DockStyle.Bottom;
            this.dgvUsuarios.Location = new System.Drawing.Point(0, 39);
            this.dgvUsuarios.Name = "dgvUsuarios";
            this.dgvUsuarios.SelectionMode = System.Windows.Forms.DataGridViewSelectionMode.FullRowSelect;
            this.dgvUsuarios.Size = new System.Drawing.Size(800, 411);
            this.dgvUsuarios.TabIndex = 5;
            this.dgvUsuarios.CellContentClick += new System.Windows.Forms.DataGridViewCellEventHandler(this.dgvUsuarios_CellContentClick);
            // 
            // btnEliminar
            // 
            this.btnEliminar.Location = new System.Drawing.Point(348, 10);
            this.btnEliminar.Name = "btnEliminar";
            this.btnEliminar.Size = new System.Drawing.Size(75, 23);
            this.btnEliminar.TabIndex = 6;
            this.btnEliminar.Text = "Eliminar";
            this.btnEliminar.UseVisualStyleBackColor = true;
            this.btnEliminar.Click += new System.EventHandler(this.btnEliminar_Click);
            // 
            // btnGuardarEdicion
            // 
            this.btnGuardarEdicion.Location = new System.Drawing.Point(429, 10);
            this.btnGuardarEdicion.Name = "btnGuardarEdicion";
            this.btnGuardarEdicion.Size = new System.Drawing.Size(75, 23);
            this.btnGuardarEdicion.TabIndex = 7;
            this.btnGuardarEdicion.Text = "Guardar";
            this.btnGuardarEdicion.UseVisualStyleBackColor = true;
            this.btnGuardarEdicion.Click += new System.EventHandler(this.btnGuardarEdicion_Click);
            // 
            // colCodigo
            // 
            this.colCodigo.DataPropertyName = "CodigoUsuario";
            this.colCodigo.HeaderText = "Código";
            this.colCodigo.Name = "colCodigo";
            this.colCodigo.ReadOnly = true;
            this.colCodigo.Width = 65;
            // 
            // colNombre
            // 
            this.colNombre.DataPropertyName = "Nombre";
            this.colNombre.HeaderText = "NombreUsuario";
            this.colNombre.Name = "colNombre";
            this.colNombre.ReadOnly = true;
            this.colNombre.Width = 105;
            // 
            // colSegundoNombre
            // 
            this.colSegundoNombre.DataPropertyName = "Segundo Nombre";
            this.colSegundoNombre.HeaderText = "SegundoNombre";
            this.colSegundoNombre.Name = "colSegundoNombre";
            this.colSegundoNombre.ReadOnly = true;
            this.colSegundoNombre.Width = 112;
            // 
            // colApellido
            // 
            this.colApellido.DataPropertyName = "Apellido";
            this.colApellido.HeaderText = "ApellidoUsuario";
            this.colApellido.Name = "colApellido";
            this.colApellido.ReadOnly = true;
            this.colApellido.Width = 105;
            // 
            // colSegundoApellido
            // 
            this.colSegundoApellido.DataPropertyName = "Segundo Apellido";
            this.colSegundoApellido.HeaderText = "SegundoApellido";
            this.colSegundoApellido.Name = "colSegundoApellido";
            this.colSegundoApellido.ReadOnly = true;
            this.colSegundoApellido.Width = 112;
            // 
            // colApellidoCasada
            // 
            this.colApellidoCasada.DataPropertyName = "Apellido Casada";
            this.colApellidoCasada.HeaderText = "ApellidoCasada";
            this.colApellidoCasada.Name = "colApellidoCasada";
            this.colApellidoCasada.ReadOnly = true;
            this.colApellidoCasada.Width = 105;
            // 
            // colEmail
            // 
            this.colEmail.AutoSizeMode = System.Windows.Forms.DataGridViewAutoSizeColumnMode.Fill;
            this.colEmail.DataPropertyName = "Email";
            this.colEmail.HeaderText = "Email";
            this.colEmail.Name = "colEmail";
            this.colEmail.ReadOnly = true;
            // 
            // frmUsuarios
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(800, 450);
            this.Controls.Add(this.btnGuardarEdicion);
            this.Controls.Add(this.btnEliminar);
            this.Controls.Add(this.dgvUsuarios);
            this.Controls.Add(this.tbCodigo);
            this.Controls.Add(this.btnRefrescar);
            this.Controls.Add(this.btnBuscar);
            this.Controls.Add(this.lblCodigo);
            this.Name = "frmUsuarios";
            this.Text = "frmUsuarios";
            this.Load += new System.EventHandler(this.frmUsuarios_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dgvUsuarios)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblCodigo;
        private System.Windows.Forms.Button btnBuscar;
        private System.Windows.Forms.Button btnRefrescar;
        private System.Windows.Forms.TextBox tbCodigo;
        private System.Windows.Forms.DataGridView dgvUsuarios;
        private System.Windows.Forms.Button btnEliminar;
        private System.Windows.Forms.Button btnGuardarEdicion;
        private System.Windows.Forms.DataGridViewTextBoxColumn colCodigo;
        private System.Windows.Forms.DataGridViewTextBoxColumn colNombre;
        private System.Windows.Forms.DataGridViewTextBoxColumn colSegundoNombre;
        private System.Windows.Forms.DataGridViewTextBoxColumn colApellido;
        private System.Windows.Forms.DataGridViewTextBoxColumn colSegundoApellido;
        private System.Windows.Forms.DataGridViewTextBoxColumn colApellidoCasada;
        private System.Windows.Forms.DataGridViewTextBoxColumn colEmail;
    }
}