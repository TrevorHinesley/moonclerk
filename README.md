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

By default, Moonclerk will look for your API key at `ENV["MOONCLERK_API_KEY"]`, but you can set it manually in an initializer (e.g. `config/initializers/moonclerk.rb`) if you'd like:

```ruby
 Moonclerk.api_key = "<API-KEY>"
```

### Customers

To retrieve a customer:

```ruby
Moonclerk::Customer.find(id) # or Moonclerk::Customer.retrieve(id)
```

To list customers:

```ruby
Moonclerk::Customer.list # or Moonclerk::Customer.all

# Options include count and offset
# NOTE: Count defaults to 10, and offset to 0
```

To filter customers:

```ruby
Moonclerk::Customer.where(status: "active")

# Options include form_id, checkout_from, checkout_to, next_payment_from, next_payment_to, status, count, offset
# NOTE: Any parameter ending in _from or _to is expected to be a Date, Time or DateTime
# NOTE: Count defaults to 10, and offset to 0
```

### Forms

To retrieve a form:

```ruby
Moonclerk::Form.find(id) # or Moonclerk::Form.retrieve(id)
```

To list forms:

```ruby
Moonclerk::Form.list # or Moonclerk::Form.all

# Options include count and offset
# NOTE: Count defaults to 10, and offset to 0
```

### Payments

To retrieve a payment:

```ruby
Moonclerk::Payment.find(id) # or Moonclerk::Payment.retrieve(id)
```

To list payments:

```ruby
Moonclerk::Payment.list # or Moonclerk::Payment.all

# Options include count and offset
# NOTE: Count defaults to 10, and offset to 0
```

To filter payments:

```ruby
Moonclerk::Payment.where(status: "active")

# Options include form_id, customer_id, date_from, date_to, status, count, offset
# NOTE: Any parameter ending in _from or _to is expected to be a Date, Time or DateTime
# NOTE: Count defaults to 10, and offset to 0
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/moonclerk/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
