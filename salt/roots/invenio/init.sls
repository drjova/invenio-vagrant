libraries-pkgs:
    pkg:
        - installed
        - names:
            - libjpeg-dev
            - libfreetype6-dev
            - libmysqlclient-dev
            - libtiff-dev
            - libxml2-dev
            - libxml2-dev
            - libxslt-dev
            - libwebp-dev

global-pip-pkgs:
    pip:
        - latest
        - names:
            - pip
            - virtualenvwrapper
        - require:
            - pkg: python-pip

mysql-server:
    pkg.installed

mysql:
    service.running:
        - name: mysql
        - require:
            - pkg: mysql-server

build-essential:
    pkg.installed
