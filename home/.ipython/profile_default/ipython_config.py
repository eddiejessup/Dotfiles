import sys

c = get_config()

v = sys.version_info

v_str = f'{v.major}.{v.minor}.{v.micro}'

c.InteractiveShell.confirm_exit = False
c.InteractiveShell.banner1 = f"Python {v_str}. Available: 'np'."

c.TerminalIPythonApp.display_banner = True

c.InteractiveShellApp.extensions = [
]
c.InteractiveShellApp.exec_lines = [
    'import numpy as np',
]

c.AliasManager.user_aliases = [
    ('la', 'ls -al'),
]
