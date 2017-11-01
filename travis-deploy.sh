#!/bin/sh
cd ansible
sudo ./galaxy-install.sh
python3 ansible-deploy.py
