# Gem::Changelog

This gem add "changelog" subcommand to the rubygems system.

"changelog" subcommand displays the changelog of given gem, which must be
locally installed, on the terminal.

## Installation

Add this line to your application's Gemfile:

    gem 'gem-changelog'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install gem-changelog

## Usage

Say you want to read the changelog of bundler gem, run:

    $ gem changelog bundler

If you want to examine any specific version, run with -v:

    $ gem changelog bundler -v 1.3.0


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
