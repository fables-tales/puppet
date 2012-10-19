class www::piwik ( $git_root, $root_dir ) {
  vcsrepo { "${root_dir}":
    ensure => present,
    owner => 'wwwcontent',
    group => 'apache',
    provider => git,
    source => 'git://github.com/piwik/piwik.git',
    revision => '1.8.4',
    force => true,
  }

  file { "${root_dir}/tmp":
    ensure => directory,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '2770',
    require => Vcsrepo["${root_dir}"],
  }

  file { "${root_dir}/tmp/templates_c":
    ensure => directory,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '2770',
    require => Vcsrepo["${root_dir}"],
  }

  file { "${root_dir}/tmp/cache":
    ensure => directory,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '2770',
    require => Vcsrepo["${root_dir}"],
  }

  file { "${root_dir}/tmp/assets":
    ensure => directory,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '2770',
    require => Vcsrepo["${root_dir}"],
  }

  file { "${root_dir}/tmp/tcpdf":
    ensure => directory,
    owner => 'wwwcontent',
    group => 'apache',
    mode => '2770',
    require => Vcsrepo["${root_dir}"],
  }
}