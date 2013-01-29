# fluent-plugin-s3-alternative

## Component
### Amazon S3 output plugin for Fluentd event collector
S3 output plugin alternative implementation.
option other than format_json is compatible with s3 plugin.

Added many format realized by fluent-mixin-plaintextfomatter mixin.
* format whole data as serialized JSON, single attribute or separated multi attributes
* include time as line header, or not
* include tag as line header, or not
* change field separator (default: TAB)
* add new line as termination, or not

## Configuration

    <match pattern>
      type s3_alternative

      aws_key_id YOUR_AWS_KEY_ID
      aws_sec_key YOUR_AWS_SECRET/KEY
      s3_bucket YOUR_S3_BUCKET_NAME
      s3_endpoint s3-ap-northeast-1.amazonaws.com
      s3_object_key_format {path}{time_slice}_{index}.{file_extension}
      path logs/
      buffer_path /var/log/fluent/s3
    
      time_slice_format %Y%m%d-%H
      time_slice_wait 10m
      utc
    
      add_new_line true
      output_include_time false
      output_include_tag false
      output_data_type attr:message
    </match>

## Installation

Add this line to your application's Gemfile:

    gem 'fluent-plugin-s3-alternative'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-s3-alternative

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Copyright

### Copyright
Copyright (c) 2012- Satoshi SUZUKI (@studio3104)

### License
Apache License, Version 2.0
