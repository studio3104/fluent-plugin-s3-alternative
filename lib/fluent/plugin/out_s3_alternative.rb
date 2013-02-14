require 'fluent/mixin/plaintextformatter'
require 'fluent/plugin/out_s3'

class Fluent::S3AlternativeOutput < Fluent::S3Output
  Fluent::Plugin.register_output('s3_alternative', self)
  include Fluent::Mixin::PlainTextFormatter
end
