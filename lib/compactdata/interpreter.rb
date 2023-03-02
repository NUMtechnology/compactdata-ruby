# frozen_string_literal: true

require 'json'

# The CompactData namespace
module CompactData
  # Interpreter-specific errors
  class ParserError < StandardError
  end

  # CompactData String to Ruby Hash/Array/primitive
  def self.parse(str)
    CompactData::Parser.parse_compactdata(str).to_j
  end

  # Ruby Hash/Array/primitive to CompactData
  def self.generate(obj)
    CompactData::Model::CompactData.new(CompactData::Model.to_compactdata(obj)).to_m
  end
end
