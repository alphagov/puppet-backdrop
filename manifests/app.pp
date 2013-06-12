define backdrop::app (
    $port        = undef,
    $workers     = 4,
    $app_module  = undef,
    $user        = undef,
    $group       = undef,
) {
    include nginx::server
    include upstart

    $app_path = "/opt/${title}"
    $virtualenv_path = "${app_path}/venv"
    $log_path = "/var/log/${title}"
    $config_path = "/etc/gds/${title}"

    file { ["$app_path", "$log_path", "$config_path"]:
        ensure => directory,
        owner  => $user,
        group  => $group,
    }
    nginx::vhost::proxy { "${title}-vhost":
        port          => 80,
        servername    => $title,
        ssl           => false,
        upstream_port => $port,

    }
    python::virtualenv { "$virtualenv_path":
        ensure     => present,
        version    => '2.7',
        systempkgs => false,
        owner      => $user,
        group      => $group,
    }
    file { "$config_path/gunicorn":
        ensure  => present,
        owner   => $user,
        group   => $group,
        content => template('backdrop/gunicorn.erb')
    }
    upstart::job { "$title":
        description   => "Backdrop API for $title",
        respawn       => true,
        respawn_limit => '5 10',
        user          => $user,
        group         => $group,
        chdir         => $app_path,
        environment   => {
            "GOVUK_ENV" => "production",
        },
        exec          => "$virtualenv_path/bin/gunicorn -c $config_path/gunicorn $app_module"
    }
}
