# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |gem|
  gem.name          = "fluent-plugin-s3-alternative"
  gem.version       = "0.0.1"
  gem.authors       = ["Satoshi SUZUKI"]
  gem.email         = ["studio3104.com@gmail.com"]
  gem.description   = %q{Amazon S3 output plugin for Fluentd event collector}
  gem.summary       = %q{S3 output plugin alternative implementation. option other than format_json is compatible with s3 plugin.}
  gem.homepage      = "https://github.com/studio3104/fluent-plugin-s3-alternative"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "fluentd"
  gem.add_development_dependency "fluent-mixin-plaintextformatter"
  gem.add_development_dependency "aws-sdk"
  gem.add_development_dependency "flexmock"
  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "fluent-mixin-plaintextformatter"
  gem.add_runtime_dependency "aws-sdk"
  gem.add_runtime_dependency "flexmock"
  gem.add_runtime_dependency "fluent-plugin-s3"
end
