define backdrop::app (
	$port        = undef,
	$workers     = 4,
	$app_module  = undef,
) {
	$app_path = "/opt/${title}"
	$virtualenv_path = "/var/virtualenvs/${title}"
	$log_path = "/var/log/${title}"
	$config_path = "/etc/gds/${title}"

	file { ["$app_path", "$log_path", "$config_path"]:
		ensure => directory,
		owner  => 'deploy',
		group  => 'deploy',
	}
	nginx::vhost::proxy { "${title}-vhost":
		port          => 80,
		servername    => join(["${title}", hiera('domain_name')],'.'),
		ssl           => false,
		upstream_port => $port,

	}
	python::virtualenv { "$virtualenv_path":
		ensure     => present,
		version    => '2.7',
		systempkgs => false,
		owner      => 'deploy',
		group      => 'deploy',
	}
	file { "$config_path/gunicorn":
		ensure  => present,
		owner   => 'deploy',
		group   => 'deploy',
		content => template('backdrop/gunicorn.erb')
	}
	upstart::job { "$title":
		description   => "Backdrop API for $title",
		respawn       => true,
		respawn_limit => '5 10',
		user          => 'deploy',
		group         => 'deploy',
		chdir         => "$app_path",
		environment   => {
			"GOVUK_ENV" => "production",
		},
		exec          => "$virtualenv_path/bin/gunicorn -c $config_path/gunicorn $app_module"
	}	
}