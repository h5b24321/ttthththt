using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Runtime.InteropServices;
using System.Windows.Forms;
using System.IO; // Dosya işlemleri için gerekli
using IWshRuntimeLibrary; // Referans ekledikten sonra kullanabilirsiniz

namespace crosshair
{
    public partial class Form1 : Form
    {
        public static Color CColor = Color.Lime;
        public static int CSize = 12, CThick = 2, CGap = 5, CMode = 0; // 0:Artı, 1:Nokta, 2:Kare, 3:X-Style, 4:T-Style
        public static bool COutline = true;

        [DllImport("user32.dll")]
        static extern int GetWindowLong(IntPtr hWnd, int nIndex);
        [DllImport("user32.dll")]
        static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

        public Form1()
        {
            this.FormBorderStyle = FormBorderStyle.None;
            this.TopMost = true;
            this.BackColor = Color.Black;
            this.TransparencyKey = Color.Black;
            this.WindowState = FormWindowState.Maximized;
            this.ShowInTaskbar = false;
            new FormAyarlar().Show();
        }

        protected override void OnPaint(PaintEventArgs e)
        {
            e.Graphics.SmoothingMode = SmoothingMode.AntiAlias; // Pürüzsüz çizim
            int x = Screen.PrimaryScreen.Bounds.Width / 2;
            int y = Screen.PrimaryScreen.Bounds.Height / 2;

            using (Pen p = new Pen(CColor, CThick))
            using (Pen s = new Pen(Color.FromArgb(160, 0, 0, 0), CThick + 2))
            {
                if (CMode == 0 || CMode == 4) // Artı & T-Style
                {
                    if (CMode != 4) DrawL(e.Graphics, p, s, x, y - CGap, x, y - CGap - CSize); // Üst
                    DrawL(e.Graphics, p, s, x, y + CGap, x, y + CGap - (-CSize)); // Alt
                    DrawL(e.Graphics, p, s, x - CGap, y, x - CGap - CSize, y); // Sol
                    DrawL(e.Graphics, p, s, x + CGap, y, x + CGap + CSize, y); // Sağ
                }
                else if (CMode == 1) // Keskin Nokta
                {
                    e.Graphics.FillEllipse(Brushes.Black, x - CThick - 1, y - CThick - 1, (CThick + 1) * 2, (CThick + 1) * 2);
                    e.Graphics.FillEllipse(new SolidBrush(CColor), x - CThick, y - CThick, CThick * 2, CThick * 2);
                }
                else if (CMode == 2) // Kare (Box)
                {
                    e.Graphics.DrawRectangle(s, x - CGap, y - CGap, CGap * 2, CGap * 2);
                    e.Graphics.DrawRectangle(p, x - CGap, y - CGap, CGap * 2, CGap * 2);
                }
            }
        }

        private void DrawL(Graphics g, Pen p, Pen s, int x1, int y1, int x2, int y2)
        {
            if (COutline) g.DrawLine(s, x1, y1, x2, y2);
            g.DrawLine(p, x1, y1, x2, y2);
        }

        protected override void OnLoad(EventArgs e) { base.OnLoad(e); SetWindowLong(this.Handle, -20, GetWindowLong(this.Handle, -20) | 0x80000 | 0x20); }
    }
}

private void CreateShortcut()
{
    string shortcutPath = Path.Combine(Environment.GetFolderPath(Environment.SpecialFolder.Desktop), "Crosshair.lnk");

    if (!System.IO.File.Exists(shortcutPath))
    {
        WshShell shell = new WshShell();
        IWshShortcut shortcut = (IWshShortcut)shell.CreateShortcut(shortcutPath);

        shortcut.Description = "Crosshair Uygulaması";
        shortcut.TargetPath = Application.ExecutablePath; // Programın şu anki konumu
        shortcut.WorkingDirectory = Application.StartupPath;
        shortcut.Save();
    }
}





