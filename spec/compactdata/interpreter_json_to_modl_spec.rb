# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can generate compactdata from json 1' do
    compactdata = 'key="~`value~`"'
    json = '{"key":"`value`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can generate compactdata from json 2' do
    compactdata = 'key="~`value~`"'
    json = '{"key":"`value`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end
end
