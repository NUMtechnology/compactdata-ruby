# frozen_string_literal: true

require 'compactdata'

RSpec.describe CompactData::Parser do
  it 'can parse "a=b" with leading whitespace' do
    result = CompactData::Parser.parse_compactdata '   a=b'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataString: b'
  end

  it 'can parse "a=(b=c)"' do
    result = CompactData::Parser.parse_compactdata 'a=(b=c)'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataMap: ["CompactDataPair: b=CompactDataString: c"]'
  end

  it 'can parse "a=123"' do
    result = CompactData::Parser.parse_compactdata 'a=123'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataInteger: 123'
  end

  it 'can parse "a=1.0"' do
    result = CompactData::Parser.parse_compactdata 'a=1.0'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataFloat: 1.0'
  end

  it 'can parse "a=`b`"' do
    result = CompactData::Parser.parse_compactdata 'a=`b`'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataQuoted: b'
  end

  it 'can parse a="b"' do
    result = CompactData::Parser.parse_compactdata 'a="b"'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataQuoted: b'
  end

  it 'can parse a="()"' do
    result = CompactData::Parser.parse_compactdata 'a="()"'
    expect(result.to_s).to eq 'CompactData: CompactDataPair: a=CompactDataQuoted: ()'
  end
end
