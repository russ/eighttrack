# EightTrack

VCR for Crystal

## Installation

Add this to your application's `shard.yml`:

```yaml
dependencies:
  eighttrack:
    github: russ/eighttrack
```

## Usage

```crystal
require "eighttrack"
require "http/client"

EightTrack.use_tape("in-a-gadda-da-vita") do
  response = HTTP::Client.get("https://ipapi.co/8.8.8.8/json")
end
```

Customize the location of where the tapes are stored. The default is `spec/fixtures/eighttracks`.

```
EightTrack.configure do
  settings.tape_library_dir = "/some/path/eightracks"
end

```

## Contributing

1. Fork it ( https://github.com/russ/EightTrack/fork )
2. Create your feature branch (git checkout -b my-new-feature)
3. Commit your changes (git commit -am 'Add some feature')
4. Push to the branch (git push origin my-new-feature)
5. Create a new Pull Request

## Contributors

- [russ](https://github.com/russ) Russ Smith - creator, maintainer
