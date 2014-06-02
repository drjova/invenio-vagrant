toolbox-pkgs:
    pkg.installed:
        - names:
            - vim
            - ack-grep
            - git
            - subversion
            - mercurial
            - curl
            - screen

python-pkgs:
    pkg.installed:
        - names:
            - python
            - python-dev
            - python-pip
            - virtualenvwrapper
            - build-essential
            - gfortran

ppa-pkgs:
    pkg.installed:
        - names:
            - python-software-properties
            - python-pycurl

/etc/sudoers.d/vagrant:
    file.managed:
        - source:
            - salt://toolbox/sudoer
        - user: root
        - group: root
        - mode: 0440

/etc/hosts:
    file.managed:
        - source:
            - salt://toolbox/hosts
        - template: jinja
        - user: root
        - group: root
        - mode: 0644

/home/vagrant/.bashrc:
    file.append:
        - text: |
            if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
                . /usr/local/bin/virtualenvwrapper.sh
            fi
            if [ -d /home/vagrant/.bin ]; then
                export PATH=$PATH:/home/vagrant/.bin
            fi
            if [ -d /home/vagrant/private/src/invenio-devscripts ]; then
                export PATH=$PATH:/home/vagrant/private/src/invenio-devscripts
            fi

/home/vagrant/.bin/git-new-workdir:
    file.managed:
        - source:
            - salt://toolbox/git-new-workdir
        - user: vagrant
        - group: vagrant
        - mode: 0755
