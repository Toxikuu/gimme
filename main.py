#!/bin/python
# TODO: Improve error handling (especially for removing files, overwriting stuff in the src dir, etc)
# TODO: Add a quiet option (can be done by adding a variable "> /dev/null" for commands)
# TODO: Add more meta files
# TODO: Untrack older versions of updated packages (might be done with the purge action)
# TODO: Improve package selection
from utils import display_list, erm, msg, cmd, prompt, str_to_bool, title, debug
import os
import yaml
import configparser
import time
import argparse
import string
from pprint import pprint as pp


class Package:
    def __init__(self, name, version, url="", get="", remove=""):
        self.name = name
        self.version = version
        self.url = url
        self.get = get
        self.remove = remove
        self.tarball = f"{self.name}-{self.version}.tar"

    def __repr__(self):
        return f"{self.name}-{self.version}"


def interpolate(metafile):
    with open(metafile, 'r') as f:
        data = yaml.safe_load(f)

    version = data['version']
    minor_version = '.'.join(version.split('.')[:2])

    try:
        url_template = string.Template(data['url'])
        data['url'] = url_template.safe_substitute(
                version=version,
                minor_version=minor_version
                )
    except KeyError:
        pass

    try:
        get_template = string.Template(data['get'])
        data['get'] = get_template.safe_substitute(version=data['version'])
    except KeyError:
        pass

    try:
        remove_template = string.Template(data['remove'])
        data['remove'] = remove_template.safe_substitute(version=data['version'])
    except KeyError:
        pass
    return data


class PackageManager:
    def __init__(self, cfg):
        self.sources_directory = cfg["Directories"]["sources"]
        self.meta_directory = cfg["Directories"]["meta"]
        self.tracking_file = cfg["Files"]["tracking"]

        self.remove_build_dirs = str_to_bool(cfg["Removal"]["build_dirs"])
        self.remove_tarballs = str_to_bool(cfg["Removal"]["tarballs"])

        with open(self.tracking_file, 'r') as f:
            lines = f.readlines()
            lines = [line.strip() for line in lines if line.strip() != '']
        self.installed_packages = lines
        os.chdir(self.sources_directory)

    def make_config_dirs(self):
        os.makedirs(os.path.join('..', self.sources_directory), exist_ok=True)
        os.makedirs(os.path.join('..', self.meta_directory), exist_ok=True)

    def install_check(self, package):
        msg(f"Checking if package '{package}' is installed...")
        if str(package) in self.installed_packages:
            return prompt(f"Package '{package}' already installed! Reinstall?", default='n')
        return True

    def fetch_source(self, package):
        if package.url:
            msg(f"Fetching source for {package}...")
            if os.path.isfile(package.tarball):
                msg(f"Tarball {package.tarball} already exists")
                return
            if not cmd(f"wget '{package.url}' -O {package.tarball}"):
                erm(f"Failed to wget tarball '{package.tarball}' from url '{package.url}'")
                exit()
            msg(f"Source fetched and saved as {package.tarball}")
        else:
            msg(f"No source url for package '{package}'")

    def extract_tarball(self, package):
        if os.path.isfile(package.tarball):
            msg(f"Extracting tarball '{package.tarball}'")

            temp_dir = "temp_extract"
            if os.path.isdir(temp_dir):
                cmd(f"sudo rm -rvf {temp_dir}")
            cmd("mkdir -pv temp_extract")

            if os.path.isdir(repr(package)):
                cmd(f"sudo rm -rvf {package}")

            if not cmd(f"tar xvf {package.tarball} -C {temp_dir}"):
                erm(f"Failed to extract tarball '{package.tarball}'")
                msg(f"Removing possibly corrupted tarball '{package.tarball}'")
                cmd(f"rm -v {package.tarball}")
                msg("Try again")
                exit()

            cmd(f"mv -v {temp_dir}/* {package}")
            cmd(f"rm -rv {temp_dir}")
        else:
            msg(f"Tarball '{package.tarball}' does not exist")

    def build(self, package):
        msg(f"Building {package}...")
        # mkdir -p is necessary for certain packages (tzdata for instance)
        if cmd(f"mkdir -pv {package} && cd {package} && {package.get}"):
            msg(f"Successfully installed {package}")
        else:
            erm(f"Failed to install {package}")
            exit()

    def clean_up(self, package, tarball=False, build_dir=False):
        if tarball:
            cmd(f"rm -vf {package.tarball}")
        if build_dir:
            cmd(f"pwd && sudo rm -rvf {package}")

    def uninstall(self, package):
        msg(f"Uninstalling {package}...")
        cmd(f"cd {package} && {package.remove}")

    def track_package(self, package, action):
        def _write():
            f.seek(0)
            f.writelines(lines)
            f.truncate()

        match action:
            case "remove":
                msg(f"Untracking {package}...")
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if repr(package) not in line]
                    _write()

            case "add":
                msg(f"Tracking {package}...")
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = list(dict.fromkeys(lines))
                    if f"{package}\n" not in lines:
                        lines.append(f"{package}\n")
                        _write()
                    else:
                        msg(f"Package '{package}' already tracked")

            case "purge":
                msg(f"Purging {package}...")
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if f"{package.name}-" not in line]
                    _write()

    def list_installed(self):
        if not self.installed_packages:
            erm("No packages installed.")
        else:
            title("Installed packages:")
            display_list(self.installed_packages)

    def get_package(self, package):
        self.track_package(package, "purge")
        self.fetch_source(package)
        self.extract_tarball(package)
        self.build(package)
        self.clean_up(package,
                      tarball=self.remove_tarballs,
                      build_dir=self.remove_build_dirs)
        self.track_package(package, "add")

    def remove_package(self, package):
        self.uninstall(package)
        self.clean_up(package, tarball=True, build_dir=True)
        self.track_package(package, "remove")


