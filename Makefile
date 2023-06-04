PYTHON = python3
VENV   = $(CURDIR)/.venv
PIP    = $(VENV)/bin/$(PYTHON) -m pip

install: $(VENV)

publish:
	rsync -vz --delete --recursive --chown=www-data:www-data src/ lucas@cassandra:/var/www/thecliwizard.xyz/

$(VENV): requirements.txt
	if test ! -d $(VENV); then $(PYTHON) -m venv $(VENV); fi
	$(PIP) install --upgrade pip -r $<
	touch $@

%.html: %.jinja | $(VENV)
	$(VENV)/bin/$(PYTHON) genjin.py -o $@ $<

.SILENT: $(VENV)
