toolbox-pkgs:
    pkg:
        - installed
        - names:
            - vim
            - ack-grep
            - git
            - curl

python-pkgs:
    -pkg:
        - installed
        - names:
            - python
            - python-dev
            - python-pip
            - virtualenvwrapper

/etc/sudoers.d/vagrant:
    file.managed:
        - source:
            - salt://toolbox/sudoer
        - user: root
        - group: root
        - mode: 0440

/home/vagrant/.bashrc:
    file.append:
        - text: |
            if [ -f /usr/local/bin/virtualenvwrapper.sh ]; then
                . /usr/local/bin/virtualenvwrapper.sh
            fi
