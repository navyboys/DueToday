#!/bin/bash

bundle install
if [ $? -ne 0 ]; then
  echo 'bundle install error!'
  exit 1
fi
echo 'bundle install success.'

if [ -f config/database.yml ]; then
  echo 'config/database.yml already exists, so we will not replace it with config/database.yml.template'
else
  echo 'replace with config/database.yml.template'
  cp config/database.yml.template config/database.yml
fi

rubocop --format offenses
if [ $? -ne 0 ]; then
  echo 'rubocop has warning or error!'
  exit 1
else
  echo 'rubocop check has passed.'
fi

bundle exec rails_best_practices
if [ $? -ne 0 ]; then
  echo 'rails_best_practices has warning or error!'
  exit 1
else
  echo 'rails_best_practices check has passed.'
fi

RAILS_ENV=test bundle exec rake db:reset

RAILS_ENV=test bundle exec rspec
if [ $? -ne 0 ]; then
  echo 'bundle exec rspec error!'
  exit 1
fi
echo 'bundle exec rspec success.'
