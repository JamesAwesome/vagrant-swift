#!/bin/bash
set -eu

# Add the Rabbitmq apt repo if we haven't already. 
# Ubuntu's default rabbit packages are out of date.
if [[ ! -e '/etc/apt/sources.list.d/rabbit.list' ]]; then
  echo 'deb http://www.rabbitmq.com/debian/ testing main' > /etc/apt/sources.list.d/rabbit.list
  
  wget -O /tmp/rabbit.asc http://www.rabbitmq.com/rabbitmq-signing-key-public.asc
  
  apt-key add /tmp/rabbit.asc
  
  rm -f /tmp/rabbit.asc
fi

# Update our package lists and install some basic packages.
apt-get update -y
apt-get install -y git vim tree tmux

# Clone devstack's havana branch into ~vagrant/devstack
su vagrant -c 'git clone https://github.com/openstack-dev/devstack.git -b stable/havana ./devstack/'

# Create our localrc
su vagrant -c \
"cat <<_EOF_ > ./devstack/localrc
ADMIN_PASSWORD=devstack
MYSQL_PASSWORD=devstack
RABBIT_PASSWORD=devstack
SERVICE_PASSWORD=devstack
SERVICE_TOKEN=devstack 
            
SWIFT_HASH=66a3d6b56c1f479c8b4e70ab5c2000f5
SWIFT_REPLICAS=1 
            
# unified auth system (manages accounts/tokens)
KEYSTONE_BRANCH=stable/havana

# object storage
SWIFT_BRANCH=stable/havana
            
disable_all_services
enable_service key swift mysql rabbit

CEILOMETER_BRANCH=stable/havana

# Enable the ceilometer metering services
enable_service ceilometer-acompute,ceilometer-acentral,ceilometer-collector

# Enable the ceilometer alarming services
enable_service ceilometer-alarm-evaluator,ceilometer-alarm-notifier

# Enable the ceilometer api services
enable_service ceilometer-api


_EOF_
"

# Stack that shit!
cd ./devstack
su vagrant -c 'bash ./stack.sh'
