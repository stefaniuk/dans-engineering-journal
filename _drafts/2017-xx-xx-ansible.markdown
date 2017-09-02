---
layout: post
title: "Ansible"
date: 2017-01-01 00:00:00 Europe/London
comments: true
---
an automation and orchestration tool
runs
    connect via ssh
    deploy and run module, any lang but python installed an most platforms by default
    return json
installation http://docs.ansible.com/ansible/latest/intro_installation.html
    - osx -> brew install ansible
    - ubuntu -> sudo apt-get install ansible

ansible all -i 'localhost,' -c local -m ping
ansible all -i 'localhost,' -c local -m setup -a 'filter=*processor*'
