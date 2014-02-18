class invenio {
    package {
        "libmysqlclient-dev": ensure => "present";
        "libxml2-dev": ensure => "present";
        "libxslt-dev": ensure => "present";
        # NodeJS is required but the vanilla version may be too old.
        # https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
        #"nodejs": ensure => "present";
        "redis-server": ensure => "present";
        "virtualenvwrapper":
            ensure => "latest",
            provider => "pip";
        "grunt-cli":
            ensure => "latest",
            provider => "npm";
        "bower":
            ensure => "latest",
            provider => "npm";
    }
}
