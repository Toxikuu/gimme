#!/bin/python
# TODO: Implement dependency resolution
# TODO: Improve error handling
# TODO: Add a quiet option (can be done by adding a variable "> /dev/null" for commands)
# TODO: Add more meta files
# TODO: Untrack older versions of updated packages (might be done with the purge action; more testing needed)
# TODO: Improve package selection
from utils import display_list, erm, msg, cmd, prompt, str_to_bool, title, debug
import os
import configparser
import argparse


class Package:
    def __init__(self, name, vers, type_="extra", link="", deps=[]):
        self.name = name
        self.vers = vers
        self.type_ = type_
        self.link = link
        self.deps = deps
        self.tarball = f"{self.name}-{self.vers}.tar"

    def __repr__(self):
        return f"{self.name}-{self.vers}"


class PackageManager:
    def __init__(self, cfg):
        self.sources_directory = f"{os.path.dirname(os.path.abspath(__file__))}/src"
        self.meta_directory = f"{os.path.dirname(os.path.abspath(__file__))}/meta"
        self.tracking_file = f"{os.path.dirname(os.path.abspath(__file__))}/tracking"

        self.remove_build_dirs = str_to_bool(cfg["Removal"]["build_dirs"])
        self.remove_tarballs = str_to_bool(cfg["Removal"]["tarballs"])

        self.dependencies_yes = str_to_bool(cfg["Automation"]["dependencies"])
        self.reinstall_yes = str_to_bool(cfg["Automation"]["reinstall"])

        with open(self.tracking_file, 'r') as f:
            lines = f.readlines()
            lines = [line.strip() for line in lines if line.strip() != '']
        self.installed_packages = lines
        os.chdir(self.sources_directory)

    def make_config_dirs(self):
        os.makedirs(os.path.join('..', self.sources_directory), exist_ok=True)
        os.makedirs(os.path.join('..', self.meta_directory), exist_ok=True)

    def install_check(self, package):
        if not Q:
            msg(f"Checking if package '{package}' is installed...")
        if str(package) in self.installed_packages:
            if not self.reinstall_yes:
                return prompt(f"Package '{package}' already installed! Reinstall?", default='n')
            else:
                if not Q:
                    msg("Reinstallation automation is enabled")
        return True

    def type__check(self, package):
        if not Q:
            msg(f"Checking type for package '{package}'")
        match package.type_:
            case "extra":
                if not Q:
                    msg(f"Package '{package}' is of type 'extra'")
                return True
            case "core":
                if not Q:
                    msg(f"Package '{package}' is of type 'core'")
                return True
            case "critical":
                erm(f"Package '{package}' is of type 'critical'")
                if prompt("Proceed with isntallation?", default='n'):
                    return True
                return False
            case _:
                erm(f"Unknown type_: '{package.type_}'")
                exit()

    def fetch_source(self, package):
        try:
            if package.link:
                if not Q:
                    msg(f"Fetching source for {package}...")
                if os.path.isfile(package.tarball):
                    if not Q:
                        msg(f"Tarball {package.tarball} already exists")
                    return True
                if not cmd(f"wget '{package.link}' -O {package.tarball}", v=V):
                    erm(f"Failed to wget tarball '{package.tarball}' from url '{package.link}'")
                    return False
                msg(f"Source fetched and saved as {package.tarball}")
                return True
            else:
                msg(f"No source url for package '{package}'")
                return True
        except KeyboardInterrupt:
            msg("Caught KeyboardInterrupt")
            msg("Performing cleanup steps...")
            msg(f"Removing likely corrupted tarball '{package.tarball}'")
            self.clean_up(package, tarball=True, build_dir=False)

    def extract_tarball(self, package):
        try:
            if package.link == "":
                if not Q:
                    msg(f"Not extrarcting tarball for linkless package '{package}'")
                return True
            if os.path.isfile(package.tarball):
                if not Q:
                    msg(f"Extracting tarball '{package.tarball}'")

                temp_dir = "temp_extract"
                if os.path.isdir(temp_dir):
                    cmd(f"rm -rvf {temp_dir}", v=V)
                cmd("mkdir -pv temp_extract", v=V)

                if os.path.isdir(repr(package)):
                    cmd(f"sudo rm -rvf {package}", v=V)

                if not cmd(f"tar xvf {package.tarball} -C {temp_dir}", v=V):
                    erm(f"Failed to extract tarball '{package.tarball}'")
                    msg(f"Removing possibly corrupted tarball '{package.tarball}'")
                    cmd(f"rm -v {package.tarball}", v=V)
                    return False

                cmd(f"mv -v {temp_dir}/* {package}", v=V)
                cmd(f"rm -rv {temp_dir}", v=V)
                return True
            else:
                if not Q:
                    msg(f"Tarball '{package.tarball}' does not exist")
                    msg("Continuing without it...")
                return True
        except KeyboardInterrupt:
            msg("Caught KeyboardInterrupt")
            msg("Performing cleanup steps...")
            msg(f"Removing incomplete build directory '{package}'")
            self.clean_up(package, tarball=False, build_dir=True)

    def build(self, package):
        try:
            if not Q:
                msg(f"Building {package}...")
            # mkdir -p is necessary for certain packages (tzdata for instance)
            if cmd(f"mkdir -pv {package} && cd {package} && bash {self.meta_directory}/{package.name}.sh get", v=V):
                msg(f"Successfully installed {package}")
                return True
            else:
                erm(f"Failed to install {package}")
                return False
        except KeyboardInterrupt:
            msg("Caught KeyboardInterrupt")
            msg("Performing cleanup steps...")
            msg(f"Removing build directory '{package}'")
            self.clean_up(package, tarball=False, build_dir=True)

    def clean_up(self, package, tarball=False, build_dir=False):
        try:
            if tarball:
                cmd(f"rm -vf {package.tarball}", v=V)
            if build_dir:
                cmd(f"rm -rvf {package}", v=V)
        except KeyboardInterrupt:
            msg("Caught KeyboardInterrupt")
            msg("KeyboardInterrupt not allowed in clean_up()")
            # im not sure if this works lol

    def uninstall(self, package):
        msg(f"Uninstalling {package}...")
        if cmd(f"bash {self.meta_directory}/{package.name}.sh remove", v=V):
            return True
        msg(f"Failed to uninstall {package}")
        return False

    def track_package(self, package, action):
        def _write():
            f.seek(0)
            f.writelines(lines)
            f.truncate()

        match action:
            case "remove":
                if not Q:
                    msg(f"Untracking {package}...")
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if repr(package) not in line]
                    _write()

            case "add":
                if not Q:
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
                if not Q:
                    msg(f"Purging {package}...")
                with open(os.path.join('..', self.tracking_file), 'r+') as f:
                    lines = f.readlines()
                    lines = [line for line in lines if f"{package.name}-" not in line]
                    _write()

    def list_installed(self):
        if not self.installed_packages:
            msg("No packages installed")
        else:
            title("Installed packages:")
            display_list(self.installed_packages)

    def get_package(self, package):
        msg(f"Getting {package}...")
        self.track_package(package, "purge")

        if not self.type__check(package):
            exit()

        if not self.fetch_source(package):
            if not prompt(f"Failed to wget url '{package.link}.' Continue?", default='n'):
                exit()

        if not self.extract_tarball(package):
            if prompt(f"Failed to extract tarball '{package.tarball}.' Retry?", default='y'):
                self.fetch_source(package)
                if not self.extract_tarball(package):
                    erm("Extraction retry failed!")

        if not self.build(package):
            erm(f"Failed to build package {package}")
            msg("This is likely an issue with the get function")

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

    def parse_package_vars(self, output):
        lines = output.strip().split('\n')
        vars = {
            "NAME": lines[0],
            "VERS": lines[1],
            "TYPE": lines[2] if lines[2].strip() != "" else "extra",
            "DEPS": lines[3].split() if len(lines) > 3 and lines[3].strip() != "" else [],
            "LINK": lines[4] if len(lines) > 4 else ""
        }
        return vars

    def load_package(self, pkg):
        result = cmd(f"bash {self.package_manager.meta_directory}/{pkg}.sh vars", co=True, v=V)
        if not result:
            erm("Failed to retrieve package information")
            return None

        vars = self.parse_package_vars(result)

        package = Package(
            name=vars.get("NAME", ""),
            vers=vars.get("VERS", ""),
            type_=vars.get("TYPE", ""),
            link=vars.get("LINK", ""),
            deps=vars.get("DEPS", []),
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
        parser.add_argument(
            "-v",
            "--verbose",
            action="store_true",
            default=False,
            help="increase output verbosity")
        parser.add_argument(
            "-q",
            "--quiet",
            action="store_true",
            default=False,
            help="decreases output verbosity")

        return parser.parse_args()

    def resolve_deps(self, package):
        # Resolves all dependencies for a package
        if len(package.deps) > 0:
            title(f"Dependencies for {package}:")
            display_list(package.deps)
            if self.package_manager.dependencies_yes:
                if not Q:
                    msg("Dependency automation is enabled")
                msg("Resolving dependencies...")
                for dep in package.deps:
                    pkg = self.load_package(dep)
                    if not self.package_manager.install_check(package):
                        return False
                    self.resolve_deps(pkg)
                    self.package_manager.get_package(pkg)
            elif prompt(f"Package '{package}' has {len(package.deps)} dependencies. Continue?", default='y'):
                msg("Resolving dependencies...")
                for dep in package.deps:
                    pkg = self.load_package(dep)
                    if not self.package_manager.install_check(package):
                        return False
                    self.resolve_deps(pkg)
                    self.package_manager.get_package(pkg)
            else:
                msg(f"Cancelling installation of {package}")
                return False
        else:
            if not Q:
                msg(f"Package '{package}' has no dependencies")
        return True

    def run(self):
        args = self.handle_args()

        global V, Q
        V = args.verbose
        Q = args.quiet

        if args.get:
            for arg in args.get:
                package = self.load_package(arg)
                if not self.resolve_deps(package):
                    exit()
                if self.package_manager.install_check(package):
                    self.package_manager.get_package(package)

        if args.remove:
            for arg in args.remove:
                package = self.load_package(arg)
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

