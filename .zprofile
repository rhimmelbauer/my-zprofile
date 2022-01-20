echo "Happy Programming Rob :)"
export PYCURL_SSL_LIBRARY=openssl 
export LDFLAGS="-L/usr/local/opt/openssl/lib" 
export CPPFLAGS="-I/usr/local/opt/openssl/include" 
export PATH=/Applications/Postgres.app/Contents/Versions/13/bin:$PATH

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

gc () {
    git commit -m $1
}

gc-a () {
    git commit -a -m $1
}

ga () {
    git add .
}

gs () {
    git status
}

vs-s () {
    source ../.env
}

gpu () {
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

d-m () {
    python manage.py migrate
}

d-mm () {
    python manage.py makemigrations
}

d-r () {
    python manage.py runserver
}

d-cr () {
    python manage.py collectreact
}

d-c () {
    python manage.py collectstatic
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
    ./manage.py loaddata site group permafrost headless_settings flatpages locality core/fixtures/user.json user_profile emails inventory location category tag collection container siteconfiguration siteconfigs catalog step path program product offering journey enrollment reactappsettings
}

tc-scratch-prod() {
    pgsql-flush-db trainingcamp;
    pgrestore trainingcamp django ~/Downloads/heroku_prod_2021-12-14_10-30am.sql;
    d-m;
    ./manage.py fixdata --verbosity 1
}

tc-scratch-dev() {
    pgsql-flush-db trainingcamp;
    d-m;
    tc-loaddata;
    ./manage.py fixdata --verbosity 1 
}
