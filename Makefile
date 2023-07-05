PYTHON = python3
VENV   = $(CURDIR)/.venv
PIP    = $(VENV)/bin/$(PYTHON) -m pip

NODE_MODULES = $(CURDIR)/node_modules

LESS = $(NODE_MODULES)/.bin/lessc
LIVE_SERVER = $(NODE_MODULES)/.bin/live-server

LESS_FILES  != find src/ -name '*.less'
JINJA_FILES != find src/ -name '*.jinja'

CSS_FILES  := $(patsubst src/%.less,dist/%.css,$(LESS_FILES))
HTML_FILES := $(patsubst src/%.jinja,dist/%.html,$(JINJA_FILES))

build: clean $(CSS_FILES) $(HTML_FILES)

install: $(VENV) $(NODE_MODULES)

publish:
	rsync -vz --delete --recursive --chown=www-data:www-data dist/ lucas@cassandra:/var/www/thecliwizard.xyz/

$(VENV): requirements.txt
	if test ! -d $(VENV); then $(PYTHON) -m venv $(VENV); fi
	$(PIP) install --upgrade pip -r $<
	touch $@

$(NODE_MODULES): package.json
	yarn
	touch $@

dev: build
	node $(LIVE_SERVER) dist/index.html

dist/%.html: src/%.jinja $(VENV) | dist
	@mkdir -p $(dir $@)
	@$(VENV)/bin/$(PYTHON) genjin.py -o $@ $<

dist/%.css: src/%.less $(NODE_MODULES) | dist
	@mkdir -p $(dir $@)
	@$(LESS) $< $@

dist:
	mkdir dist

clean: | dist
	-rm -rf dist/*

.SILENT: $(VENV) $(NODE_MODULES) dist clean dev

.PHONY: build install publish dev clean
