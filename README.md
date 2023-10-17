# Hashipack

Hashipack is a Ruby client for Hashicorp's Packer.

It allows building images and provides live status updates about the progress, as well as the resulting artifacts.

## Installation

Install the gem and add to the application's Gemfile by executing:

```bash
bundle add hashipack
```

If bundler is not being used to manage dependencies, install the gem by executing:

```bash
gem install hashipack
```

And require it in your program:

```ruby
require 'hashipack'
```

## Usage

Create a client:

```ruby
client = Hashipack::Client.new
```

Build an image by providing the template:

```ruby
template = File.read('myimage.pkr.hcl')
result = client.build(template)
```

Subscribe to log messages and print them as they arrive:

```ruby
print_message = -> (message) { puts message }
result = client.build(template, on_output: print_message)

# This would print something like
# ...
# ==> myvm.hcloud.example: Shutting down server...
# ==> myvm.hcloud.example: Creating snapshot ...
# ==> myvm.hcloud.example: This can take some time
# ...
```

In addition to the template, you can also provide a lambda that is called when the builder progresses. You
need to define an estimated build duration in seconds so hashipack can calculate the progress.

```ruby
print_message = -> (message) { puts message }
print_progress = -> (progress) { puts progress }
result = client.build(template, on_output: print_message, on_progress: print_progress, estimated_duration: 300)
```

The result contains an array of artifacts that were generated during the build:

```ruby
print result
# => [#<hashipack::Artifact @builder_id="hcloud.builder", @id="131872234", @string="A snapshot was created: 'packer-1697561712'">]
```

This usually includes the following fields:

| Field | Value | Example |
|---|---|---|
| builder_id | The plugin name | `"hcloud.builder"` |
| id | The platforms native artifact id  | `"131872234"`, which is the ID of the image on Hetzner Cloud |
| string | The completion message by Packer | `"A snapshot was created: 'packer-1697561712'"` |

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/code-fabrik/hashipack.
