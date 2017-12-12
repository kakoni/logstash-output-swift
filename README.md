# logstash-output-swift

This plugin is provided as an external plugin and is not part of the Logstash project.

This plugin allows you to output to Openstack swift storage.

## Changelog
See CHANGELOG.md

## Versions
Released versions are available via rubygems.

## Installation
  - Run `bin/logstash-plugin install logstash-output-swift` in your logstash installation directory
  - Configure (examples can be found in the examples directory)

## Configuration options

| Option                       | Type             | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | Required? | Default |
| ------                       | ----             | -----------                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   | --------- | ------- |
| driver_class                 | String           | Specify a driver class if autoloading fails                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      | No        | False   |

## Development and Running tests
  - `bundle exec rspec`

## Releasing
  - Update Changelog
  - Bump version in gemspec
  - Commit
  - Create tag `git tag v<version-number-in-gemspec>`
  - `gem build logstash-output-swift.gemspec`
  - `gem push`
