import subprocess
import tkinter as tk
from tkinter import scrolledtext, messagebox, filedialog
from threading import Thread
import re
import os

class MakeCommandsGUI(tk.Tk):
    def __init__(self):
        super().__init__()

        self.title("Make Commands GUI")
        self.geometry("900x600")

        self.create_widgets()
        self.create_tags()

    def create_widgets(self):
        # Main output text area
        self.output_text = scrolledtext.ScrolledText(self, wrap=tk.WORD, width=100, height=20, bg="black", fg="white", font=("Courier", 11))
        self.output_text.pack(padx=20, pady=(20, 10), fill=tk.BOTH, expand=True)

        # Buttons frame for make commands
        buttons_frame = tk.Frame(self)
        buttons_frame.pack(pady=(10, 20))

        self.install_button = tk.Button(buttons_frame, text="Install Scanners", command=self.run_scanner_install, width=20)
        self.install_button.pack(side=tk.LEFT, padx=10)

        self.start_button = tk.Button(buttons_frame, text="Start Scan", command=self.run_scan_start, width=20)
        self.start_button.pack(side=tk.LEFT, padx=10)

        self.upgrade_button = tk.Button(buttons_frame, text="Upgrade Tools", command=self.run_scanner_upgrade, width=20)
        self.upgrade_button.pack(side=tk.LEFT, padx=10)

        # Scan upload section
        upload_frame = tk.Frame(self)
        upload_frame.pack(fill=tk.X, padx=20)

        self.username_label = tk.Label(upload_frame, text="Username:", width=10, anchor="e")
        self.username_label.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.username_entry = tk.Entry(upload_frame, width=20)
        self.username_entry.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.password_label = tk.Label(upload_frame, text="Password:", width=10, anchor="e")
        self.password_label.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.password_entry = tk.Entry(upload_frame, show="*", width=20)
        self.password_entry.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.file_label = tk.Label(upload_frame, text="Upload File:", width=10, anchor="e")
        self.file_label.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.select_file_button = tk.Button(upload_frame, text="Select File", command=self.select_file, width=20)
        self.select_file_button.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.destination_label = tk.Label(upload_frame, text="Destination:", width=10, anchor="e")
        self.destination_label.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.destination_entry = tk.Entry(upload_frame, width=20)
        self.destination_entry.pack(side=tk.LEFT, padx=(0, 10), pady=10)

        self.upload_button = tk.Button(upload_frame, text="Upload Scan", command=self.run_scan_upload, width=20)
        self.upload_button.pack(side=tk.LEFT, padx=(0, 10), pady=10)

    def create_tags(self):
        colors = {
            '30': 'black',
            '31': 'red',
            '32': 'green',
            '33': 'yellow',
            '34': 'blue',
            '35': 'magenta',
            '36': 'cyan',
            '37': 'white'
        }

        for code, color in colors.items():
            self.output_text.tag_configure(f'fg_{color}', foreground=color)

    def run_command(self, command):
        # Clear current output
        self.output_text.delete(1.0, tk.END)

        process = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, text=True, bufsize=1)

        ansi_escape = re.compile(r'\x1B\[([0-?]*[ -/]*[@-~])')

        for line in iter(process.stdout.readline, ''):
            self.parse_ansi_escape(line, ansi_escape)
            self.output_text.see(tk.END)
            self.update_idletasks()

        process.stdout.close()
        process.wait()

        if process.returncode != 0:
            error_message = process.stderr.read()
            self.output_text.insert(tk.END, f"\nCommand '{' '.join(command)}' failed:\n{error_message}\n", 'fg_red')
            messagebox.showerror("Error", f"Command '{' '.join(command)}' failed with error:\n{error_message}")

        process.stderr.close()

    def parse_ansi_escape(self, text, ansi_escape):
        matches = ansi_escape.finditer(text)
        tags = []
        start = 0

        for match in matches:
            end = match.start()
            self.output_text.insert(tk.END, text[start:end], tags)
            code = match.group(1)

            if code == '0m':  # Reset
                tags = []
            elif code.endswith('m'):  # Color
                color_code = code[:-1].split(';')
                if len(color_code) == 1:
                    color_code = color_code[0]
                    if color_code in self.color_map:
                        tags = [f'fg_{self.color_map[color_code]}']
                elif len(color_code) == 2 and color_code[1] in self.color_map:
                    tags = [f'fg_{self.color_map[color_code[1]]}']

            start = match.end()

        self.output_text.insert(tk.END, text[start:], tags)

    def run_scanner_install(self):
        Thread(target=self.run_command, args=(['make', 'scanner-install'],)).start()

    def run_scan_start(self):
        Thread(target=self.run_command, args=(['make', 'scan-start'],)).start()

    def run_scanner_upgrade(self):
        Thread(target=self.run_command, args=(['make', 'scanner-upgrade'],)).start()

    def run_scan_upload(self):
        username = self.username_entry.get()
        password = self.password_entry.get()
        file_path = getattr(self, "file_path", "")
        destination = self.destination_entry.get()

        if not all([username, password, file_path, destination]):
            messagebox.showerror("Input Error", "Please provide username, password, file, and destination.")
            return

        args = f'-u {username} -p {password} -s {file_path} -d {destination}'
        Thread(target=self.run_command, args=(['make', 'scan-upload', f'ARGS="{args}"'],)).start()

    def select_file(self):
        file_path = filedialog.askopenfilename()
        if file_path:
            self.file_path = file_path
            self.file_label.config(text=f"Upload File: {os.path.basename(file_path)}")

    @property
    def color_map(self):
        return {
            '30': 'black',
            '31': 'red',
            '32': 'green',
            '33': 'yellow',
            '34': 'blue',
            '35': 'magenta',
            '36': 'cyan',
            '37': 'white'
        }


if __name__ == "__main__":
    app = MakeCommandsGUI()
    app.mainloop()
