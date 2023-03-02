# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can_generate_compactdata_from_json_with_embedded_backspace' do
    compactdata = 'key=hello\bworld'
    json = '{"key":"hello\\bworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_with_embedded_newline' do
    compactdata = 'key=hello\nworld'
    json = '{"key":"hello\\nworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_with_embedded_tab' do
    compactdata = 'key=hello\tworld'
    json = '{"key":"hello\\tworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_with_embedded_CR' do
    compactdata = 'key=hello\rworld'
    json = '{"key":"hello\\rworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_with_embedded_formfeed' do
    compactdata = 'key=hello\fworld'
    json = '{"key":"hello\\fworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_with_embedded_verticaltab' do
    compactdata = 'key=hello~u000Bworld'
    json = '{"key":"hello\u000Bworld"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_escape_graves' do
    compactdata = 'key="~`test~`"'
    json = '{"key":"`test`"}'

    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end
end
