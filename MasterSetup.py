# Usage -> Please use the flag --vagrant-master or -vm if you are using a vagrant master. Example -> sudo python3 MasterSetup --vagrant-master
# To use on your own created master of host master, simply leave out the flags. Example -> sudo python3 MasterSetup
# sudo is needed for the script to be able to copy files to /srv/salt/

import os
import shutil
import sys
import time

flag = sys.argv[-1]

path = '/srv/salt/'

if flag == '--vagrant-master' or flag == '-vm':

    check = os.path.isfile('/etc/ufw/ufw.conf')

    if check == False:

        os.system('sudo apt install ufw -y && sudo ufw allow 22/tcp && sudo ufw enable && sudo ufw allow 4505/tcp && sudo ufw allow 4506/tcp')

    os.system('sudo salt-key -A -y')

    time.sleep(5)

    os.system('sudo salt "*" test.ping')

    directories = ['/vagrant/app', '/vagrant/db', '/vagrant/web', '/vagrant/universal']

    if not os.path.isdir(path):
        os.makedirs(path)

    if not os.path.isfile('/srv/salt/top.sls'):
        shutil.copyfile('/vagrant/top.sls', path+'top.sls')

    for i in directories:
        destfold = i.split('/')[-1]
        if not os.path.isdir(path+destfold):
            shutil.copytree(i, path+destfold)

    for root, dirs, files in os.walk(path):

        for dir in dirs:
            os.chmod(os.path.join(root, dir), 0o755)

        for file in files:
            os.chmod(os.path.join(root, file), 0o644)

else:

    os.system('sudo salt-key -A -y')

    time.sleep(5)

    os.system('sudo salt "*" test.ping')

    directories = ['./app', './db', './web', './universal']

    if not os.path.isdir(path):
        os.makedirs(path)

    for i in directories:
        destfold = i.split('/')[-1]
        if not os.path.isdir(path+destfold):
            shutil.copytree(i, path+destfold)

    for root, dirs, files in os.walk(path):

        for dir in dirs:
            os.chmod(os.path.join(root, dir), 0o755)

        for file in files:
            os.chmod(os.path.join(root, file), 0o644)