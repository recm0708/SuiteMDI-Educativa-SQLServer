using System.Drawing;
using System.Windows.Forms;

namespace bd_A7_RubenCanizares.Soporte
{
    public static class ThemeHelper
    {
        public static Color Bg = Color.FromArgb(245, 247, 250);
        public static Color Primary = Color.FromArgb(20, 108, 148);  // azul petróleo
        public static Color Accent = Color.FromArgb(243, 156, 18);   // acento

        public static void Apply(Form f)
        {
            f.BackColor = Bg;
            foreach (Control c in f.Controls)
            {
                if (c is Button b)
                {
                    b.FlatStyle = FlatStyle.Flat;
                    b.FlatAppearance.BorderSize = 0;
                    b.BackColor = Primary;
                    b.ForeColor = Color.White;
                }
                // Puedes extender a Labels, TextBox, etc.
            }
        }
    }
}