import subprocess


def msg(message):
    print(f" \x1b[35;3m*\x1b[39m {message}\x1b[0m")


def erm(message):
    print(f" \x1b[31;1m*\x1b[39m {message}\x1b[0m")


def cmd(command):
    try:
        subprocess.run(command, shell=True, check=True)
        return True
    except subprocess.CalledProcessError:
        erm(f"Command '{command}' failed!")
        return False


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
