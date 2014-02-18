class invenio {
    package {
        "automake":
            name => "automake1.9",
            ensure => "present";
        "clisp": ensure => "present";
        "djvulibre-bin": ensure => "present";
        "ffmpeg": ensure => "present";
        "gnuplot": ensure => "present";
        "gettext": ensure => "present";
        "imagemagick": ensure => "present";
        "libav-tools": ensure => "present";
        "libmysqlclient-dev": ensure => "present";
        "libtiff-tools": ensure => "present";
        "libxml2-dev": ensure => "present";
        "libxslt-dev": ensure => "present";
        "netpbm": ensure => "present";
        "openoffice.org": ensure => "present";
        "pdftk": ensure => "present";
        "poppler-utils": ensure => "present";
        "pstotext": ensure => "present";
        "python-libxml2": ensure => "present";
        "python-libxslt1": ensure => "present";
        "python-magic": ensure => "present";
        "sbcl": ensure => "present";
        "texlive": ensure => "present";
        "unzip": ensure => "present";
        "MySQL-python":
            name => "MySQL-python",
            ensure => "1.2.3",
            provider => "pip";
        "pyRXP":
            name => "http://www.reportlab.com/ftp/pyRXP-1.16-daily-unix.tar.gz",
            ensure => "present",
            provider => "pip";
        "python-dateutil":
            name => "python-dateutil",
            ensure => "1.5",
            provider => "pip";
        "numpy":
            ensure => "present",
            provider => "pip";
    }

    package { ["beautifulsoup4", "blinker", "epydoc", "flask", "fixture",
               "gnuplot-py", "lxml", "pep8", "pyflakes", "pylint", "pyPDF",
               "python-openid", "rauth", "rdflib", "redis", "reportlab",
               "simplejson", "sqlalchemy", "wtforms"]:
            ensure => "present",
            provider => "pip",
            require => Package["numpy"]
    }

    package { ["Flask-Admin", "Flask-Assets", "Flask-Cache", "Flask-Email",
               "Flask-Gravatar", "Flask-Login", "Flask-Script",
               "Flask-SQLAlchemy", "Flask-Testing", "Flask-WTF"]:
        ensure => "present",
        provider => "pip",
        require => Package["flask"]
    }
}
