require 'helper'

class S3AlternativeOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
#    buffer_path /tmp/bf.%Y%m%d.log
    buffer_type memory
  ]

  def create_driver(conf = CONFIG, tag='test')
    Fluent::Test::TimeSlicedOutputTestDriver.new(Fluent::S3AlternativeOutput) do
      def write(chunk)
        chunk.read
      end
    end.configure(conf)
  end

  def test_format
    d1 = create_driver
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d1.emit({"a"=>1}, time)
    d1.emit({"a"=>2}, time)
    d1.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":1}\n]
    d1.expect_format %[2011-01-02T13:14:15Z\ttest\t{"a":2}\n]
    d1.run

    d2 = create_driver %[
      buffer_type memory
      add_new_line true
      output_include_time false
      output_include_tag false
      output_data_type attr:message
    ]
    time = Time.parse("2011-01-02 13:14:15 UTC").to_i
    d2.emit({"message" => "[28/Jan/2013:15:40:06 +0900] \"GET /server-status?auto HTTP/1.1\" 200 1183 \"-\" \"munin/2.0.8 (libwww-perl/5.805)\" \"-\" \"-\" \"-\" 218 1342 573"}, time)
    d2.emit({"message" => "[28/Jan/2013:15:40:10 +0900] \"OPTIONS * HTTP/1.0\" 403 202 \"-\" \"Apache (internal dummy connection)\" \"-\" \"-\" \"-\" 70 366 169"}, time)
    d2.expect_format %[[28/Jan/2013:15:40:06 +0900] \"GET /server-status?auto HTTP/1.1\" 200 1183 \"-\" \"munin/2.0.8 (libwww-perl/5.805)\" \"-\" \"-\" \"-\" 218 1342 573\n]
    d2.expect_format %[[28/Jan/2013:15:40:10 +0900] \"OPTIONS * HTTP/1.0\" 403 202 \"-\" \"Apache (internal dummy connection)\" \"-\" \"-\" \"-\" 70 366 169\n]
    d2.run
  end

end
