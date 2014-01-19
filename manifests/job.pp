define rundeck::job (
  $ensure              = 'present',
  $project,
  $description         = '',
  $command_exec,
  $command_description = '',
  $filter,
  $template            = 'rundeck/job/simple_job.yaml.erb',
  $format              = 'xml',
  $job_loglevel        = 'INFO',
  $keepgoing           = true,
  $strategy            = 'node-first',) {
  if !($format == 'xml' or $format == 'yaml') {
    fail("format can only be 'xml' or 'yaml', ${format} is not supported")
  }

  $template_file = "${rundeck::template_job_dir}/${name}.${format}"

  case $ensure {
    'present' : {
      file { "rundeck-job-template-${name}":
        ensure  => $ensure,
        path    => $template_file,
        content => template($template),
        mode    => $rundeck::config_file_mode,
        owner   => $rundeck::config_file_owner,
        group   => $rundeck::config_file_group,
        audit   => $rundeck::manage_audit,
      } ~> exec { "rundeck-job-load-${name}":
        command     => "rd-jobs load -p ${project} --file ${template_file} -F ${format} -r",
        path        => '/usr/bin',
        refreshonly => true,
      }
    }
    'absent'  : {
      exec { "rundeck-job-purge-${name}":
        command => "rd-jobs -a purge -p ${project} ${name}",
        path    => '/usr/local/bin',
      }
    }
    default   : {
      fail("rundeck::job only supports 'present' and 'absent', '${ensure}' is unknown.'")
    }
  }
}