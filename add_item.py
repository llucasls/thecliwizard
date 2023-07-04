"""add_item.py - Add elements to an HTML file programatically

Usage:
    add_item.py (-h | --help)
    add_item.py [options]

Options:
    -f, --file=<file>  an HTML file to be changed
    -t, --text=<text>  text to be added
"""
import sys

from bs4 import BeautifulSoup
from docopt import docopt


def main():
    options = docopt(__doc__)
    html_file = options["--file"]
    html_text = options["--text"]

    try:
        with open(html_file, mode="r") as file:
            content = file.read()
    except Exception:
        print("failed to read file", file=sys.stderr)
        return 1

    soup = BeautifulSoup(content, "html.parser")

    main_element = soup.find("main")
    list_element = main_element.find("ol")

    new_item = soup.new_tag("li")
    new_item.string = html_text

    list_element.append(new_item)
    try:
        with open(html_file, mode="w") as file:
            file.write(str(soup))
    except Exception:
        print("failed to write to file", file=sys.stderr)
        return 2

    return 0


if __name__ == "__main__":
    sys.exit(main())
