[puppet-backdrop](https://github.com/alphagov/puppet-backdrop)
======

Puppet module for installing and configuring the [backdrop](https://github.com/alphagov/backdrop) application.

It does:
- Create required directories in /etc/gds, /opt and /var/log
- Create an nginx vhost
- Create a python virtual environment
- Create a gunicorn configuration
- Create an upstart job

It does not: (and therefore must be done manually for the moment)
- Copy the application code into `/opt/{app name}`
- Copy correct configuration files into place `/opt/{app name}/backdrop/{module name}/config/{environment}.py`
- Install `requirements.txt` into virtualenv

The manual steps can be made a lot simpler if the backdrop app is packable and it's configuration is managed outside of the app.

## Usage

### `backdrop::app`

```puppet
backdrop::app { 'read.backdrop':
	port       => 3038,
	workers    => 4,
	app_module => 'backdrop.read.api:app',
}
```
