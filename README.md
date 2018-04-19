![alt ruby_silhouette](https://raw.githubusercontent.com/lukes/profile/master/img/ruby.png)

# Profile

Entirely non-discriminatory Ruby code profiling. This gem is a small wrapper around the [ruby-prof](https://github.com/ruby-prof/ruby-prof) gem, which is its only dependency. It lets you do simple but powerful profiling of your friend's bad code.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'profile', "~> 1.0"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install profile

## Getting Started

Wrap your friend's code like this:

```ruby
Profile.this("some-label") do
  # Slow code here...
end
```

The next time you call the code it will be profiled and three files will be written into a directory `profiler/some-label`:

| File | Description |
| ------------- | ------------- |
| `graph.html` | See and drill down the call tree to find where the time is spent |
| `stack.html` | Enables you to visualize the profiled code as a stack |
| `flat.txt` | List of all functions called, the time spent in each and the number of calls made to that function |

## Config

The following configurations options are available:

```ruby
Profile.config = {
  dir: '/tmp/my-dir'
  preserve: false
}
```

| Option | Description |
| ------------- | ------------- |
| `dir`  | Change the directory the files will be generated in. Default is a directory called `profiler` in your current path |
| `preserve` | When `false`, each time the code is profiled the previous files will be overwritten. When `true`, files are placed in a directory stamped with the current unix time and new files are generated with each run. Default is `false` |

## Conditional Profiling

Pass a boolean as a second parameter to toggle if profiling should occur:

```ruby
Profile.this("my-label", user.is_admin?) do
  # Slow code here...
end
```

## Contributing

Bug reports and pull requests are welcome.

To run the test suite:

    bundle exec rspec

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
