## Base container to run tuleap flavors on top ##

## Use the official docker centos distribution ##
FROM centos:centos6

## Get some karma ##
MAINTAINER Christian Bayle, cbayle@gmail.com

## Install dependencies ##
## Install EPEL dependencies ##
RUN yum install -y \
   epel-release \
   postfix \
   cronie \
   openssh-server \
   curl \
   ; yum install -y \
   python-pip \
   ; yum clean all

# Install Chef
# Ugly method, for certificate see: https://tickets.opscode.com/browse/CHEF-2803
RUN rpm --import http://apt.opscode.com/packages@opscode.com.gpg.key ; \
  curl -L http://www.opscode.com/chef/install.sh | bash ; \
  yum clean all
# Alternate method, see https://wiki.opscode.com/display/chef/Opscode+Yum+Repository+Excerpt
# Seems brocken
#ADD Opscode-Chef.repo /etc/yum.repos.d/
#RUN yum install -y \
#   chef \
#   ; yum clean all

# Install supervisord
#RUN pip install pip --upgrade ; pip install supervisor
RUN pip install supervisor

## Tweak configuration ##
#RUN echo "SELINUX=disabled" > /etc/selinux/config

# cronie
# Fix centos defaults
# Cron: http://stackoverflow.com/a/21928878/1528413
RUN sed -i '/session    required   pam_loginuid.so/c\#session    required   pam_loginuid.so' /etc/pam.d/crond

# openssh-server
# Gitolite will not work out-of-the-box with an error like 
# "User gitolite not allowed because account is locked"
# Given http://stackoverflow.com/a/15761971/1528413 you might want to trick
# /etc/shadown but the following pam modification seems to do the trick too
# It's better for as as it can be done before installing gitolite, hence
# creating the user.
# I still not understand why it's needed (just work without comment or tricks
# on a fresh centos install)
RUN sed -i '/session    required     pam_loginuid.so/c\#session    required     pam_loginuid.so' /etc/pam.d/sshd

# Networking
RUN echo "NETWORKING=yes" > /etc/sysconfig/network
