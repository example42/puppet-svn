# = Define: svn::reposync
#
# This define creates, executes and optionally crontabs a
# simple svn_reposync_* script that exports or checkouts a svn
# repository to a local directory.
# By default this script is placed in:
# /usr/local/sbin/svn_reposync_${name}
# and can be executed directly by hand, via Puppet (if autorun is true)
# via cron (if cron is defined) or via the master script:
# /usr/local/sbin/svn_reposync
#
# == Parameters:
#
# [*source_url*]
#   Url of the repository to use. As passed to the svn command
#   present in the svn_reposync script. Required.
#
# [*destination_dir*]
#   Local directory where to sync the repository, As passed to the
#   svn command present in the svn_reposync script. Required.
#
# [*action*]
#   Which svn action to use: export or checkout. Default: export.
#
# [*extra_options*]
#   Optional extra options to add to svn command. Default: ''.
#
# [*update_extra_options*]
#   Optional extra options to add to svn update command. Default: ''.
#
# [*autorun*]
#   Define if to automatically execute the svn_reposync script when
#   Puppet runs. Default: true.
#
# [*creates*]
#   Path of a file or directory created by the svn command. If it
#   exists Puppet does not automatically execute the svn_reposync
#   command (when autorun is enabled). Default: $destination_dir.
#
# [*pre_command*]
#   Optional comman to execute before executing the svn command.
#   Note that this command is placed in the svn_reposync script created
#   by this define and it's executed every time this script is run (either
#   manually or via Puppet). Default: ''
#
# [*post_command*]
#   Optional comman to execute after executing the svn command.
#   Note that this command is placed in the svn_reposync script created
#   by this define and it's executed every time this script is run (either
#   manually or via Puppet). Default: ''
#
# [*basedir*]
#   Directory where the svn_reposync scripts are created.
#   Default: /usr/local/sbin
#
# [*cron*]
#   Optional cron schedule to crontab the execution of the
#   svn_reposync script. Format must be in standard cron style.
#   Example: '0 4 * * *' . Default: '' (no cron scheduled).
#
# [*owner*]
#   Owner of the created svn_reposync script. Default: root.
#
# [*group*]
#   Group of the created svn_reposync script. Default: root.
#
# [*mode*]
#   Mode of the created svn_reposync script. Default: '7550'.
#   NOTE: Keep the execution flag!
#
# [*ensure*]
#   Define if the svn_reposync script and eventual cron job
#   must be present or absent. Default: present.
#
# == Examples
#
# - Minimal setup (with autorun and export)
# svn::reposync { 'my_app':
#   source_url      => 'http://repo.example42.com/svn/trunk/my_app/',
#   destination_dir => '/opt/myapp',
# }
#
# - Execute a acustom command after svn checkout (with default autorun)
# svn::reposync { 'my_app':
#   source_url      => 'http://repo.example42.com/svn/trunk/my_app/',
#   destination_dir => '/opt/myapp',
#   action          => 'checkout',
#   post_command    => 'chown -R my_user:my_user /opt/myapp',
# }
#
define svn::reposync (
  $source_url,
  $destination_dir,
  $action                 = 'export',
  $extra_options          = '',
  $update_extra_options   = '',
  $autorun                = true,
  $creates                = $destination_dir,
  $pre_command            = '',
  $post_command           = '',
  $basedir                = '/usr/local/sbin',
  $cron                   = '',
  $owner                  = 'root',
  $group                  = 'root',
  $mode                   = '0755',
  $ensure                 = 'present' ) {

  if ! defined(File['svn_reposync']) {
    file { 'svn_reposync':
      ensure  => present,
      path    => "${basedir}/svn_reposync",
      mode    => $mode,
      owner   => $owner,
      group   => $group,
      content => template('svn/reposync/svn_reposync.erb'),
    }
  }

  file { "svn_reposync_${name}":
    ensure  => $ensure,
    path    => "${basedir}/svn_reposync_${name}",
    mode    => $mode,
    owner   => $owner,
    group   => $group,
    content => template('svn/reposync/svn_reposync-command.erb'),
  }

  if $autorun == true {
    exec { "svn_reposync_run_${name}":
      command     => "${basedir}/svn_reposync_${name}",
      creates     => $creates,
      user        => $owner,
    }
  }

  if $cron != '' {
    file { "svn_reposync_cron_${name}":
      ensure  => $ensure,
      path    => "/etc/cron.d/svn_reposync_${name}",
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      content => template('svn/reposync/svn_reposync-cron.erb'),
    }
  }
}
