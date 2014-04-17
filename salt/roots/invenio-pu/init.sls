global-pip-pkgs:
    pip.installed:
        - names:
            - pip >= 1.5
            - virtualenvwrapper >= 4.2
            - flower
            - honcho
            - redis
        - require:
            - pkg: python-pip

npm-packages:
    npm.installed:
        - names:
            - bower
            - grunt-cli
        - require:
            - pkg: nodejs

redis-server:
    pkg.installed

redis:
    service.running:
        - name: redis-server
        - enable: True
        - reload: True
        - require:
            - pkg: redis-server

/home/vagrant/invenio-setup.sh:
    file.managed:
        - source:
            - salt://invenio-pu/setup.sh
        - user: vagrant
        - group: vagrant
        - mode: 0755
