import subprocess
import sys
import os

output = str(subprocess.check_output( ["zpm", "install-package"], universal_newlines=True ))

if ("(c) Zefiros Software" not in output or
    "Zefiros Package Manager" not in output):

    print( "ZPM failed to load correctly!\n Output:\n", output )
    exit(-1)
else:
    print( "ZPM successfully installed" )