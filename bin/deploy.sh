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

app_user="app_calcentral"

TARGET_REMOTE=${REMOTE:-origin}
TARGET_BRANCH=${BRANCH:-master}

# verify user
if [ "$(whoami)" != "${app_user}" ]; then
  echo "Only user ${app_user} can run this script"
  exit
fi

# cd to application's base directory
appHome="${HOME}/datacultures"
cd ${appHome}

# Stop Sidekiq after capturing pid of process
active_pid=$(ps -eo pid,command | grep -i sidekiq | grep -v grep | awk '{print $1}')
if [ ${active_pid} ]; then
  pids_dir="${appHome}/tmp/pid"
  mkdir -p "${pids_dir}"
  sidekiq_pid="${pids_dir}/sidekiq.pid"
  echo "${active_pid}" > "${sidekiq_pid}"
  sidekiqctl stop "${sidekiq_pid}" \
    || { echo 'FAILED to stop Sidekiq'; exit 1; }
else
  echo 'No need to stop Sidekiq. It is not running.'
fi
${appHome}/scripts/clear_sidekiq_queue.rb \
  || { echo 'FAILED to clear Sidekiq queue'; exit 1; }

# Create maintenace mode marker file
touch ${DOCROOT}/datacultures-in-maintenance \
  || { echo 'FAILED to put DataCultures into maintenance mode'; exit 1; }

# fetch the latest updates
git fetch $TARGET_REMOTE \
  || { echo 'FAILED to fetch the requested remote'; exit 1; }
git fetch -t $TARGET_REMOTE \
  || { echo 'FAILED to fetch the requested remote tags'; exit 1; }

# discard any local changes
git reset --hard HEAD

# check out the requested branch/tag
git checkout -qf $TARGET_BRANCH \
  || { echo 'FAILED to checkout the requested branch/tag'; exit 1; }

# get new gems if any
bundle --retry=5 || { echo 'FAILED bundle DataCultures'; exit 1; }

#  delete old assets
rake assets:clobber
rm -rf ${DOCROOT}/assets

# generate new assets and copy to the DOCROOT
rake assets:precompile
cp -R ${appHome}/public/assets/ ${DOCROOT}
cp ${appHome}/public/index.htm ${DOCROOT}

# update the DB if need be
rake db:migrate
rake db:seed

# generate new Application Secret Key Base
thor keys:app_new_secret

chmod 600 ${appHome}/config/secrets.yml \
  || { echo 'FAILED to change permissions on yml file'; exit 1; }

# resume normal apache mode
rm -f ${DOCROOT}/datacultures-in-maintenance \
  || { echo 'FAILED to take DataCultures out of maintenance mode'; exit 1; }

# Touch file to restart Apache. See https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html
touch ${appHome}/tmp/restart.txt

# Start Sidekiq
mkdir -p "${appHome}/tmp/log"
bundle exec sidekiq -L "${appHome}/tmp/log/sidekiq.log" -d \
  || { echo 'FAILED to start Sidekiq'; exit 1; }
