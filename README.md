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
```

The next time you call the code it will be profiled and three files will be written into a directory called `profiling`.

### Files Generated

| File | Description |
| ------------- | ------------- |
| `graph.html` | Drill down into the call tree to see where the time is spent |
| `stack.html` | See the profiled code as a nested stack |
| `flat.txt` | List of all functions called, the time spent in each and the number of calls made to that function |

### Is it Fast?

No, no it's not. It's really slow. For especially gnarly, deeply nested code you will want to get up and get a coffee. This gem wraps [ruby-prof](https://github.com/ruby-prof/ruby-prof) which is partly written in C, so it's as fast as it can be.
## Options

Use the `configure` method to set some options:

```ruby
Profiler.configure({
  dir: '/tmp/my-dir',
  exclude_gems: true,
  exclude_standard_lib: true
})
```

| Option | Description | Default |
| ------ | --------|------------ |
| `dir` | Directory the files will be created in (can be relative or absolute) | `"profiling"` |
| `exclude_gems` | Exclude ruby gems from the results | `false` |
| `exclude_standard_lib` | Exclude ruby standard library from results | `false` |

## Rails Initializer

This initializer is recommended if you're planning to profile in Rails:

```ruby
# config/initializer/profiling.rb
Profiler.configure({
  dir: Rails.root.join('tmp/profiling')
})
```

## Conditional Profiling

Pass an argument `if:` to enable or disable profiling at run time:

```ruby
Profiler.run(if: user.is_admin?) do
  # Profiler will only run when if: is true.
end
```

## Labels

Labels translate to sub directories that the files will be generated in. This is handy for profiling multiple things at once, preserving files between runs, or grouping profiling results logically.

```ruby
Profiler.run("some-label") do
  # Results will be in "profiling/some-label"
end
```

### Preserving files between runs

Every time code is profiled the previous files will be overwritten unless the label is dynamic. Keep old files by adding the current time in the label so new files are generated with each run:

```ruby
Profiler.run("my-label-#{Time.now.to_i}") do
  # ...
end
```

### Organizing

Use `/` in your labels to group artefacts together in directories:

```ruby
Profiler.run("post/create") do
  # ...
end

Profiler.run("post/update") do
  # ...
end
```

## Contributing

Bug reports and pull requests are welcome.

To run the test suite:

    bundle exec rspec

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
