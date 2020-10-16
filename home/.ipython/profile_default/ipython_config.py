import sys

c = get_config()

v = sys.version_info

v_str = f'{v.major}.{v.minor}.{v.micro}'

c.InteractiveShell.confirm_exit = False
c.InteractiveShell.banner1 = f"Python {v_str}. Available: 'np', 'pd', 'df', 's', 'l', 's', 'd'."

c.TerminalIPythonApp.display_banner = True

c.InteractiveShellApp.extensions = [
]
c.InteractiveShellApp.exec_lines = [
    'import numpy as np',
    'import pandas as pd',
    'df = pd.DataFrame()',
    's = pd.Series(dtype=np.int)',
    'l = []',
    's = set()',
    'd = dict()',
]

c.AliasManager.user_aliases = [
    ('la', 'ls -al'),
]
