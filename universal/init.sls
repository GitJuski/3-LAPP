upgrade_check:
  pkg.uptodate:
    - refresh: True

firewall_install:
  pkg.installed:
    - name: ufw

hole_in_one:
  cmd.run:
    - name: 'ufw allow 22/tcp'
    - onchanges:
      - firewall_install


enable_ufw:
  cmd.run:
    - name: 'ufw enable'
    - onchanges:
      - firewall_install