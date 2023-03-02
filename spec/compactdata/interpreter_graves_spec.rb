# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can generate compactdata from json with embedded backspace' do
    compactdata = 'key=hello\bworld'
    json = '{"key":"hello\\bworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json with embedded newline' do
    compactdata = 'key=hello\nworld'
    json = '{"key":"hello\\nworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json with embedded tab' do
    compactdata = 'key=hello\tworld'
    json = '{"key":"hello\\tworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json with embedded CR' do
    compactdata = 'key=hello\rworld'
    json = '{"key":"hello\\rworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json with embedded formfeed' do
    compactdata = 'key=hello\fworld'
    json = '{"key":"hello\\fworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json with embedded verticaltab' do
    compactdata = 'key=hello~u000Bworld'
    json = '{"key":"hello\u000Bworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can escape graves' do
    compactdata = 'key="~`test~`"'
    json = '{"key":"`test`"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end
end
