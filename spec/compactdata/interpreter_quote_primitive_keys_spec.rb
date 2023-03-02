# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can_quote_true_when_used_as_key' do
    compactdata = '"true"="~`test~`"'
    json = '{"true":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_00_when_used_as_key' do
    compactdata = '"00"="~`test~`"'
    json = '{"00":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_01_when_used_as_key' do
    compactdata = '"01"="~`test~`"'
    json = '{"01":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_000_when_used_as_key' do
    compactdata = '"000"="~`test~`"'
    json = '{"000":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_false_when_used_as_key' do
    compactdata = '"false"="~`test~`"'
    json = '{"false":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_nulls_when_used_as_keys' do
    compactdata = '"null"="~`test~`"'
    json = '{"null":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_quote_numbers_when_used_as_keys' do
    compactdata = '"123"="~`test~`"'
    json = '{"123":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_unquote_strings_when_used_as_keys' do
    compactdata = 'test="~`test~`"'
    json = '{"test":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_include_pairs_with_quoted_values_at_the_root' do
    compactdata = 'a="b";b=c'
    json = '{"a":"b","b":"c"}'
    expect(JSON.generate(CompactData.parse(compactdata))).to eq json
  end
end
