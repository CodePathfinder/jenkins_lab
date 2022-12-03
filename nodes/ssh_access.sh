#!/usr/bin/env bash

username="jenkins"
userpass="jenkins"
os=$1

# ------------ Create new user --------------
if [ "$os" = "ub" ]; then
  adduser "${username}" --disabled-password --gecos "${username},,," &> /dev/null
  echo "${username}:${userpass}" | chpasswd &> /dev/null
  if [ "$?" -eq "0" ]; then
    echo "User ${username} has been successfully added!"
  fi
  # Add new user to sudoers
  usermod -aG sudo "${username}"
else
  useradd -c "${username}" "${username}"
  echo "${username}:${userpass}" | chpasswd &> /dev/null
  if [ "$?" -eq "0" ]; then
    echo "User ${username} has been successfully added!"
  fi
  # Add new user to sudoers
  usermod -aG wheel "${username}"
fi
echo '' > /etc/motd
# ------------ Change sshd configuration --------------
# allow PubkeyAuthentication by ssh
sudo sed -i '/PubkeyAuthentication/c PubkeyAuthentication yes' /etc/ssh/sshd_config
sudo systemctl restart sshd

# ----------- Copy public key to webservers -----------
mkdir -p /home/${username}/.ssh
cat /vagrant/.ssh/id_rsa.pub >> /home/${username}/.ssh/authorized_keys
