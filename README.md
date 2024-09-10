# Gimme
Simple source-based package manager in python

## Info
You probably don't want to use this just yet. It's still in very early development. It can fuck up your system, so don't run this unless you know what you're doing.

The idea behind Gimme was to write a source-based package manager that doesn't abstract away the configure options. With Gimme, you edit yaml files which contain basic build instructions in the meta folder. You then point main.py at one of those yamls files to get or remove a package.

To create new yaml files, just copy template.yaml to <package>.yaml and customize it. You can then point main.py at that yaml.

I've created a wrapper (the executable gimme) to source some environment variables and run main.py.

## Installation
This should be all it takes. (Not tested yet.)
```bash
git clone https://github.com/Toxikuu/gimme/ && cd gimme
```

## Usage
```
usage: main.py [-h] [-g GET] [-r REMOVE] [-l] [-v]

Tox's source-based package manager

options:
  -h, --help            show this help message and exit
  -g GET, --get GET     get <package>
  -r REMOVE, --remove REMOVE
                        remove <package>
  -l, --list            list installed packages
  -v, --verbose         increase output verbosity
```
