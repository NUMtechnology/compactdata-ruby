# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can quote true when used as key' do
    compactdata = '"true"="~`test~`"'
    json = '{"true":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote 00 when used as key' do
    compactdata = '"00"="~`test~`"'
    json = '{"00":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote 01 when used as key' do
    compactdata = '"01"="~`test~`"'
    json = '{"01":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote 000 when used as key' do
    compactdata = '"000"="~`test~`"'
    json = '{"000":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote false when used as key' do
    compactdata = '"false"="~`test~`"'
    json = '{"false":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote nulls when used as keys' do
    compactdata = '"null"="~`test~`"'
    json = '{"null":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can quote numbers when used as keys' do
    compactdata = '"123"="~`test~`"'
    json = '{"123":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can unquote strings when used as keys' do
    compactdata = 'test="~`test~`"'
    json = '{"test":"`test`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can include pairs with quoted values at the root' do
    compactdata = 'a="b";b=c'
    json = '{"a":"b","b":"c"}'
    expect(JSON.generate(CompactData.parse(compactdata))).to eq json
  end
end
