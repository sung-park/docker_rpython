c = get_config()

c.InteractiveShellApp.exec_lines = [
    "%matplotlib inline",
    "%autoreload 2",
    "mpl.rc('font', family='nanumgothic')",
    "mpl.rc('axes', unicode_minus=False)",
    "mpl.rc('figure', figsize=(8, 5))",
    "mpl.rc('figure', dpi=300)",
]
