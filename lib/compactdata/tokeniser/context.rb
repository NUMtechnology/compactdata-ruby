# frozen_string_literal: true

module CompactData
  module Tokeniser
    # A parsing context for a CompactData String
    class Context
      WS = " \t\r\n"
      INTEGER_REGEX = '^-?(?:0|[1-9]\d*)$'
      FLOAT_REGEX = '^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?$'
      NON_STRING_TOKENS = '[]();"=`'

      def initialize(str)
        @str = str
        @tokens = []
        @tok_start = 0
      end

      def parse
        while next_token
        end
        @tokens
      end

      def next_token
        while @tok_start < @str.length
          break unless WS.include?(@str[@tok_start])

          @tok_start += 1
        end

        return false if @tok_start >= @str.length

        case @str[@tok_start]
        when '('
          tok_type = :lparen
          tok_end = @tok_start + 1
        when ')'
          tok_type = :rparen
          tok_end = @tok_start + 1
        when '['
          tok_type = :lbracket
          tok_end = @tok_start + 1
        when ']'
          tok_type = :rbracket
          tok_end = @tok_start + 1
        when ';'
          tok_type = :struct_sep
          tok_end = @tok_start + 1
        when '='
          tok_type = :equals
          tok_end = @tok_start + 1
        when '"'
          tok_type = :quoted
          tok_end = scan_to_end_of_quoted(@str, @tok_start, '"')
        when '`'
          tok_type = :quoted
          tok_end = scan_to_end_of_quoted(@str, @tok_start, '`')
        else
          tok_type = :string
          tok_end = scan_to_end_of_string(@str, @tok_start)
        end

        tok_value = @str[@tok_start..(tok_end - 1)].strip

        if tok_value.match? INTEGER_REGEX
          number = tok_value.to_i
          @tokens.push Token.new(:integer, number, @tok_start, tok_end)
        elsif tok_value.match? FLOAT_REGEX
          number = tok_value.to_f
          @tokens.push Token.new(:float, number, @tok_start, tok_end)
        elsif tok_value == 'null'
          @tokens.push Token.new(:null, nil, @tok_start, tok_end)
        elsif tok_value == 'true'
          @tokens.push Token.new(true, true, @tok_start, tok_end)
        elsif tok_value == 'false'
          @tokens.push Token.new(false, false, @tok_start, tok_end)
        else
          @tokens.push Token.new(tok_type, tok_value, @tok_start, tok_end)
        end

        @tok_start = tok_end
        tok_end < @str.length
      end

      def scan_to_end_of_quoted(str, start, quote_char)
        end_str = start + 1
        while end_str < str.length
          end_char = str[end_str]
          prev_char = str[end_str - 1]

          break if end_char == quote_char && prev_char != '\\' && prev_char != '~'

          end_str += 1
        end
        end_str + 1
      end

      def scan_to_end_of_string(str, start)
        end_str = start + 1
        while end_str < str.length
          break if NON_STRING_TOKENS.include?(str[end_str]) && !escaped?(str, end_str - 1)

          end_str += 1
        end
        end_str
      end

      def escaped?(str, pos)
        pos >= 0 && (str[pos] == '~' || str[pos] == '\\')
      end
    end
  end
end
