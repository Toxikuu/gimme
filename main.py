#!venv/bin/python
from utils import *
import subprocess
import os
import urllib.parse
import shutil
import json
import configparser
import json
import time
import argparse

class Package:
    def __init__(self, name, version, url, build_command="", install_command=""):
        self.name = name
        self.version = version
        self.url = url
        self.build_command = build_command
        self.install_command = install_command
        self.tarball = None

    def __repr__(self):
        return f"{self.name}-{self.version}"

class PackageManager:
    def __init__(self):
        self.sources_directory = None
        self.meta_directory = None
        self.tracking_file = None
        
        os.chdir(self.sources_directory)

    def read_config(self, config_file):
        cfg = configparser.ConfigParser()
        cfg.read('gimme.conf')
        self.sources_directory = cfg['Directories']['sources']
        self.meta_directory = cfg['Directories']['meta']
        self.tracking_file = cfg['Files']['tracking']

    def make_config_dirs(self):
        os.makedirs(self.sources_directory, exist_ok=True)
        os.makedirs(self.meta_directory, exist_ok=True)

    def fetch_source(self, package):
        msg(f"Fetching source for {package}...")
        url_path = urllib.parse.urlparse(package.url).path
        filename = os.path.basename(url_path)

        package.tarball = f"{package}.tox"

        subprocess.run(["wget", package.url, "-O", package.tarball], check=True)
        msg(f"Source fetched and saved as {package.tarball}")

    def build(self, package):
        msg(f"Building {package}...")
        if package.tarball:
            msg(f"Using tarball: {package.tarball}")

            temp_dir = "temp_extract"
            os.makedirs(temp_dir, exist_ok=True)

            subprocess.run(["tar", "xvf", package.tarball, "-C", temp_dir], check=True)
            
            extracted_dir = None
            for item in os.listdir(temp_dir):
                item_path = os.path.join(temp_dir, item)
                if os.path.isdir(item_path):
                    extracted_dir = item_path
                    break

            if extracted_dir:
                new_name = repr(package)
                new_path = os.path.join("temp_extract", new_name)

                if os.path.exists(new_path):
                    shutil.rmtree(new_path)

                os.rename(extracted_dir, new_path)
                msg(f"Renamed directory to {new_name}")

            if os.path.exists(new_path):
                subprocess.run(["mv", "-vf", new_path, "."], check=True)
                msg(f"Moved {new_name} to sources directory.")

            os.rmdir(temp_dir)

            os.chdir(new_name)
            if package.build_command:
                subprocess.run(package.build_command.split(), check=True)
            os.chdir("..")
        else:
            erm(f"Tarball not found.")

    def install(self, package):
        msg(f"Installing {package}...")
        os.chdir(repr(package))
        if package.install_command:
            subprocess.run(package.install_command.split(), check=True)
        os.chdir("..")

    def clean_up(self, package, and_dir=False)
        if os.path.exists(f"{package}.tox"):
            subprocess.run(["rm", "-vf", f"{package}.tox"])
        if and_dir:
            if os.path.exists(repr(package)):
                subprocess.run(["rm", "-rv", repr(package)])

    def uninstall(self, package):
        msg(f"Uninstalling {package}...")

    def track_package(self, package, action):
        match action:
            case "remove":
                with open(self.tracking_file, 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if repr(package) not in line]
                    f.seek(0)
                    f.writelines(lines)
                    f.truncate()
            case "add":
                with open(self.tracking_file, 'a') as f:
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
        self.track_package("add", package)

    def remove_package(self, package):
        self.uninstall(package)
        self.clean_up(package, and_dir=True)
        self.track_package("remove", package)

class ControlPanel:
    def __init__(self, package_manager):
        self.package_manager = package_manager
        
    def load_package_from_json(self, pkg):
        with open(os.path.join(self.package_manager.meta_directory, f"{pkg}.json"), 'r') as j:
            data = json.load(j)

        package = Package(
                name=data.get("name"),
                version=data.get("version"),
                url=data.get("url"),
                build_command=data.get("build_command", ""),
                install_command=data.get("install_command", "")
                )
        return package

    def handle_args(self):
        parser = argparse.ArgumentParser(description="Tox's source-based package manager")

        parser.add_argument("-g", "--get", type=str, help="get <package>")
        parser.add_argumment("-l", "--list", action="store_true", help="list installed packages")
        parser.add_argument("-v", "--verbose", action="store_true", help="increase output verbosity")

        return parser.parse_args()

    def run(self):
        args = self.handle_args()
        if args.get:
            package = self.load_package_from_json(args.get)
            print(f" [i] Getting {package}...")
            self.package_manager.get_package(package)

        if args.list:
            self.package_manager.list_installed()

        if args.verbose:
            print("Verbose enabled")


if __name__ == "__main__":
    pm = PackageManager()
    pm.read_config("gimme.conf")
    pm.make_config_dirs()

    control = ControlPanel(pm)
    control.run()
