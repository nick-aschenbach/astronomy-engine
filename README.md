# AstronomyEngine

A mountable engine for the `astronomy` gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'astronomy_engine'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install astronomy_engine

## Usage

Add the mount point for the engine in your rails app:

```ruby
Rails.application.routes.draw do
  ...
  mount AstronomyEngine::App => '/astronomy'
  ...
end
```

Request the list of categories:

```bash
curl {APPLICATION_ROOT}/astronomy/categories
```

Request all topics for a given category:

```bash
curl {APPLICATION_ROOT}/astronomy/categories/Star/topics
```

Search all topic names and descriptions:

```bash
curl {APPLICATION_ROOT}/astronomy/topics?q=cluster
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/astronomy_engine/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
