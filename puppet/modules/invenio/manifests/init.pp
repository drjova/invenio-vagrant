class invenio {
    package {
        "libmysqlclient-dev": ensure => "present";
        "libxml2-dev": ensure => "present";
        "libxslt-dev": ensure => "present";
        "npm": ensure => "present";
        "virtualenvwrapper":
            ensure => "latest",
            provider => "pip";
    }
}
