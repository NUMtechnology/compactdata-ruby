# CompactData Parser

This Ruby gem is a CompactData parser and requires Ruby 2.6.0.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'compactdata'
```

And then execute:

    $ bundle install

Or clone the repository and build and install it yourself as:

    $ rake install
    
    or if that fails:
    
    $ sudo rake install

## Usage

In `irb`:

```ruby
2.6.0 :001 > require 'compactdata'
 => true
2.6.0 :002 > CompactData.parse 'a=b'
 => {"a"=>"b"}
2.6.0 :003 >
```
In a Ruby file:

```ruby
require 'compactdata'

str='s=CompactData'
pretty = true
result = CompactData.parse str
puts result

```
where `str` is the CompactData to be parsed. 

## Development

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
