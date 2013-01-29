require 'helper'

class S3AlternativeOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  def create_driver(conf)
    Fluent::Test::TimeSlicedOutputTestDriver.new(Fluent::S3AlternativeOutput) do
      def write(chunk)
        chunk.read
      end
    end.configure(conf)
  end

  def test_format_plaintext
    d1 = create_driver %[
      buffer_type memory
      add_new_line true
      output_include_time false
      output_include_tag false
      output_data_type attr:message
    ]
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d1.emit({"message" => "value1"}, time)
    d1.emit({"message" => "value2"}, time)
    d1.expect_format %[value1\n]
    d1.expect_format %[value2\n]
    d1.run
  end

end
