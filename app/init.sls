venv:
  pkg.installed:
    - pkgs:
      - virtualenv
      - python3-psycopg2

dir:
  file.directory:
    - name: /home/vagrant/website
    - user: vagrant
    - group: vagrant

virtualenv:
  cmd.run:
    - name: 'virtualenv -p python3 --system-site-packages env'
    - cwd: /home/vagrant/website
    - runas: vagrant
    - onchanges:
      - dir

requirements:
  file.managed:
    - name: /home/vagrant/website/requirements.txt
    - user: vagrant
    - group: vagrant
    - source: salt://app/requirements.txt

install:
  pip.installed:
    - requirements: /home/vagrant/website/requirements.txt
    - cwd: /home/vagrant/website
    - bin_env: /home/vagrant/website/env/bin/pip
    - user: vagrant

startproject:
  cmd.run:
    - cwd: /home/vagrant/website
    - name: 'bash -c "source env/bin/activate && django-admin startproject trio"'
    - runas: vagrant
    - onlyif: 'test ! -d /home/vagrant/website/trio'

startapp:
  cmd.run:
    - cwd: /home/vagrant/website
    - name: 'bash -c "source env/bin/activate && cd trio && ./manage.py startapp three"'
    - runas: vagrant
    - onlyif: 'test ! -d /home/vagrant/website/trio/three'

project_urls:
  file.managed:
    - name: /home/vagrant/website/trio/trio/urls.py
    - source: salt://app/purls.py
    - user: vagrant
    - group: vagrant


app_urls:
  file.managed:
    - name: /home/vagrant/website/trio/three/urls.py
    - source: salt://app/urls.py
    - user: vagrant
    - group: vagrant

views:
  file.managed:
    - name: /home/vagrant/website/trio/three/views.py
    - source: salt://app/views.py
    - user: vagrant
    - group: vagrant

models:
  file.managed:
    - name: /home/vagrant/website/trio/three/models.py
    - source: salt://app/models.py
    - user: vagrant
    - group: vagrant

admin:
  file.managed:
    - name: /home/vagrant/website/trio/three/admin.py
    - source: salt://app/admin.py
    - user: vagrant
    - group: vagrant

templates:
  file.managed:
    - name: /home/vagrant/website/trio/three/templates/helloworld.html
    - source: salt://app/helloworld.html
    - user: vagrant
    - group: vagrant
    - makedirs: True

settings:
  file.managed:
    - name: /home/vagrant/website/trio/trio/settings.py
    - source: salt://app/settings.py
    - user: vagrant
    - group: vagrant
    - watch_in:
      - restart

makemigrations:
  cmd.run:
    - cwd: /home/vagrant/website
    - name: 'bash -c "source env/bin/activate && cd trio && ./manage.py makemigrations && ./manage.py migrate"'
    - runas: vagrant
    - onchanges:
      - models

collecstatic:
  cmd.run:
    - cwd: /home/vagrant/website
    - name: 'bash -c "source env/bin/activate && cd trio && ./manage.py collectstatic"'
    - runas: vagrant
    - onchanges:
      - dir

hole:
  cmd.run:
    - name: 'sudo ufw allow from 192.168.69.101 to any port 8000 proto tcp'
    - unless: 'sudo ufw status | grep 8000'

gunicorn_user:
  user.present:
    - name: gunicorn
    - shell: /bin/false
    - system: True

ssl_gen:
  cmd.run:
    - name: "sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/gunicorn-selfsigned.key -out /etc/ssl/certs/gunicorn-selfsigned.crt -subj '/C=FI/ST=Uusimaa/L=Helsinki/O=example/OU=IT/CN=example.com'"
    - unless: 'ls /etc/ssl/private/ | grep gunicorn'

chown_private:
  file.directory:
    - name: /etc/ssl/private
    - user: root
    - group: gunicorn
    - mode: 710

chown_key:
  file.managed:
    - name: /etc/ssl/private/gunicorn-selfsigned.key
    - user: root
    - group: gunicorn
    - mode: 640

gunicorn_service:
  file.managed:
    - name: /etc/systemd/system/gunicorn.service
    - source: salt://app/gunicorn.service

daemon_reload:
  cmd.run:
    - name: 'sudo systemctl daemon-reload'
    - onchanges:
      - gunicorn_service

restart:
  service.running:
    - name: gunicorn.service
    - watch:
      - daemon_reload