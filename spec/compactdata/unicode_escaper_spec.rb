# frozen_string_literal: true

require 'compactdata'

RSpec.describe CompactData do
  it 'should be able to escape unicode characters - 001' do
    expect(CompactData::UNICODE.escape("ABC \n\t\f\b\n®😀👁️‍🗨️ǅ🔥")).to eq 'ABC \n\t\f\b\n®😀👁️‍🗨️ǅ🔥'
  end

  it 'should be able to escape unicode characters - 002' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"hello\bworld\"}")).to eq '{"key"="hello\bworld"}'
  end

  it 'should be able to escape unicode characters - 003' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"hello\nworld\"}")).to eq '{"key"="hello\nworld"}'
  end

  it 'should be able to escape unicode characters - 004' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"hello\tworld\"}")).to eq '{"key"="hello\tworld"}'
  end

  it 'should be able to escape unicode characters - 005' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"hello\rworld\"}")).to eq '{"key"="hello\rworld"}'
  end

  it 'should be able to escape unicode characters - 006' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"hello\fworld\"}")).to eq '{"key"="hello\fworld"}'
  end

  it 'should be able to escape unicode characters - 007' do
    expect(CompactData::UNICODE.escape('{"key"="Claims - £3,000, £7,000 and £15,000"}')).to eq '{"key"="Claims - £3,000, £7,000 and £15,000"}'
  end

  it 'should be able to escape unicode characters - 008' do
    expect(CompactData::UNICODE.escape('{"key"="ꌰ0"}')).to eq '{"key"="ꌰ0"}'
  end

  it 'should be able to escape unicode characters - 009' do
    expect(CompactData::UNICODE.escape('{"key"="💔0"}')).to eq '{"key"="💔0"}'
  end

  it 'should be able to escape unicode characters - 010' do
    expect(CompactData::UNICODE.escape('{"key"="🐶0"}')).to eq '{"key"="🐶0"}'
  end

  it 'should be able to convert escaped unicode characters - 1' do
    expect(CompactData::UNICODE.escape('{"key"="~ua3300"}')).to eq '{"key"="~ua3300"}'
  end

  it 'should be able to convert vertical tabs correctly - 1' do
    expect(CompactData::UNICODE.escape("{\"key\"=\"\v\"}")).to eq '{"key"="~u000B"}'
  end

  it 'should be able to convert vertical tabs correctly - 2' do
    expect(CompactData::UNICODE.escape('{"key"="\v"}')).to eq '{"key"="\v"}'
  end
end
