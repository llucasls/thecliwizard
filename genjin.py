"""genjin.py - Generate HTML from Jinja2 templates

Usage:
    genjin.py (-h | --help)
    genjin.py [options] <template>

Options:
    -o, --output=<output>  Write resulting content into output file
"""
import sys
from datetime import datetime

from jinja2 import Environment, FileSystemLoader
from docopt import docopt


options = docopt(__doc__)


template_dir = "./"
env = Environment(loader=FileSystemLoader(template_dir))


if options["<template>"] is None:
    print("please provide a template file", file=sys.stderr)
    sys.exit(1)
else:
    template_file = options["<template>"]


date = datetime.today().strftime("%d %b %Y")
iso_date = datetime.today().date().isoformat()
template = env.get_template(template_file)
rendered_html = template.render(date=date, iso_date=iso_date)


output_file = options["--output"]
if output_file is None:
    print(rendered_html)
else:
    with open(output_file, mode="w") as file:
        file.write(rendered_html)
        file.write("\n")
