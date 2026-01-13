using System;
using System.Drawing;
using System.Drawing.Drawing2D;
using System.Runtime.InteropServices;
using System.Windows.Forms;

namespace crosshair
{
    public partial class FormAyarlar : Form
    {
        [DllImport("user32.dll")] public static extern bool ReleaseCapture();
        [DllImport("user32.dll")] public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);

        public FormAyarlar()
        {
            this.Size = new Size(420, 600);
            this.FormBorderStyle = FormBorderStyle.None;
            this.BackColor = Color.FromArgb(15, 15, 18);
            this.StartPosition = FormStartPosition.CenterScreen;
            this.TopMost = true;

            // --- MODERN HEADER (SÜRÜKLEME) ---
            Panel head = new Panel { Dock = DockStyle.Top, Height = 50, BackColor = Color.FromArgb(25, 25, 30), Parent = this };
            head.MouseDown += (s, e) => { ReleaseCapture(); SendMessage(this.Handle, 0xA1, 0x2, 0); };

            Label l = new Label { Text = "CRYSTAL CORE v5", ForeColor = Color.FromArgb(0, 255, 200), Font = new Font("Segoe UI", 12, FontStyle.Bold), Left = 15, Top = 12, AutoSize = true, Parent = head };
            l.MouseDown += (s, e) => { ReleaseCapture(); SendMessage(this.Handle, 0xA1, 0x2, 0); };

            Button close = new Button { Text = "✕", Dock = DockStyle.Right, Width = 50, FlatStyle = FlatStyle.Flat, ForeColor = Color.White, Parent = head };
            close.FlatAppearance.BorderSize = 0; close.Click += (s, e) => Application.Exit();

            // --- MOD SEÇİCİLER (CUSTOM TABS) ---
            int y = 70;
            string[] modes = { "PLUS", "DOT", "BOX", "T-STYLE" };
            for (int i = 0; i < modes.Length; i++)
            {
                Button b = new Button
                {
                    Text = modes[i],
                    Left = 20 + (i * 95),
                    Top = y,
                    Width = 90,
                    Height = 40,
                    FlatStyle = FlatStyle.Flat,
                    ForeColor = Color.White,
                    BackColor = Color.FromArgb(35, 35, 40),
                    Font = new Font("Segoe UI", 8, FontStyle.Bold),
                    Parent = this
                };
                b.FlatAppearance.BorderColor = Color.FromArgb(0, 255, 200);
                int idx = i; b.Click += (s, e) => { Form1.CMode = idx; RefreshX(); };
            }

            // --- AYARLAR (CUSTOM SLIDERS) ---
            y = 140;
            AddProSlider("UZUNLUK (LENGTH)", 2, 60, Form1.CSize, ref y, (v) => Form1.CSize = v);
            AddProSlider("KALINLIK (THICK)", 1, 15, Form1.CThick, ref y, (v) => Form1.CThick = v);
            AddProSlider("BOŞLUK (GAP)", 0, 40, Form1.CGap, ref y, (v) => Form1.CGap = v);

            // --- RENK PALETİ ---
            Label lc = new Label { Text = "RENK PROFİLLERİ", Top = y + 10, Left = 25, ForeColor = Color.FromArgb(0, 255, 200), Font = new Font("Segoe UI", 9, FontStyle.Bold), Parent = this };
            FlowLayoutPanel flow = new FlowLayoutPanel { Left = 20, Top = y + 35, Size = new Size(380, 100), Parent = this };
            Color[] colors = { Color.Lime, Color.Red, Color.Cyan, Color.Yellow, Color.White, Color.Magenta, Color.Orange, Color.DeepSkyBlue };
            foreach (Color c in colors)
            {
                Button cb = new Button { BackColor = c, Size = new Size(42, 42), FlatStyle = FlatStyle.Flat, Parent = flow };
                cb.FlatAppearance.BorderSize = 0;
                cb.Click += (s, e) => { Form1.CColor = ((Button)s).BackColor; RefreshX(); };
            }
        }

        private void AddProSlider(string name, int min, int max, int val, ref int y, Action<int> act)
        {
            Label l = new Label { Text = name, Top = y, Left = 25, ForeColor = Color.Gray, Font = new Font("Segoe UI", 8, FontStyle.Bold), Parent = this };
            TrackBar tb = new TrackBar { Left = 20, Top = y + 20, Width = 370, Minimum = min, Maximum = max, Value = val, Parent = this };
            tb.Scroll += (s, e) => { act(tb.Value); RefreshX(); };
            y += 75;
        }

        private void RefreshX() { foreach (Form f in Application.OpenForms) if (f is Form1) f.Invalidate(); }

        // Formu Yuvarlak Köşeli Yapma (GDI32)
        [DllImport("Gdi32.dll", EntryPoint = "CreateRoundRectRgn")]
        private static extern IntPtr CreateRoundRectRgn(int nLeftRect, int nTopRect, int nRightRect, int nBottomRect, int nWidthEllipse, int nHeightEllipse);
        protected override void OnLoad(EventArgs e) { base.OnLoad(e); this.Region = Region.FromHrgn(CreateRoundRectRgn(0, 0, Width, Height, 30, 30)); }
    }
}
