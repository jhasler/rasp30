import zipfile
import sys

with zipfile.ZipFile('results.zip', "r") as z:
    z.extractall(sys.argv[1])
