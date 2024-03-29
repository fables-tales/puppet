class www::teamgit {

  $anonpw = extlookup("ldap_anon_user_pw")
  file { '/usr/local/bin/team_repos_conf_builder.py':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '700',
    content => template('www/team_repos_conf_builder.py.erb'),
  }

  file { '/usr/local/bin/team_repos_conf_template.conf':
    ensure => present,
    owner => 'root',
    group => 'root',
    mode => '600',
    source => 'puppet:///modules/www/team_repos_conf_template.conf',
  }

  exec { 'create_team_git':
    command => '/usr/local/bin/team_repos_conf_builder.py /etc/httpd/conf.d/teamgit.conf',
    cwd => '/usr/local/bin',
    require => [File['/usr/local/bin/team_repos_conf_builder.py'],
                Package['python-ldap'], Exec['pop_ldap']],
    notify => Service['httpd'],
    user => 'root',
    provider => 'shell',

    # Puppet can't track the fact this this file is autogenerated. We could try
    # restarting the webserver every time, but that's unpleasent. So instead,
    # test to see whether any changes are going to occur, and only refresh if
    # they do.
    onlyif => '\
        tmpfile=`mktemp`;\
        /usr/local/bin/team_repos_conf_builder.py  $tmpfile;\
        cmp $tmpfile /etc/httpd/conf.d/teamgit.conf;\
        res=$?;\
        rm $tmpfile;\
        if test $res = 0; then\
            exit 1;\
        fi;\
        exit 0;'
  }
}
