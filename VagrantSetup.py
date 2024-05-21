# Usage -> To provision a master vm use the flag --vagrant-master or -vm. Example -> python3 VagrantSetup.py --vagrant-master. This will provision (web, app, db, master)
# To use your own created master or host master, simply leave out the flags. Example -> python3 VagrantSetup.py
# There is no salt-master support on Windows. That's why I recommend using the flags provided if using Windows. Without the flags, it will only provision (web, app, db), so you need to configure an external master.

import os
import shutil
from sys import platform, argv

flag = argv[-1]

flags = ['VagrantSetup.py', '.\VagrantSetup.py', '--vagrant-master', '-vm']

if flag not in flags:
    print(flag)
    raise ValueError('Incorrect flag, did you mean --vagrant-master or -vm')

user = os.getlogin()

parent = ''

if platform == 'win32':
    
    parent += f'C:/Users/{user}/'


elif platform == 'linux' or platform == 'linux2':

    parent += f'/home/{user}/'

else:
    raise SystemError('Unsupported Operating System')



directory = 'testi/trio/'

path = os.path.join(parent, directory)

try:
    os.makedirs(path)
    print('Directory created')
except FileExistsError: print('Directory already exists')

file = path+'Vagrantfile'

directories = ['./app', './db', './web', './universal']

isfile = os.path.isfile(file)

if isfile == False:

    shutil.copyfile('./Vagrantfile', file)
    print('File created')

else:
    print('File already exits')


for i in directories:
    destfold = i.split('/')[1]
    new = path+destfold
    if not os.path.isdir(path+i):
        shutil.copytree(i, new)

try:
    shutil.copyfile('./top.sls', path+'top.sls')
    shutil.copyfile('./MasterSetup.py', path+'MasterSetup.py')
except FileExistsError: pass

ch = os.chdir(path)

print('Currently in:', os.getcwd())

if flag == '--vagrant-master' or flag == '-vm':

    os.system('vagrant up')

else:

    with open(f'{path}Vagrantfile', 'r') as file:
        lines = file.readlines()

    new_file = [line for line in lines if 'master' not in line.lower()]

    with open(f'{path}Vagrantfile', 'w') as file:
        file.writelines(new_file)

    os.system('dir')