# logstash-output-swift

This plugin is provided as an external plugin and is not part of the Logstash project.
Its forked from [logstash-out-s3](https://github.com/logstash-plugins/logstash-output-s3) project.

This plugin allows you to output to Openstack swift storage.

## Changelog
See CHANGELOG.md

## Versions
Released versions are available via rubygems.

## Installation
  - Run `bin/logstash-plugin install logstash-output-swift` in your logstash installation directory
  - Configure

## Configuration options

| Option           | Type             | Description                                 | Required? | Default |
| ------           | ----             | -----------                                 | --------- | ------- |
| username         | String           | Openstack Username                          | Yes       |         |
| api_key          | String           | Openstack apikey                            | Yes       |         |
| auth_url         | String           | Keystone server                             | Yes       |         |
| project_name     | String           | Project name                                | Yes       |         |
| domain_name      | String           | Domain name                                 | Yes       |         |
| container        | String           | Swift container for the logs                | Yes       |         |

## Development and Running tests
  - `bundle exec rspec`

## Releasing
  - Update Changelog
  - Bump version in gemspec
  - Commit
  - Create tag `git tag v<version-number-in-gemspec>`
  - `gem build logstash-output-swift.gemspec`
  - `gem push`
