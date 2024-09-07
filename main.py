#!/bin/python
#TODO: Migrate from json to yaml for the meta files
#TODO: Improve error handling (especially for removing files, overwriting stuff in the src dir, etc)
#TODO: Add a quiet option (can be done by adding a variable "> /dev/null" for commands)
#TODO: Implement dependency resolution
#TODO: Add more meta files
from utils import *
import subprocess
import os
import urllib.parse
import shutil
import yaml
import configparser
import time
import argparse

class Package:
    def __init__(self, name, version, url, build_command="", install_command="", remove_command=""):
        self.name = name
        self.version = version
        self.url = url
        self.build_command = build_command
        self.install_command = install_command
        self.remove_command = remove_command
        self.tarball = f"{self.name}-{self.version}.tox"

    def __repr__(self):
        return f"{self.name}-{self.version}"

class PackageManager:
    def __init__(self, sources_directory, meta_directory, tracking_file):
        self.sources_directory = sources_directory
        self.meta_directory = meta_directory
        self.tracking_file = tracking_file

        with open(tracking_file, 'r') as f:
            lines = f.readlines()
            lines = [l.strip() for l in lines if l.strip() != '']
        self.installed_packages = lines
        
        subprocess.run("source ./gimme.env", shell=True, check=True)
        subprocess.run("echo $XORG_PREFIX $XORG_CONFIG $MAKEFLAGS", shell=True, check=True)
        os.chdir(self.sources_directory)

    def make_config_dirs(self):
        os.makedirs(os.path.join('..', self.sources_directory), exist_ok=True)
        os.makedirs(os.path.join('..', self.meta_directory), exist_ok=True)

    def fetch_source(self, package):
        msg(f"Fetching source for {package}...")
        if os.path.isfile(package.tarball):
            msg(f"tarball {package.tarball} already exists")
            return
        url_path = urllib.parse.urlparse(package.url).path
        filename = os.path.basename(url_path)

        subprocess.run(["wget", package.url, "-O", package.tarball], check=True)
        msg(f"Source fetched and saved as {package.tarball}")

    def build(self, package):
        msg(f"Building {package}...")
        if package.tarball:
            msg(f"Using tarball: {package.tarball}")

            temp_dir = "temp_extract"
            os.makedirs(temp_dir, exist_ok=True)

            if os.path.isdir(repr(package)):
                subprocess.run(f"rm -rvf ./{package}", shell=True, check=True)
            subprocess.run(f"tar xvf {package.tarball} -C {temp_dir}", shell=True, check=True)
            subprocess.run(f"mv -v temp_extract/* ./{package}", shell=True, check=True)
            subprocess.run(f"rm -rv {temp_dir}", shell=True, check=True)

            os.chdir(repr(package))
            if package.build_command:
                subprocess.run(package.build_command, shell=True, check=True)
            os.chdir("..")
        else:
            erm(f"Tarball not found.")

    def install(self, package):
        msg(f"Installing {package}...")
        os.chdir(repr(package))
        if package.install_command:
            subprocess.run(package.install_command, shell=True, check=True)
        os.chdir("..")

    def clean_up(self, package, and_dir=False):
        if os.path.exists(f"{package}.tox"):
            subprocess.run(["rm", "-vf", f"{package}.tox"])
        if and_dir:
            if os.path.exists(repr(package)):
                subprocess.run(["rm", "-rv", repr(package)])

    def uninstall(self, package):
        msg(f"Uninstalling {package}...")
        os.chdir(repr(package))
        if package.remove_command:
            subprocess.run(package.remove_command, shell=True, check=True)
        os.chdir("..")

    def track_package(self, package, action):
        match action:
            case "remove":
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if repr(package) not in line]
                    f.seek(0)
                    f.writelines(lines)
                    f.truncate()
            case "add":
                with open(os.path.join('..', self.tracking_file), 'a') as f:
                    f.write(repr(package) + '\n')

    def list_installed(self):
        if not self.installed_packages:
            erm("No packages installed.")
        else:
            print("Installed packages:")
            for p in self.installed_packages:
                print(f" - {p}")

    def get_package(self, package):
        self.fetch_source(package)
        self.build(package)
        self.install(package)
        self.clean_up(package)
        self.track_package(package, "add")

    def remove_package(self, package):
        self.uninstall(package)
        self.clean_up(package, and_dir=True)
        self.track_package(package, "remove")


class ControlPanel:
    def __init__(self, package_manager):
        self.package_manager = package_manager
        
    def load_package_from_yaml(self, pkg):
        with open(os.path.join('..', self.package_manager.meta_directory, f"{pkg}.yaml"), 'r') as y:
            data = yaml.safe_load(y)

        package = Package(
                name=data.get("name"),
                version=data.get("version"),
                url=data.get("url"),
                build_command=data.get("build_command", ""),
                install_command=data.get("install_command", ""),
                remove_command=data.get("remove_command", "")
                )
        return package


    def handle_args(self):
        parser = argparse.ArgumentParser(description="Tox's source-based package manager")

        parser.add_argument("-g", "--get", type=str, help="get <package>")
        parser.add_argument("-r", "--remove", type=str, help="remove <package>")
        parser.add_argument("-l", "--list", action="store_true", help="list installed packages")
        parser.add_argument("-v", "--verbose", action="store_true", help="increase output verbosity")

        return parser.parse_args()

    def run(self):
        args = self.handle_args()
        if args.get:
            package = self.load_package_from_yaml(args.get)
            print(f" [i] Getting {package}...")
            self.package_manager.get_package(package)

        if args.remove:
            package = self.load_package_from_yaml(args.remove)
            print(f" [i] Removing {package}...")
            self.package_manager.remove_package(package)

        if args.list:
            self.package_manager.list_installed()

        if args.verbose:
            print("Verbose enabled")

def read_config(config_file):
    cfg = configparser.ConfigParser()
    cfg.read(config_file)
    return cfg

if __name__ == "__main__":

    cfg = read_config("gimme.conf")

    pm = PackageManager(
            sources_directory = cfg["Directories"]["sources"],
            meta_directory = cfg["Directories"]["meta"],
            tracking_file = cfg["Files"]["tracking"]
            )

    pm.make_config_dirs()

    control = ControlPanel(pm)
    control.run()
