# frozen_string_literal: false

module CompactData
  # Handle escaping of unicode characters.
  module UNICODE
    VERTICAL_TAB = 0x0b
    BACKSPACE = 0x08
    FORMFEED = 0x0c
    LINEFEED = 0x0a
    CARRIAGE_RETURN = 0x0d
    TAB = 0x09

    def self.escape_char(chr)
      return '' unless chr

      if chr >= 32 && chr <= 127
        '' << chr
      elsif chr == VERTICAL_TAB
        '~u000B'
      elsif chr == BACKSPACE
        '\\b'
      elsif chr == FORMFEED
        '\\f'
      elsif chr == LINEFEED
        '\\n'
      elsif chr == CARRIAGE_RETURN
        '\\r'
      elsif chr == TAB
        '\\t'
      else
        '' << chr
      end
    end

    def self.escape(str)
      result = ''

      str.each_codepoint do |c|
        result << escape_char(c)
      end
      result
    end
  end
end
