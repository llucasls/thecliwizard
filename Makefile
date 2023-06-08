PYTHON = python3
VENV   = $(CURDIR)/.venv
PIP    = $(VENV)/bin/$(PYTHON) -m pip

NODE_MODULES = $(CURDIR)/node_modules

LESS = $(NODE_MODULES)/.bin/lessc

install: $(VENV) $(NODE_MODULES)

publish:
	rsync -vz --delete --recursive --chown=www-data:www-data src/ lucas@cassandra:/var/www/thecliwizard.xyz/

$(VENV): requirements.txt
	if test ! -d $(VENV); then $(PYTHON) -m venv $(VENV); fi
	$(PIP) install --upgrade pip -r $<
	touch $@

$(NODE_MODULES): package.json
	yarn
	touch $@

%.html: %.jinja | $(VENV)
	$(VENV)/bin/$(PYTHON) genjin.py -o $@ $<

%.css: %.less | $(NODE_MODULES)
	$(LESS) $< $@

dist:
	mkdir dist

clean: | dist
	-rm -rf dist/*

.SILENT: $(VENV) $(NODE_MODULES) dist
