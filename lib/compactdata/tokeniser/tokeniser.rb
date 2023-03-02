# frozen_string_literal: true

require 'compactdata/tokeniser/context'

module CompactData
  # A CompactData Tokeniser module
  module Tokeniser
    # A class to represent CompactData tokens
    class Token
      attr_reader :type, :value, :from, :to

      def initialize(type, value, from, to)
        @type = type
        @value = value
        @from = from
        @to = to
      end

      def to_s
        "type: #{@type}, from: #{@from}, to: #{@to}, value: \"#{@value}\""
      end
    end

    def self.tokenise(str)
      Context.new(str).parse
    end
  end
end
