PYTHON = python3
VENV   = $(CURDIR)/.venv
PIP    = $(VENV)/bin/$(PYTHON) -m pip
YARN   = yarn

NODE_MODULES = $(CURDIR)/node_modules

LESS        = $(NODE_MODULES)/.bin/lessc
LIVE_SERVER = $(NODE_MODULES)/.bin/live-server
NODEMON     = $(NODE_MODULES)/.bin/nodemon

LESS_FILES  != find src/ -name '*.less'
JINJA_FILES != find src/ -name '*.jinja'

CSS_FILES  := $(patsubst src/%.less,dist/%.css,$(LESS_FILES))
HTML_FILES := $(patsubst src/%.jinja,dist/%.html,$(JINJA_FILES))

DIST_CSS_FILES  != find dist/ -name '*.css'
DIST_HTML_FILES != find dist/ -name '*.html'

NO_SRC := $(filter-out $(CSS_FILES),$(DIST_CSS_FILES))
NO_SRC += $(filter-out $(HTML_FILES),$(DIST_HTML_FILES))

RSYNC_FLAGS := -vz --delete --recursive --chown=www-data:www-data

build: clean $(CSS_FILES) $(HTML_FILES)

install: $(VENV) $(NODE_MODULES)

publish:
	rsync $(RSYNC_FLAGS) dist/ lucas@cassandra:/var/www/thecliwizard.xyz/

$(VENV): requirements.txt
	if test ! -d $@; then $(PYTHON) -m venv $@; fi
	$(PIP) install --upgrade pip -r $<
	touch $@

$(NODE_MODULES): package.json
	$(YARN)
	touch $@

dev:
	$(NODEMON) | node $(LIVE_SERVER) dist/

dist/%.html: src/%.jinja $(VENV) base.jinja | dist
	@mkdir -p $(dir $@)
	@$(VENV)/bin/$(PYTHON) genjin.py -o $@ $<

dist/%.css: src/%.less $(NODE_MODULES) | dist
	@mkdir -p $(dir $@)
	@$(LESS) $< $@

dist:
	mkdir dist

clean: $(NO_SRC) | dist
	if test -n "$^"; then rm $^; fi

.SILENT: $(VENV) $(NODE_MODULES) dist clean dev

.PHONY: build install publish dev clean
