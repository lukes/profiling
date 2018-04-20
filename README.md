![alt ruby_silhouette](https://raw.githubusercontent.com/lukes/profiling/master/img/ruby.png)

# Profiling

Non-discriminatory profiling for your MRI Ruby code. This gem is a small wrapper around the [ruby-prof](https://github.com/ruby-prof/ruby-prof) gem, which is its only dependency. It lets you do simple but powerful profiling of your friend's bad code.

[![Gem Version](https://badge.fury.io/rb/profiling.svg)](https://badge.fury.io/rb/profiling)
[![CircleCI](https://circleci.com/gh/lukes/profiling/tree/master.svg?style=shield)](https://circleci.com/gh/lukes/profiling/tree/master)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'profiling', "~> 2.2"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install profiling

## Getting Started

Profile slow code from your friend or colleague like this:

```ruby
Profiler.run do
  # Slow code here...
end

# or

Profiler.run("some-label") do
  # Slow code here...
end
```

The next time you call the code it will be profiled and three files will be written into a directory `profiling`, and in the second example `profiling/some-label`.

### Files Generated

| File | Description |
| ------------- | ------------- |
| `graph.html` | Drill down into the call tree to see where the time is spent |
| `stack.html` | See the profiled code as a nested stack |
| `flat.txt` | List of all functions called, the time spent in each and the number of calls made to that function |

## Configuration

```ruby
Profiler.configure({
  dir: 'profiling', # Directory the files will be created in (default is 'profiling')
  exclude_gems: true, # Exclude ruby gems from the results (default is true)
  exclude_standard_lib: false # Exclude ruby standard library from results (default is false)
})
```

## Rails Initializer

This initializer is recommended if you're planning to profile in Rails:

```ruby
# config/initializer/profiling.rb
Profiler.configure({
  dir: Rails.root.join('tmp/profiling')
})
```

## Is it Fast?

No, no it's not. It's really slow. This gem wraps [ruby-prof](https://github.com/ruby-prof/ruby-prof), which has its profiling code written in C, so it will as quick as it can be. The code being profiled will execute slower, and it takes some more time to generate the files. You will want to get up and get a coffee.
## Conditional Profiling

Pass an argument `if:` to enable or disable profiling at run time:

```ruby
Profiler.run(if: user.is_admin?) do
  # Slow code here...
end
```

## Preserving artefacts

Every time code is profiled the previous files will be overwritten unless the label is dynamic. To keep old files, add the current time in the label so new files are generated with each run:

```ruby
Profiler.run("my-label-#{Time.now.to_i}") do
  # Slow code here...
end
```

## Organizing artefacts

Labels translate to directories, so use `/` in your labels to group artefacts together:

```ruby
Profiler.run("post/create") do
  # Slow code here...
end

Profiler.run("post/update") do
  # Slow code here...
end
```

## Contributing

Bug reports and pull requests are welcome.

To run the test suite:

    bundle exec rspec

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
