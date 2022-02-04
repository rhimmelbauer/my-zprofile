echo "Himmelbauer"

mkve() { 
    echo "Creating Python 3 Environment: $1 "; 
    python3 -m venv --prompt "$1" venv; 
    source "venv/bin/activate"; 
    pip install --upgrade pip;
    source .env 
}

ve() { 
    source "venv/bin/activate"; 
    source .env;
}

veclean () { 
    echo "Cleaning out venv";
    pip install --upgrade pip; 
    pip freeze > dump; 
    pip uninstall -y -r dump; 
    rm dump; 
}
vereset () { 
    echo "Resetting venv"; 
    pip install --upgrade pip; 
    pip freeze > dump; 
    pip uninstall -y -r dump; 
    rm dump; pip install -e .; 
    pip freeze | grep -v "-e " > requirements.txt; 
    pip install ipython pylint; 
}

sqs-msgs () {
    aws sqs get-queue-attributes --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1 --attribute-names All
}

sqs-send () {
    aws sqs send-message --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1 --message-body $2 --delay-seconds $3
}

sqs-get () {
    aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1
}

sqs-get-10 () {
    aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1 --attribute-names All --message-attribute-names All --max-number-of-messages 10
}

sqs-get-poll() {
    aws sqs receive-message --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1 --attribute-names All --message-attribute-names All --max-number-of-messages 10 --wait-time-seconds $2
}

sqs-delete-queue () {
    aws sqs delete-queue --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1
}
sqs-purge () {
    aws sqs purge-queue --queue-url https://sqs.us-west-2.amazonaws.com/277094087663/$1
}

sqs-ls () {
    aws sqs list-queues
}

g-c () {
    git commit -m $1
}

gc-a () {
    git commit -a -m $1
}

g-a () {
    git add .
}

g-s () {
    git status
}

vs-s () {
    source ../.env
}

g-pu () {
    git push -u origin $1
}

gcheck-dev () {
    git checkout develop
}

gcheck-new () {
    git checkout -b $1
}

gb-l () {
    git branch -l
}

gb-rename () {
    git branch -m $1
}

s () {
    source venv/bin/activate
}

sf () {
    source $1
}

se () {
    source .env
}

se-f () {
    source $1
}

drm () {
    deactivate;
    rm -rf venv;
    mkve venv;
}

d-m () {
    ./manage.py migrate
}

d-mm () {
    ./manage.py makemigrations
}

d-r () {
    ./manage.py runserver
}

d-cr () {
    ./manage.py collectreact
}

d-c () {
    ./manage.py collectstatic --noinput
}

d-t () {
    ./manag.py test
}

d-ta () {
    ./manage.py test $1
}

pip-ir () {
    pip install -r requirements.txt
}

pip-ie () {
    pip install -e .
}

pip-idev () {
    pip install -e .'[dev]'
}

pgrestore () {
    pg_restore -v -d $1 --no-acl --no-owner --role=$2 "$3"
}

pgsql () {
    psql -p5432 "$1"
}

pgsql-flush-db () {
    psql -c "drop database $1";
    psql -c "create database $1";
}

tc-truncate-tables () {
    psql -d trainingcamp -f ~/tc_truncate_tables.sql
}

tc-loaddata () {
    ./manage.py loaddata site group permafrost headless_settings flatpages locality core/fixtures/user.json user_profile emails inventory location category tag collection container siteconfiguration siteconfigs catalog step path program product offering journey enrollment quizzing reactappsettings
}

tc-scratch-prod() {
    pgsql-flush-db trainingcamp;
    pgrestore trainingcamp django ~/Downloads/heroku_prod_1-21-2022_6_20pm.sql;
    d-m;
    ./manage.py fixdata --verbosity 1
}

tc-scratch-dev() {
    pgsql-flush-db trainingcamp;
    d-m;
    tc-loaddata;
    d-cr;
    d-c;
    ./manage.py fixdata --verbosity 1 
}

tc-pip () {
    cp ~/.config/pip/pip_edit.conf venv/pip.conf
}

tc-drm () {
    drm;
    tc-pip;
}