class ControlPanel:
    def __init__(self, package_manager):
        self.package_manager = package_manager

    def load_package_from_yaml(self, pkg):
        data = interpolate(os.path.join('..', self.package_manager.meta_directory, f"{pkg}.yaml"))
        package = Package(
                name=data.get("name"),
                version=data.get("version"),
                url=data.get("url", ""),
                get=data.get("get", ""),
                remove=data.get("remove", "")
                )
        return package

    def handle_args(self):
        parser = argparse.ArgumentParser(description="Tox's source-based package manager")

        parser.add_argument(
            "-g",
            "--get",
            nargs="+",
            type=str,
            help="get PACKAGE1 PACKAGE2")
        parser.add_argument(
            "-r",
            "--remove",
            nargs="+",
            type=str,
            help="remove PACKAGE1 PACKAGE2")
        parser.add_argument(
            "-l",
            "--list",
            action="store_true",
            help="list installed packages")
        # parser.add_argument(
        #     "-v",
        #     "--verbose",
        #     action="store_true",
        #     default="true",
        #     help="increase output verbosity")
        parser.add_argument(
            "-q",
            "--quiet",
            action="store_true",
            help="decreases output verbosity")

        return parser.parse_args()

    def run(self):
        args = self.handle_args()
        if args.get:
            for arg in args.get:
                package = self.load_package_from_yaml(arg)
                if self.package_manager.install_check(package):
                    msg(f"Getting {package}...")
                    self.package_manager.get_package(package)

        if args.remove:
            for arg in args.remove:
                package = self.load_package_from_yaml(arg)
                msg(f"Removing {package}...")
                self.package_manager.remove_package(package)

        if args.list:
            self.package_manager.list_installed()


def read_config(config_file):
    cfg = configparser.ConfigParser()
    cfg.read(config_file)
    return cfg


if __name__ == "__main__":
    d = debug()

    cfg = read_config("gimme.conf")

    pm = PackageManager(
        cfg=cfg
        )

    pm.make_config_dirs()

    control = ControlPanel(pm)
    control.run()
