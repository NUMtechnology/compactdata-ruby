# frozen_string_literal: true
require 'pry'

module CompactData
  # A Parser module
  module Parser
    REPLACEMENTS = {
      '\t' => "\t",
      '\n' => "\n",
      '\b' => "\b",
      '\f' => "\f",
      '\r' => "\r",
      '~t' => "\t",
      '~n' => "\n",
      '~b' => "\b",
      '~f' => "\f",
      '~r' => "\r",
      '~\\' => '\\',
      '\\\\' => '\\',
      '~~' => '~',
      '\~' => '~',
      '~(' => '(',
      '\(' => '(',
      '~)' => ')',
      '\)' => ')',
      '~[' => '[',
      '\[' => '[',
      '~]' => ']',
      '\]' => ']',
      '~;' => ';',
      '\;' => ';',
      '~`' => '`',
      '\`' => '`',
      '~"' => '"',
      '"' => '"',
      '~=' => '=',
      '\=' => '='
    }.freeze

    def self.parse_compactdata(str)
      tokens = CompactData::Tokeniser.tokenise str
      if tokens.nil? || tokens.empty?
        CompactData::Model::CompactData.new nil
      elsif root_primitive? tokens[0]
        CompactData::Model::CompactData.new tokens[0].value
      else
        result = parse_structures(tokens)
        return CompactData::Model::CompactData.new result[0] if result.length == 1

        return CompactData::Model::CompactData.new CompactData::Model::CompactDataMap.new(result) if all_pairs?(result)

        CompactData::Model::CompactData.new CompactData::Model::CompactDataArray.new(result)
      end
    end

    def self.root_primitive?(token)
      %i[string quoted null true false integer float].include?(token)
    end

    def self.parse_structures(tokens)
      result = []
      until tokens.empty?
        result.push parse_compactdata_value(tokens)
        expect_separator = tokens.shift
        if !expect_separator.nil? && expect_separator.type != :struct_sep
          raise ParserError, "Expected ';' near #{tokens}"
        end
      end
      result
    end

    def self.parse_compactdata_value(tokens)
      first_token = tokens.shift

      case first_token.type
      when :lbracket
        tokens.unshift first_token
        return parse_compactdata_array tokens
      when :lparen
        tokens.unshift first_token
        return parse_compactdata_map tokens
      when :string, :quoted
        peek = tokens[0]
        key = first_token.value
        if !peek.nil? && peek.type == :equals
          tokens.shift
          return CompactData::Model::CompactDataPair.new replace_escapes(unquote(key)), parse_pair_value(tokens)
        end

        if !peek.nil? && (peek.type == :lbracket || peek.type == :lparen)
          return CompactData::Model::CompactDataPair.new replace_escapes(unquote(key)), parse_pair_value(tokens)
        end

        if peek.nil? || peek.type == :struct_sep || peek.type == :rparen || peek.type == :rbracket
          return CompactData::Model::CompactDataString.new(replace_escapes(first_token.value)) if first_token.type == :string 

          return CompactData::Model::CompactDataQuoted.new(replace_escapes(unquote(first_token.value)))
        end
      when :integer
        return CompactData::Model::CompactDataInteger.new first_token.value
      when :float
        return CompactData::Model::CompactDataFloat.new first_token.value
      when :null
        return CompactData::Model::CompactDataBoolNull::CompactData_NULL
      when true
        return CompactData::Model::CompactDataBoolNull::CompactData_TRUE
      when false
        return CompactData::Model::CompactDataBoolNull::CompactData_FALSE
      else
        tokens.unshift first_token
        maybe_primitive = parse_primitive tokens
        return maybe_primitive unless maybe_primitive.nil?
      end
      raise ParserError, "Unexpected token: \'#{first_token}\'"
    end

    def self.parse_pair_value(tokens)
      first_token = tokens.shift
      case first_token.type
      when :lbracket
        tokens.unshift first_token
        return parse_compactdata_array tokens
      when :lparen
        tokens.unshift first_token
        return parse_compactdata_map tokens
      when :string, :quoted
        peek = tokens[0]

        raise ParserError, "Unexpected token: \'#{first_token}\'" if !peek.nil? && peek.type == :equals

        if !peek.nil? && (peek.type == :lbracket || peek.type == :lparen)
          raise ParserError, "Unexpected token: \'#{first_token}\'"
        end

        if peek.nil? || peek.type == :struct_sep || peek.type == :rparen || peek.type == :rbracket
          return CompactData::Model::CompactDataString.new replace_escapes(first_token.value) if first_token.type == :string

          return CompactData::Model::CompactDataQuoted.new replace_escapes(unquote(first_token.value))
        end
        raise ParserError, "Unexpected token: \'#{first_token}\'"
      when :integer
        return CompactData::Model::CompactDataInteger.new first_token.value
      when :float
        return CompactData::Model::CompactDataFloat.new first_token.value
      when :null
        return CompactData::Model::CompactDataBoolNull::CompactData_NULL
      when true
        return CompactData::Model::CompactDataBoolNull::CompactData_TRUE
      when false
        return CompactData::Model::CompactDataBoolNull::CompactData_FALSE
      else
        tokens.unshift first_token
        maybe_primitive = parse_primitive tokens
        return maybe_primitive unless maybe_primitive.nil?
      end
      raise ParserError, "Unexpected token: \'#{first_token}\'"
    end

    def self.parse_primitive(tokens)
      result = nil
      tok = tokens.shift

      case tok.type
      when :lparen, :rparen, :lbracket, :rbracket, :equals
        raise ParserError, "Unexpected token: \'#{tok}\'" if tokens.empty?

        tokens.unshift tok
        return nil
      when :null
        result = CompactData::Model::CompactDataBoolNull::CompactData_NULL
      when true
        result = CompactData::Model::CompactDataBoolNull::CompactData_TRUE
      when false
        result = CompactData::Model::CompactDataBoolNull::CompactData_FALSE
      when :quoted
        result = CompactData::Model::CompactDataQuoted.new replace_escapes(unquote(tok.value))
      when :string
        result = CompactData::Model::CompactDataString.new replace_escapes(tok.value)
      when :integer
        result = CompactData::Model::CompactDataInteger.new tok.value
      when :float
        result = CompactData::Model::CompactDataFloat.new tok.value
      else
        raise ParserError, "Unknown token type in: \'#{tok}\'"
      end

      peek = tokens[0]
      raise ParserError, 'Only one primitive allowed at the root.' if !peek.nil? && peek.type == :struct_sep

      if !peek.nil? && (peek.type == :lparen || peek.type == :lbracket || peek.type == :equals)
        s.unshift tok
        return nil
      elsif !peek.nil?
        raise ParserError, "Unexpected token: \'#{peek}\'"
      end
      result
    end

    def self.parse_compactdata_map(tokens)
      first_token = tokens.shift
      entries = []

      until tokens.empty?
        peek = tokens[0]
        if !peek.nil? && peek.type == :rparen
          tokens.shift
          break
        end

        mp = parse_compactdata_value tokens
        entries.push mp

        peek = tokens[0]

        raise ParserError, "Expected ')' near #{first_token}" if peek.nil?

        case peek.type
        when :rparen
          tokens.shift
          break
        when :struct_sep
          tokens.shift
          peek = tokens[0]
          raise ParserError, "Unexpected ; before ] at #{peek}" if !peek.nil? && peek.type == :rparen
        end
      end
      CompactData::Model::CompactDataMap.new entries
    end

    def self.parse_compactdata_array(tokens)
      first_token = tokens.shift
      entries = []

      until tokens.empty?
        peek = tokens[0]
        if !peek.nil? && peek.type == :rbracket
          tokens.shift
          break
        end

        mp = parse_compactdata_value tokens
        entries.push mp

        peek = tokens[0]

        raise ParserError, "Expected ']' near #{first_token}" if peek.nil?

        case peek.type
        when :rbracket
          tokens.shift
          break
        when :struct_sep
          tokens.shift
          peek = tokens[0]
          raise ParserError, "Unexpected ; before ] at #{peek}" if !peek.nil? && peek.type == :rparen
        end
      end
      CompactData::Model::CompactDataArray.new entries
    end

    def self.unquote(str)
      return str unless str.instance_of?(String)

      if (str.start_with?('`') && str.end_with?('`')) || (str.start_with?('"') && str.end_with?('"'))
        str[1..-2]
      else
        str
      end
    end

    def self.replace_escapes(str)
      return str unless str.instance_of?(String)

      result = str
      i = 0
      while i < str.length
        REPLACEMENTS.each_pair do |key, value|
          if result.slice(i..).start_with?(key)
            result = result.sub(key, value)
            break
          end
        end
        i += 1
      end
      result
    end

    def self.all_pairs?(arr)
      result = true
      arr.each { |i| result = false unless i.instance_of? CompactData::Model::CompactDataPair }
      result
    end
  end
end
