import subprocess
from pprint import pprint


class debug:
    def __init__(self, s=True):
        self.s = s

    def step(self):
        if self.s:
            input("Step...")

    def pp(self, _dict):
        pprint(_dict)
        self.step()

    def pr(self, string):
        print(f" </> \x1b[1;3m{string}\x1b[0m")
        self.step()


def msg(message):
    print(f" \x1b[35;3m*\x1b[39m {message}\x1b[0m")


def erm(message):
    print(f" \x1b[31;1m*\x1b[39m {message}\x1b[0m")


def title(string):
    print(f"\x1b[1;4m{string}\x1b[0m")


def display_list(_list):
    for item in _list:
        print(f"\x1b[3m - {item}\x1b[0m")


def cmd(command, co=False, v=False):
    try:
        result = subprocess.run(command, shell=True, check=True, capture_output=True, text=True)
        if v:
            print(result.stdout.strip())
        if co:
            return result.stdout.strip()
        return True
    except subprocess.CalledProcessError as e:
        erm(f"Command '{command}' failed with error: {e.stderr}")
        return False
    except Exception as e:
        erm(f"An unexpected error occurred: {e}")
        return False


def vcmd(command):
    try:
        subprocess.run(command, shell=True, check=True)
        return True
    except subprocess.CalledProcessError as e:
        erm(f"Command '{command}' failed with error: {e.stderr}")
        return False
    except Exception as e:
        erm(f"An unexpected error occurred: {e}")
        return False


def str_to_bool(string):
    if string.lower() == "ask":
        return "ask"
    return string.lower() in ('true', 'yes', '1', 'on', 'enabled')


def prompt(message, default='n'):
    match default:
        case 'n':
            prompt_message = f" \x1b[33;3m*\x1b[39m {message} (y/N)\x1b[0m\n \x1b[33;1;3m>\x1b[0m "
            ret = False
        case 'y':
            prompt_message = f" \x1b[33;3m*\x1b[39m {message} (Y/n)\x1b[0m\n \x1b[33;1;3m>\x1b[0m "
            ret = True
        case _:
            erm(f"Invalid default '{default}' for prompt()")
            exit()

    while True:
        a = input(prompt_message).strip().lower()
        match a:
            case 'y' | 'yes':
                return True
            case 'n' | 'no':
                return False
            case '':
                return ret
            case _:
                erm(f"Invalid input '{a}'")
