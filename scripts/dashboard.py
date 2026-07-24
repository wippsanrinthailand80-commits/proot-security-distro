#!/usr/bin/env python3
"""
Dashboard UI for proot-security-distro
A beautiful TUI menu to launch security tools
"""

from textual.app import ComposeResult, RenderableType
from textual.containers import Container, Horizontal, Vertical, ScrollableContainer
from textual.widgets import Header, Footer, Button, Label, Static
from textual.app import App
from textual.binding import Binding
from rich.panel import Panel
from rich.text import Text
from rich.table import Table
import subprocess
import os

class ToolCard(Static):
    """A card representing a security tool"""
    
    DEFAULT_CSS = """
    ToolCard {
        width: 50%;
        height: auto;
        border: solid $accent;
        padding: 1 2;
        margin: 1 1;
    }
    """
    
    def __init__(self, name: str, description: str, command: str):
        super().__init__()
        self.name = name
        self.description = description
        self.command = command
    
    def render(self) -> RenderableType:
        return Panel(
            f"[bold cyan]{self.name}[/bold cyan]\n[dim]{self.description}[/dim]",
            expand=False,
            style="blue"
        )

class SecurityToolsDashboard(App):
    """Main dashboard application"""
    
    CSS = """
    Screen {
        background: $surface;
    }
    
    #tools-container {
        height: 1fr;
        overflow: auto;
    }
    
    Button {
        margin: 0 1;
    }
    """
    
    BINDINGS = [
        Binding("q", "quit", "Quit", show=True),
        Binding("1", "launch_nmap", "Nmap"),
        Binding("2", "launch_metasploit", "Metasploit"),
        Binding("3", "launch_burp", "Burp Suite"),
    ]
    
    TITLE = "🔐 proot-security-distro Dashboard"
    
    tools = [
        ("nmap", "Advanced port scanner and network mapper", "nmap -h"),
        ("hydra", "Brute force password cracking tool", "hydra -h"),
        ("sqlmap", "SQL injection detection and exploitation", "sqlmap -h"),
        ("nikto", "Web server vulnerability scanner", "nikto -h"),
        ("tcpdump", "Network packet sniffer and analyzer", "tcpdump -h"),
        ("john", "Password hash cracking tool", "john --help"),
        ("hashcat", "Advanced password recovery utility", "hashcat -h"),
        ("aircrack-ng", "WiFi security assessment suite", "aircrack-ng"),
        ("masscan", "Fast mass IP port scanner", "masscan -h"),
        ("tshark", "Command-line packet analysis (Wireshark)", "tshark -h"),
        ("gobuster", "Directory and DNS brute force tool", "gobuster -h"),
        ("whois", "Domain and IP information lookup", "whois -h"),
    ]
    
    def compose(self) -> ComposeResult:
        yield Header(show_clock=True)
        
        with ScrollableContainer(id="tools-container"):
            yield Label("[bold cyan]━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[/bold cyan]")
            yield Label("[bold yellow]Available Security Tools[/bold yellow]")
            yield Label("[dim]Press tool number or click to launch | Press 'q' to quit[/dim]")
            yield Label("[bold cyan]━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━[/bold cyan]")
            
            for idx, (name, desc, cmd) in enumerate(self.tools, 1):
                with Horizontal():
                    yield Button(
                        f"[{idx}] {name}",
                        id=f"btn_{name}",
                        variant="primary" if idx % 2 == 0 else "default"
                    )
                    yield Label(f"[dim]{desc}[/dim]")
        
        with Horizontal():
            yield Button("🚀 Launch Interactive Shell", id="shell_btn", variant="success")
            yield Button("📁 Open Workspace", id="workspace_btn", variant="info")
        
        yield Footer()
    
    def on_button_pressed(self, event: Button.Pressed) -> None:
        """Handle button presses"""
        button_id = event.button.id
        
        if button_id == "shell_btn":
            self.launch_shell()
        elif button_id == "workspace_btn":
            self.notify("Workspace: /root/workspace", severity="information", timeout=3)
        else:
            # Extract tool name from button ID
            tool_name = button_id.replace("btn_", "")
            self.launch_tool(tool_name)
    
    def launch_tool(self, tool_name: str) -> None:
        """Launch a specific tool"""
        self.notify(f"Launching {tool_name}... (type '{tool_name} -h' for help)", severity="information", timeout=2)
        self.exit()
        os.system(f"{tool_name} -h 2>&1 | head -20")
    
    def launch_shell(self) -> None:
        """Launch interactive bash shell"""
        self.exit()
        os.system("bash")
    
    def action_launch_nmap(self) -> None:
        self.launch_tool("nmap")
    
    def action_launch_metasploit(self) -> None:
        self.notify("Metasploit: msfconsole", severity="warning", timeout=2)
        self.exit()
        os.system("msfconsole")
    
    def action_launch_burp(self) -> None:
        self.notify("Burp Suite: Manual installation required", severity="warning", timeout=2)
    
    def action_quit(self) -> None:
        """Quit the application"""
        self.exit()

if __name__ == "__main__":
    app = SecurityToolsDashboard()
    app.run()
