master-pkgs:
    pkg.installed:
        - names:
            - poppler-utils
            - apache2
            - libapache2-mod-wsgi
            - libapache2-mod-xsendfile
            - ssl-cert

a2dissite 000-default:
    cmd.run:
        - onlyif: test -L /etc/apache2/site-enabled/000-default
        - require:
            - pkg: apache
