from multiprocessing.spawn import import_main_path
from pathlib import Path
from re import PatternError
from time import sleep

import yaml

data = {}
Path("tetko.txt").write_text("asd")
sleep(1)

files = Path("./files")
for file in files.iterdir():
    if file.is_file():
        print(file.name)
        with open(file, "r") as f:
            lines = [line.strip().split(" ")[0] for line in f.readlines()]
            data[file.name] = lines

Path("dta.yml").write_text(yaml.dump(data))
