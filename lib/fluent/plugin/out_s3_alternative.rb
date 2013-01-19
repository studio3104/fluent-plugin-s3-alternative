require 'fluent/mixin/plaintextformatter'

class Fluent::S3AlternativeOutput < Fluent::Output
  Fluent::Plugin.register_output('s3_alternative', self)
  include Fluent::Mixin::PlainTextFormatter

  def emit(tag, es, chain)
    es.each do |time, record|
      Fluent::Engine.emit(tag, time, record)
    end

    chain.next
  end
end
