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

### Getting Started

The gem works through a client object which needs instantiation, and call methods exist on this client.

```ruby
  client = RemoteOK::Client.new
```

<hr>

### Client Config

The client has a number of configurable options set during instantiation.

#### `user_agent`

The gem will send it's own default user agent but you can override it for your own app.

```ruby
  client = RemoteOK::Client.new(user_agent: 'hello-there')
```

### Client Methods

#### `.jobs`

Items are returned as an array of `RemoteOK::Job` objects.

**Important:** These items are cached in the client once fetched to avoid excessive calls to the live site, make sure to use the [#with_fetch](#with_fetch) method to force a refresh.

```ruby
  client.jobs # => [Job, Job, Job]
```

##### Tag Searching

You can specify specific tags that you'd like the RemoteOK API to search by through tag arguments to the `.jobs` method.

```ruby
  client.jobs :ruby, :digital_nomad
```

This will return all jobs that match on Ruby **OR** Digital Nomad.

#### `.with_fetch`

A chainable method to force the client to fetch items from the live site rather than using the cached information.

```ruby
  client.with_fetch.jobs # => [Job, Job, Job]
```

<hr>

### Job methods

Jobs are retrieved from the jobs array.

```ruby
  job = client.jobs.first
```

#### `.raw`

Type: `JSON`

Returns the raw JSON data associated with the job directly from the API.

```ruby
  job.raw # => {...}
```

#### `.slug`

Type: `String`

Returns the job url slug.

```ruby
  job.slug # => "i-am-a-job-slug"
```

#### `.id`

Type: `Integer`

Returns the job id.

```ruby
  job.id # => 123456
```

#### `.epoch`

Type: `Integer`

Returns the posting epoch as an integer.

```ruby
  job.epoch # => 1_619_724_426
```

#### `.date`

Type: `DateTime`

Returns the creation date of the job as a DateTime object.

```ruby
  job.date # => DateTime<...>
```

#### `.company`

Type: `String`

Returns the name of the company the job is for.

```ruby
  job.company # => "Awesome Company"
```

#### `.company_logo`

Type: `String`

Returns RemoteOK URL for the company logo.

```ruby
  job.company_logo # => "https://remoteOK.io/assets/jobs/something.png"
```

#### `.position`

Type: `String`

Returns name of the position (job title)

```ruby
  job.position # => "Chief Awesome Officer"
```

#### `.tags`

Type: `Array`

Returns all the tags associated for the job as symbols. These can also be used for searching and filtering the API.

```ruby
  job.tags # => [:dev, :dot_net, :digital_nomad]
```

#### `.logo`

Type: `String`

String URL of logo associated with the job.

```ruby
  job.logo # => "https://remoteOK.io/assets/jobs/jobjob.png"
```

#### `.description`

Type: `String`

A string containing the job description, directly as it's stored in Remote OK. Be aware that this will likely contain HTML code in the content.

```ruby
  job.description # => "<p><strong>Our Company</strong>...."
```

#### `.description_text`

Type: `String`

A best-attempt to extract the raw text from the above, removing HTML tags and formatting.

```ruby
  job.description_text # => "Our Company...."
```

#### `.location`

Type: `String`

Written global location for the job.

```ruby
  job.location # => "North America"
```

#### `.original`

Type: `Boolean`

Flag for whether it's an original job post

```ruby
  job.original # => true
```

#### `.url`

Type: `String`

String URL to the job post on RemoteOK itself

```ruby
  job.url # => "https://remoteOK.io/remote-jobs/somejob"
```

#### `.apply_url`

Type: `String`

String URL for candidates to apply to the job

```ruby
  job.apply_url # => "https://remoteOK.io/remote-jobs/l/somejob"
```

<hr>

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

<hr>

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/IAmFledge/remoteok. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/IAmFledge/remoteok/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Remoteok project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/remoteok/blob/master/CODE_OF_CONDUCT.md).
