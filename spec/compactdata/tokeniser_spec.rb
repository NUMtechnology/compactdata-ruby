# frozen_string_literal: true

require 'compactdata'

RSpec.describe CompactData::Tokeniser do
  it 'can tokenise "a=b" with leading whitespace' do
    result = CompactData::Tokeniser.tokenise '   a=b'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == 'b').to be true
  end

  it 'can tokenise "a=(b=c)"' do
    result = CompactData::Tokeniser.tokenise 'a=(b=c)'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == '(').to be true
    expect(result[3].value == 'b').to be true
    expect(result[4].value == '=').to be true
    expect(result[5].value == 'c').to be true
    expect(result[6].value == ')').to be true
  end

  it 'can tokenise "a=123"' do
    result = CompactData::Tokeniser.tokenise 'a=123'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == 123).to be true
  end

  it 'can tokenise "a=1.0"' do
    result = CompactData::Tokeniser.tokenise 'a=1.0'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == 1.0).to be true
  end

  it 'can tokenise "a=`b`"' do
    result = CompactData::Tokeniser.tokenise 'a=`b`'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == '`b`').to be true
  end

  it 'can tokenise a="b"' do
    result = CompactData::Tokeniser.tokenise 'a="b"'
    expect(result[0].value == 'a').to be true
    expect(result[1].value == '=').to be true
    expect(result[2].value == '"b"').to be true
  end
end
