# frozen_string_literal: true

require 'compactdata'

RSpec.describe CompactData do
  it 'can parse "a=b" with leading whitespace' do
    result = JSON.generate(CompactData.parse('   a=b'))
    expect(result).to eq '{"a":"b"}'
  end

  it 'can parse "a=(b=c)"' do
    result = JSON.generate(CompactData.parse('a=(b=c)'))
    expect(result).to eq '{"a":{"b":"c"}}'
  end

  it 'can parse a(b(c(d=e)))' do
    result = JSON.generate(CompactData.parse('a(b(c(d=e)))'))
    expect(result).to eq '{"a":{"b":{"c":{"d":"e"}}}}'
  end

  it 'can parse "a=123"' do
    result = JSON.generate(CompactData.parse('a=123'))
    expect(result).to eq '{"a":123}'
  end

  it 'can parse "a=1.0"' do
    result = JSON.generate(CompactData.parse('a=1.0'))
    expect(result).to eq '{"a":1.0}'
  end

  it 'can parse "a=`b`"' do
    result = JSON.generate(CompactData.parse('a=`b`'))
    expect(result).to eq '{"a":"b"}'
  end

  it 'can parse a="b"' do
    result = JSON.generate(CompactData.parse('a="b"'))
    expect(result).to eq '{"a":"b"}'
  end

  it 'can parse a=true' do
    result = JSON.generate(CompactData.parse('a=true'))
    expect(result).to eq '{"a":true}'
  end

  it 'can parse a=false' do
    result = JSON.generate(CompactData.parse('a=false'))
    expect(result).to eq '{"a":false}'
  end

  it 'can parse a=null' do
    result = JSON.generate(CompactData.parse('a=null'))
    expect(result).to eq '{"a":null}'
  end

  it 'can parse [a=1;b=2]' do
    result = JSON.generate(CompactData.parse('[a=1;b=2]'))
    expect(result).to eq '[{"a":1},{"b":2}]'
  end

  it 'can parse a=1;b=2' do
    result = JSON.generate(CompactData.parse('a=1;b=2'))
    expect(result).to eq '{"a":1,"b":2}'
  end

  it 'can deal with braced strings 1' do
    result = JSON.generate(CompactData.parse('a={1};b={[]}'))
    expect(result).to eq '{"a":"{1}","b":"{[]}"}'
  end

  it 'can deal with braced strings 2' do
    result = JSON.generate(CompactData.parse('a={};b={[()}'))
    expect(result).to eq '{"a":"{}","b":"{[()}"}'
  end

  it 'can deal with braced strings with an escaped brace' do
    result = JSON.generate(CompactData.parse('a={this is a test { test 1 \} }'))
    expect(result).to eq '{"a":"{this is a test { test 1 } }"}'
  end

  it 'can deal with quoted braced strings as normal quoted strings' do
    result = JSON.generate(CompactData.parse('a="{this is a test { test 1 } }"'))
    expect(result).to eq '{"a":"{this is a test { test 1 } }"}'
  end
end
