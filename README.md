# Guard::Cane
[![Build Status](https://travis-ci.org/guard/guard-cane.png?branch=master)](https://travis-ci.org/guard/guard-cane)
[![Gem Version](https://badge.fury.io/rb/guard-cane.png)](http://badge.fury.io/rb/guard-cane)

Guard::Cane automatically runs [Cane](https://github.com/square/cane#usage)
when files change.

## Installation

Put this in your Gemfile:

```rb
group :development
  gem 'guard-cane'
end
```

And then install with:

```sh
$ bundle
$ guard init cane
```

This will place the following in your `Guardfile`:

```rb
guard :cane do
  watch(%r{^app/(.+)\.rb$})
end
```

It's also recommended to add a `.cane` file to your project:

```
--abc-max 10
--no-doc
--style-exclude spec/**/*
```

See [square/cane](https://github.com/square/cane#usage) for detailed usage.

