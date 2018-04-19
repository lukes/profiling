![alt ruby_silhouette](https://raw.githubusercontent.com/lukes/profile/master/img/ruby.png)

# Profile

Non-discriminatory profiling for your MRI Ruby code. This gem is a small wrapper around the [ruby-prof](https://github.com/ruby-prof/ruby-prof) gem, which is its only dependency. It lets you do simple but powerful profiling of your friend's bad code.

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

Profile slow code from your friend or colleague like this:

```ruby
Profile.run do
  # Slow code here...
end

# or

Profile.run("some-label") do
  # Slow code here...
end
```

The next time you call the code it will be profiled and three files will be written into a directory `profiled`, and in the second example `profiled/some-label`:

| File | Description |
| ------------- | ------------- |
| `graph.html` | Drill down into the call tree to see where the time is spent |
| `stack.html` | See the profiled code as a nested stack |
| `flat.txt` | List of all functions called, the time spent in each and the number of calls made to that function |

## Configuration

Change the directory the files will be generated in:

```ruby
Profile.config = {
  dir: '/tmp/my-dir'
}
```

## Conditional Profiling

Pass a second argument `if:` to enable or disable profiling:

```ruby
Profile.run(if: user.is_admin?) do
  # Slow code here...
end

# or:

Profile.run("my-label", if: user.is_admin?) do
  # Slow code here...
end
```

##
## Preserving artefacts

Every time the code is profiled the previous files will be overwritten unless the label's dynamic. To keep old files, include the current time in the label so new files are generated with each run:

```ruby
Profile.run("my-label-#{Time.now.to_i}") do
  # Slow code here...
end
```

## Organizing artefacts

Labels translate to directories, so use `/` in your labels if you want to group profiling together logically:

```ruby
Profile.run("post/create") do
  # Slow code here...
end

Profile.run("post/update") do
  # Slow code here...
end
```

## Contributing

Bug reports and pull requests are welcome.

To run the test suite:

    bundle exec rspec

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
