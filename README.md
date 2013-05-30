[puppet-backdrop](https://github.com/alphagov/puppet-backdrop)
======

Puppet module for installing and configuring the [backdrop](https://github.com/alphagov/backdrop) application.

It does:
- Create required directories in /etc/gds, /opt and /var/log
- Create an nginx vhost
- Create a python virtual environment
- Create a gunicorn configuration
- Create an upstart job

It does not:
- Deploy the application

## Usage

### `backdrop::app`

```puppet
backdrop::app { 'read.backdrop':
	port       => 3038,
	workers    => 4,
	app_module => 'backdrop.read.api:app',
}
```