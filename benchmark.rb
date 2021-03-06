# encoding: utf-8

require 'json/add/complex'
require 'json/add/rational'
OJ_RAILS = { mode: :rails  }.freeze

require './lib/test_data_json'
require './lib/test_data_rails'

require 'oj'
require './lib/msg_pack_rails_compat'

require 'benchmark'
begin
  require 'benchmark/memory'
rescue LoadError => e
end

obj = TEST_DATA_JSON.merge(TEST_DATA_RAILS)
obj.delete(:'ActiveModel::Errors')
obj.delete(:'ActiveRecord::Relation')
obj.delete(:'ActiveRecord')
obj.delete(:Complex)

puts "\n"

if Benchmark.respond_to?(:memory)
  Benchmark.memory do |x|
    x.report('Rails to_json') { 10_000.times { obj.to_json } }
    x.report('msgpack') { 10_000.times { MessagePack.pack(obj) } }
    x.report('Oj.dump') { 10_000.times { Oj.dump(obj, OJ_RAILS) } }
    x.compare!
  end
  puts "---------------------------------------------\n\n"
end

Benchmark.benchmark(Benchmark::CAPTION, 14, Benchmark::FORMAT) do |x|
  x.report('Rails to_json') { 10_000.times { obj.to_json } }
  x.report('msgpack') { 10_000.times { MessagePack.pack(obj) } }
  x.report('Oj.dump') { 10_000.times { Oj.dump(obj, OJ_RAILS) } }
end

puts "\n"
