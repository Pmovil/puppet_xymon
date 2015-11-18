
# ::xymon::client::monitor
define xymon::client::monitor (
  $cmd_file_source,
  $disabled        = false,
  $onhost          = undef,
  $maxtime         = undef,
  $needs           = undef,
  $group           = undef,
  $interval        = undef,
  $crondate        = undef,
  $envfile         = undef,
  $envarea         = undef,
  $cfg_file_source = undef,
) {
  include ::xymon::client

  concat::fragment { $name:
    target  => $::xymon::params::default_client_task_file,
    content => template('xymon/task.cfg.erb'),
    notify  => Class['::xymon::client::service'],
  }

  file { "${::xymon::params::default_client_ext_dir}/${name}":
    ensure => 'file',
    notify => Class['::xymon::client::service'],
    owner  => $::xymon::params::default_user,
    group  => $::xymon::params::default_group,
    mode   => '0755',
    source => $cmd_file_source,
  }

  if ($cfg_file_source) {
    file { "${::xymon::params::default_client_etc_dir}/${name}.cfg":
      ensure => 'file',
      notify => Class['::xymon::client::service'],
      mode   => '0644',
      source => $cfg_file_source,
    }
  }
}