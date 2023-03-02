# frozen_string_literal: true

require 'compactdata'

RSpec.describe CompactData do
  tests = [
    'a=b',
    'a(b(c=d))',
    'a[c;d;e]',
    '[c;d;e]',
    '[c=d;d=e;e=f]',
    '[(c=d;d=e;e=f)]',
    '[(c=d;x(d=1;e=2.01;f=true;g=false;h=nil;i=a string with spaces))]',
    'a=1',
    'a=1.1',
    'a=true',
    'a=false',
    'a=nil',
    'a',
    '1',
    '2.01',
    '-3',
    '-2.1',
    'x=`()`',
    'x=`[]`',
    'x=`"`',
    'x=`"`',
    'x="~`"'
  ]
  tests.each do |t|
    it "can generate CompactData \"#{t}\"" do
      result = CompactData.generate(CompactData.parse(t))
      expect(result).to eq t
    end
  end

  it 'can generate CompactData from x="`"' do
    result = CompactData.generate(CompactData.parse('x="`"'))
    expect(result).to eq 'x="~`"'
  end

  it 'can generate CompactData "true"' do
    result = CompactData.generate(CompactData.parse('true'))
    expect(result).to eq true
  end

  it 'can generate CompactData "false"' do
    result = CompactData.generate(CompactData.parse('false'))
    expect(result).to eq false
  end

  it 'can generate CompactData "null"' do
    result = CompactData.generate(CompactData.parse('null'))
    expect(result).to eq 'null'
  end
end
