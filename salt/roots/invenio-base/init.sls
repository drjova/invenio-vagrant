libraries-pkgs:
    pkg.installed:
        - names:
            - libjpeg-dev
            - libfreetype6-dev
            - libmysqlclient-dev
            - libtiff-dev
            - libxml2-dev
            - libxml2-dev
            - libxslt-dev
            - libwebp-dev

node.js:
    pkgrepo.managed:
        - ppa: chris-lea/node.js

ffmpeg:
    pkgrepo.managed:
        - ppa: jon-severinsson/ffmpeg

ppas-pkg:
    pkg.installed:
        - names:
            - ffmpeg
            - nodejs
        - require:
            - pkgrepo: ffmpeg
            - pkgrepo: node.js

mysql-server:
    pkg.installed

mysql:
    service.running:
        - name: mysql
        - enable: True
        - reload: True
        - require:
            - pkg: mysql-server
