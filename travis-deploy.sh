#!/bin/sh
cd ansible
./galaxy-install.sh
python3 ansible-deploy.py
