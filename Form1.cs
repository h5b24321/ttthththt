using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace crosshair
{
    public partial class Form1 : Form
    {
        // Ayarlar
        public static Color CColor = Color.Lime;
        public static int CSize = 12, CThick = 2, CGap = 5, CMode = 0;
        public static bool COutline = true;

        [DllImport("user32.dll")]
        static extern int GetWindowLong(IntPtr hWnd, int nIndex);
        [DllImport("user32.dll")]
        static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

        public Form1()
        {
            // Formu tam ekran, şeffaf ve en üstte yapar
            this.FormBorderStyle = FormBorderStyle.None;
            this.TopMost = true;
            this.BackColor = Color.Black;
            this.TransparencyKey = Color.Black;
            this.WindowState = FormWindowState.Maximized;
            this.ShowInTaskbar = false;

            // Ayarlar formu projedeyse açar
            try { new FormAyarlar().Show(); } catch { }
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = SmoothingMode.AntiAlias;
            int x = Screen.PrimaryScreen.Bounds.Width / 2;
            int y = Screen.PrimaryScreen.Bounds.Height / 2;

            using (Pen p = new Pen(CColor, CThick))
            using (Pen s = new Pen(Color.FromArgb(160, 0, 0, 0), CThick + 2))
            {
                if (CMode == 0 || CMode == 4) // Artı veya T-Style
                {
                    if (CMode != 4) DrawL(e.Graphics, p, s, x, y - CGap, x, y - CGap - CSize);
                    DrawL(e.Graphics, p, s, x, y + CGap, x, y + CGap + CSize);
                    DrawL(e.Graphics, p, s, x - CGap, y, x - CGap - CSize, y);
                    DrawL(e.Graphics, p, s, x + CGap, y, x + CGap + CSize, y);
                }
                else if (CMode == 1) // Nokta
                {
                    e.Graphics.FillEllipse(Brushes.Black, x - CThick - 1, y - CThick - 1, (CThick + 1) * 2, (CThick + 1) * 2);
                    e.Graphics.FillEllipse(new SolidBrush(CColor), x - CThick, y - CThick, CThick * 2, CThick * 2);
                }
            }
        }

        private void DrawL(Graphics g, Pen p, Pen s, int x1, int y1, int x2, int y2)
        {
            if (COutline) g.DrawLine(s, x1, y1, x2, y2);
            g.DrawLine(p, x1, y1, x2, y2);
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);
            // Mouse tıklamalarını arkadaki oyuna geçiren kod
            SetWindowLong(this.Handle, -20, GetWindowLong(this.Handle, -20) | 0x80000 | 0x20);
        }
    }
}
