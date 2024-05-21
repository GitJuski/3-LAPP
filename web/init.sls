install:
  pkg.installed:
    - name: apache2

static:
  file.directory:
    - name: /home/vagrant/website/static
    - user: vagrant
    - group: vagrant
    - makedirs: True

virtualhost:
  file.managed:
    - name: /etc/apache2/sites-available/website.conf
    - source: salt://web/website.conf
    - watch_in:
      - check

proxy_conf:
  file.symlink:
    - name: /etc/apache2/mods-enabled/proxy.conf
    - target: /etc/apache2/mods-available/proxy.conf

proxy_load:
  file.symlink:
    - name: /etc/apache2/mods-enabled/proxy.load
    - target: /etc/apache2/mods-available/proxy.load

proxy_http:
  file.symlink:
    - name: /etc/apache2/mods-enabled/proxy_http.load
    - target: /etc/apache2/mods-available/proxy_http.load

ssl_conf:
  file.symlink:
    - name: /etc/apache2/mods-enabled/ssl.conf
    - target: /etc/apache2/mods-available/ssl.conf

ssl_load:
  file.symlink:
    - name: /etc/apache2/mods-enabled/ssl.load
    - target: /etc/apache2/mods-available/ssl.load

socache_shmcb:
  file.symlink:
    - name: /etc/apache2/mods-enabled/socache_shmcb.load
    - target: /etc/apache2/mods-available/socache_shmcb.load

ssl_gen:
  cmd.run:
    - name: "sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj '/C=FI/ST=Uusimaa/L=Helsinki/O=example/OU=IT/CN=example.com'"
    - unless: 'ls /etc/ssl/private/ | grep apache'


disable_default:
  file.absent:
    - name: /etc/apache2/sites-enabled/000-default.conf
    - watch_in:
      - check

enable_new:
  file.symlink:
    - name: /etc/apache2/sites-enabled/website.conf
    - target: ../sites-available/website.conf
    - watch_in:
      - check

check:
  service.running:
    - name: apache2

hole:
  cmd.run:
    - name: 'sudo ufw allow proto tcp from any to any port 80,443'
    - unless: 'sudo ufw status verbose | grep 443'