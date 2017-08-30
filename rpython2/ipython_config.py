c = get_config()

c.InteractiveShellApp.exec_lines = [
    "from __future__ import division",
    "from __future__ import print_function",
    "mpl.rc('font', family='nanumgothic')",
    "mpl.rc('axes', unicode_minus=False)",
    "mpl.rc('figure', figsize=(8, 5))",
    "mpl.rc('figure', dpi=600)",
]
