# Moonclerk

Moonclerk is a Ruby wrapper around Moonclerk's read-only REST API. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moonclerk'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moonclerk

## Usage

Set your API key in an initializer (e.g. `config/initializers/moonclerk.rb`):

```ruby
 Moonclerk.api_key = "<API-KEY>"
```

### Customers

To retrieve a customer:

```ruby
Moonclerk::Customer.find(id) # #find is also aliased as #retrieve
```

To list customers:

```ruby
Moonclerk::Customer.list # #list is also aliased as #all
```

To filter customers:

```ruby
Moonclerk::Customer.where(status: "active") # #list is also aliased as #all
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/moonclerk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
