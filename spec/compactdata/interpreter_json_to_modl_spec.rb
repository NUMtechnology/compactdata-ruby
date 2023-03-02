# frozen_string_literal: true

require 'json'
require 'compactdata'

RSpec.describe CompactData do
  it 'can_generate_compactdata_from_json_1' do
    compactdata = 'key="~`value~`"'
    json = '{"key":"`value`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end

  it 'can_generate_compactdata_from_json_2' do
    compactdata = 'key="~`value~`"'
    json = '{"key":"`value`"}'
    expect(CompactData.generate(JSON.parse(json))).to eq compactdata
  end
end
