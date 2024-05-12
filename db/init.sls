install:
  pkg.installed:
    - name: postgresql
    - watch_in:
      - restart

postgresql:
  file.managed:
    - name: /etc/postgresql/13/main/postgresql.conf
    - source: salt://db/postgresql.conf
    - user: postgres
    - group: postgres
    - watch_in:
      - restart

hba:
  file.managed:
    - name: /etc/postgresql/13/main/pg_hba.conf
    - source: salt://db/pg_hba.conf
    - user: postgres
    - group: postgres
    - watch_in:
      - restart


restart:
  service.running:
    - name: postgresql

hole:
  cmd.run:
    - name: 'sudo ufw allow from 192.168.69.102 to any port 5432 proto tcp'
    - unless: 'sudo ufw status verbose | grep 5432'


only:
  file.managed:
    - name: /tmp/once

once:
  cmd.run:
    - name: echo "ALTER USER postgres PASSWORD 'PAPA-.fyth8/eKg'" | sudo -u postgres psql
    - onchanges:
      - only