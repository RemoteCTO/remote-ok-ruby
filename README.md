# RemoteOK API Ruby Client

<a href="https://codeclimate.com/github/IAmFledge/remote-ok-ruby/maintainability"><img src="https://api.codeclimate.com/v1/badges/b60f02bbaa5fd337e0cf/maintainability" /></a>

<a href="https://codeclimate.com/github/IAmFledge/remote-ok-ruby/test_coverage"><img src="https://api.codeclimate.com/v1/badges/b60f02bbaa5fd337e0cf/test_coverage" /></a>

## Installation

#### Requirements

- Ruby >= 2.6.0

Add this line to your application's Gemfile:

```ruby
gem 'remoteok'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install remoteok

## Usage

### Authentication

RemoteOK does not currently require direct authentication, rather simply exists as a JSON document at the url:

> https://remoteok.io/api

### Delayed Items & Legal

Items in the API are available 24 hours later than on the web. It is important to note that this document contains it's own legal terms within it, which at the time of writing are:

> API Terms of Service: Please link back to the URL on Remote OK and mention Remote OK as a source, so we get traffic back from your site. If you do not we'll have to suspend API access.

> Please don't use the Remote OK logo without written permission as they're registered trademarks, please DO use our name Remote OK though

> The API feed at \/api is delayed by 24 hours so that Google knows it's Remote OK first posting the job to avoid duplicate content problems, if you'd like to advertise or pay for instant API access for all remote jobs (minimum budget $10k\/mo), contact [@remoteok](https://twitter.com/remoteok) on Twitter."

You can fetch a realtime version of this document by using

```ruby
  RemoteOK::Client.new.legal # => String of legal copy.
```

### Creating A Client

```ruby
  client = RemoteOK::Client.new
```

### Fetching Jobs

```ruby
  client.jobs # => [Job, Job, Job]
```

### Job methods

```ruby
  job = client.jobs.first
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/IAmFledge/remoteok. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/IAmFledge/remoteok/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Remoteok project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/remoteok/blob/master/CODE_OF_CONDUCT.md).
