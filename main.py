#!/bin/python
# TODO: Improve error handling (especially for removing files, overwriting stuff in the src dir, etc)
# TODO: Add a quiet option (can be done by adding a variable "> /dev/null" for commands)
# TODO: Add more meta files
from utils import erm, msg, prompt
import subprocess
import os
import yaml
import configparser
import time
import argparse
import string
from pprint import pprint as pp


class Package:
    def __init__(self, name, version, url, get="", remove=""):
        self.name = name
        self.version = version
        self.url = url
        self.get = get
        self.remove = remove
        self.tarball = f"{self.name}-{self.version}.tox"

    def __repr__(self):
        return f"{self.name}-{self.version}"


def interpolate(metafile):
    with open(metafile, 'r') as f:
        data = yaml.safe_load(f)

    version = data['version']
    minor_version = '.'.join(version.split('.')[:2])

    url_template = string.Template(data['url'])
    data['url'] = url_template.safe_substitute(
            version=version,
            minor_version=minor_version
            )

    get_template = string.Template(data['get'])
    data['get'] = get_template.safe_substitute(version=data['version'])

    remove_template = string.Template(data['remove'])
    data['remove'] = remove_template.safe_substitute(version=data['version'])
    return data


class PackageManager:
    def __init__(self, sources_directory, meta_directory, tracking_file):
        self.sources_directory = sources_directory
        self.meta_directory = meta_directory
        self.tracking_file = tracking_file

        with open(tracking_file, 'r') as f:
            lines = f.readlines()
            lines = [line.strip() for line in lines if line.strip() != '']
        self.installed_packages = lines
        os.chdir(self.sources_directory)

    def make_config_dirs(self):
        os.makedirs(os.path.join('..', self.sources_directory), exist_ok=True)
        os.makedirs(os.path.join('..', self.meta_directory), exist_ok=True)

    def install_check(self, package):
        if str(package) in self.installed_packages:
            msg("Package installed")
            return prompt(f"Package '{package}' already installed! Reinstall?", default='n')
        return False

    def fetch_source(self, package):
        msg(f"Fetching source for {package}...")
        if os.path.isfile(package.tarball):
            msg(f"Tarball {package.tarball} already exists")
            return
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
            if package.get:
                subprocess.run(package.get, shell=True, check=True)
            os.chdir("..")
        else:
            erm(f"Tarball '{package.tarball}' not found.")

    def clean_up(self, package, and_dir=False):
        if os.path.exists(f"{package}.tox"):
            subprocess.run(["rm", "-vf", f"{package}.tox"])
        if and_dir:
            if os.path.exists(repr(package)):
                subprocess.run(["rm", "-rv", repr(package)])

    def uninstall(self, package):
        msg(f"Uninstalling {package}...")
        os.chdir(repr(package))
        if package.remove:
            subprocess.run(package.remove, shell=True, check=True)
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
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.read().splitlines()
                    lines = list(dict.fromkeys(lines))
                    newline = repr(package)
                    if newline not in lines:
                        lines.append(newline)
                        f.seek(0)
                        f.writelines('\n'.join(lines)+'\n')
                        f.truncate()
                    else:
                        msg(f"Package '{package}' already tracked.")

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
        data = interpolate(os.path.join('..', self.package_manager.meta_directory, f"{pkg}.yaml"))
        package = Package(
                name=data.get("name"),
                version=data.get("version"),
                url=data.get("url"),
                get=data.get("get", ""),
                remove=data.get("remove", "")
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
            if self.package_manager.install_check(package):
                msg(f"Getting {package}...")
                self.package_manager.get_package(package)

        if args.remove:
            package = self.load_package_from_yaml(args.remove)
            msg(f"Removing {package}...")
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
        sources_directory=cfg["Directories"]["sources"],
        meta_directory=cfg["Directories"]["meta"],
        tracking_file=cfg["Files"]["tracking"]
        )

    pm.make_config_dirs()

    control = ControlPanel(pm)
    control.run()
