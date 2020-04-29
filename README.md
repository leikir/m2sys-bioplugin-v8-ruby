# M2SYS::BioPlugin::V8

This gem provides a handy wrapper to use the M2SYS BioPlugin v8 API.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'm2sys-bioplugin-v8', github: 'leikir/m2sys-bioplugin-v8-ruby'
```

And then execute:
```bash
$ bundle
```

## Configuration

You can do this, for instance, in a Rails initializer:
```
M2SYS::BioPlugin::V8.configure do |config|
  config.api_host = 'https://mybioplugininstance.com/api/Biometric'
  config.engine_name = M2SYS::BioPlugin::V8::ENGINE_NAME_FINGERPRINT
end
```

## Usage

### Register a record

Do as follows:
```
template = M2SYS::BioPlugin::V8::Fingers.new(
  data_type: M2SYS::BioPlugin::V8::Fingers::DATA_TYPE_IMAGE,
  fingers: [
    M2SYS::BioPlugin::V8::Finger.new(
      pos: 1,
      data: 'put your base64-encoded WSQ data here'
    )
  ]
)

template.register(id: 'my-id')
```

If the registration succeeds, the result will be a M2SYS::BioPlugin::V8::RegisterSuccess instance.
If it failed because an already-known record matched the biometric template, a M2SYS::BioPlugin::V8::RegisterMatchFoundError error will be raised, containing information. You can catch it like this:
```
try
  template.register(id: 'my-id')
rescue M2SYS::BioPlugin::V8::RegisterMatchFoundError => e
  puts "Existing record matched: #{e.match_id}"
end
```

## Contributing
Contribution directions to be completed.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
