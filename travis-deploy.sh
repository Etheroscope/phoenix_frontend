#!/bin/sh
cd ansible
ls
ansible-galaxy install -r requirements.yml
python3 ansible-deploy.py
