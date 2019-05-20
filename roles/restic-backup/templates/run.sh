#!/bin/bash
set -e
export RESTIC_REPOSITORY={{ restic_repo }}
export RESTIC_PASSWORD_FILE=/root/backup/password-file-{{ name }}

cd /root/backup

# postgresql
for databaseName in {{ postgres_databases | join(' ') }}; do
  sudo -u postgres pg_dump -U postgres -F p $databaseName  | ./restic backup --verbose --stdin --stdin-filename $databaseName.sql
done 


# folders
{% for folder in folders %}
./restic backup --verbose {{ folder }} -e "*.git" -e cache -e _cacache
{% endfor %}
