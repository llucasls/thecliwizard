publish:
	rsync -vz --delete --recursive --chown=www-data:www-data src/ lucas@cassandra:/var/www/thecliwizard.xyz/
