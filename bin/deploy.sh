#!/bin/bash

# script to deploy the datacultures code
#   $DOCROOT environment variable must be set
#   (e.g., export DOCROOT=/var/www/html/datacultures)
#   it is suggested that this be done in a per-installation basis
#    once in the ~/.bashrc (from the app user).
#    An absolulte path should be used (e.g., no ~ for home directory)
#
#  usage:
#
#  $ bin/deploy.sh

# put apache in maintenace mode
touch /var/www/html/datacultures/datacultures-in-maintenance

## discard any changes that now exist
git reset HEAD
git checkout -- *

# get new code
git pull origin master

# get new gems if any
bundle

#  delete old assets
rake assets:clobber
rm -rf $DOCROOT/assets

# generate new assets and copy to the DOCROOT
rake assets:precompile
cp -R public/assets/ $DOCROOT
cp public/index.htm $DOCROOT

# update the DB if need be
rake db:migrate

# resume normal apache mode
rm /var/www/html/datacultures/datacultures-in-maintenance
