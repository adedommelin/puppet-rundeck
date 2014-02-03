class rundeck::repository {
  if $rundeck::manage_repos {
    case $::operatingsystem {
      /(?i:Ubuntu|Mint|Debian)/ : {
        apt::repository { 'rundeck':
          url        => 'http://dl.bintray.com/rundeck/candidate-deb',
          distro     => '',
          repository => '/',
        }
      }
      /(?i:CentOS|Amazon|RedHat)/ : {
        file { '/etc/yum.repos.d/rundeck.repo':
          ensure  => 'present',
          source  => 'puppet:///modules/rundeck/yum/rundeck.repo',
          owner   => 'root',
          group   => 'root',
          mode    => '0644',
        }
      }
      default: {
        notice("Unknown operating system ${::operatingsystem}")
      }
    }
  }
}
