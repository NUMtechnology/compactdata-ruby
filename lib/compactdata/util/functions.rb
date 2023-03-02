# frozen_string_literal: true

module CompactData
  # Helper functions for CompactData.generate
  module UTIL
    SHOULD_BE_GRAVE_QUOTED = /.*[()\[\];{}="].*/.freeze
    IS_NUMERIC = /^-?[0-9]*\.?[0-9]+(?:[Ee][+-]?[0-9]+)?$/.freeze

    def self.escape_graves(str)
      return str unless str

      str.gsub(/`/, '~`')
    end

    def self.escape_double_quotes(str)
      return str unless str

      i = str.index('"', 1) # ignore the initial quote
      result = str
      # Don't affect the final quote in the string
      while !i.nil? && i < (result.length - 1)
        result = result.slice(0..(i - 1)) + '~u0022' + result.slice((i + 1)..)
        i = result.index('"', 1)
      end
      result
    end

    def self.grave_quote_if_necessary(str)
      return str unless str

      if str.match?(SHOULD_BE_GRAVE_QUOTED) ||
         (str.match?(IS_NUMERIC) && str != '00' && str != '01' && str != '000') ||
         (str.strip.empty? ||
          str.match?(IS_NUMERIC) ||
          str == 'true' ||
          str == 'false' ||
          str == 'null')
        "`#{str}`"
      else
        str
      end
    end

    def self.double_quote_if_necessary(str)
      if str && str.include?('~`')
        "\"#{str}\""
      else
        str
      end
    end

    def self.replace_nbsp(str)
      str.gsub('\u00a0', ' ')
    end

    def self.escape_and_quote(str)
      double_quote_if_necessary(
        grave_quote_if_necessary(
          escape_graves(
            UNICODE.escape(
              replace_nbsp(
                escape_double_quotes(str)
              )
            )
          )
        )
      )
    end

    def self.non_string_primitive?(str)
      str == 'true' || str == 'false' || str == 'null' || str.match?(IS_NUMERIC)
    end
  end
end
