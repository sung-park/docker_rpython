c = get_config()

c.InteractiveShellApp.exec_lines = [
    "mpl.rc('font', family='nanumgothic')",
    "mpl.rc('axes', unicode_minus=False)",
    "mpl.rc('figure', figsize=(8, 5))",
    "mpl.rc('figure', dpi=200)",
]
