"""
GIVEN A TEXT LINE WITH THIS STRUCTURE:

tags: ["personal-api python-packaging makefile"]

, OUTPUTS A NEW TEXT LINE WITH THIS STRUCTURE:

tags: ["personal-api", "python-packaging", "makefile"]
"""
#!/usr/bin/env python3

import argparse
import sys


def get_current_line() -> str:
    missing_arg_help_text = "example: split_tags.py line='tags: [\"personal-api python-packaging makefile\"]'"

    parser = argparse.ArgumentParser()
    parser.add_argument("line", type=str, help=missing_arg_help_text)
    parsed_arguments = parser.parse_args()
    return parsed_arguments.line


def main():
    try:
        current_line = get_current_line()
        prefix, tags, suffix = current_line.split('"')
        new_tags = []
        for tag in tags.split():
            new_tag = f'"{tag}"'
            new_tags.append(new_tag)
        new_tags_str = ", ".join(new_tags)
        new_line = prefix + new_tags_str + suffix
        print(
            new_line.replace("line=", "")
        )  # replaces the param name that had to be passed through lua
    except Exception as ex:
        print(ex)
        sys.exit(1)


if __name__ == "__main__":
    main()
