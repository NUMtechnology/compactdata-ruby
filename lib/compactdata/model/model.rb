# frozen_string_literal: true

module CompactData
  # A Model module for CompactData
  module Model
    # The root of a CompactData object
    class CompactData
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        if @value.instance_of? Array
          @value.map(&:to_s)
        else
          "CompactData: #{@value}"
        end
      end

      def to_j
        @value.nil? ? 'null' : @value.to_j
      end

      def to_m
        if @value.instance_of?(CompactDataMap)
          @value.items.map(&:to_m).join(';')
        else
          @value.to_m
        end
      end
    end

    # A CompactData Array
    class CompactDataArray
      attr_reader :items

      def initialize(items)
        @items = items
      end

      def to_s
        items = @items.map(&:to_s)
        "CompactDataArray: #{items}"
      end

      def to_j
        @items.map(&:to_j)
      end

      def to_m
        list = @items.map(&:to_m).join ';'
        "[#{list}]"
      end
    end

    # A CompactData Map
    class CompactDataMap
      attr_reader :items

      def initialize(items)
        @items = items
      end

      def to_s
        items = @items.map(&:to_s)
        "CompactDataMap: #{items}"
      end

      def to_j
        result = @items.map { |p| [p.key, p.value.to_j] }
        result.to_h
      end

      def to_m
        compactdata = @items.map(&:to_m).join ';'
        "(#{compactdata})"
      end
    end

    # A CompactData Primitive
    class CompactDataPrimitive
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "CompactDataPrimitive: #{@value}"
      end

      def to_m
        @value.to_s
      end
    end

    # A CompactData PAir
    class CompactDataPair
      attr_reader :key, :value

      def initialize(key, value)
        @key = key
        @value = value
      end

      def to_s
        "CompactDataPair: #{key}=#{@value}"
      end

      def to_j
        { @key => @value.to_j }
      end

      def to_m
        key = UTIL.non_string_primitive?(@key) ? "\"#{@key}\"" : @key
        if @value.instance_of?(CompactDataPair)
          "#{key}(#{@value.to_m})"
        elsif @value.instance_of?(CompactDataMap) || @value.instance_of?(CompactDataArray)
          "#{key}#{@value.to_m}"
        else
          "#{key}=#{@value.to_m}"
        end
      end
    end

    # A CompactData FLOAT
    class CompactDataFloat
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "CompactDataFloat: #{@value}"
      end

      def to_j
        @value
      end

      def to_m
        format('%.16G', @value).sub('E+', 'E')
      end
    end

    # A CompactData Integer
    class CompactDataInteger
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "CompactDataInteger: #{@value}"
      end

      def to_j
        @value
      end

      def to_m
        @value.to_s
      end
    end

    # A CompactData String
    class CompactDataString
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "CompactDataString: #{@value}"
      end

      def to_j
        @value
      end

      def to_m
        UTIL.escape_and_quote @value
      end
    end

    # A CompactData Quoted String
    class CompactDataQuoted
      attr_reader :value

      def initialize(value)
        @value = value
      end

      def to_s
        "CompactDataQuoted: #{@value}"
      end

      def to_j
        @value
      end

      def to_m
        UTIL.escape_and_quote @value
      end
    end

    # A CompactData Boolean or NULL
    class CompactDataBoolNull
      def initialize(value)
        @value = value
      end

      CompactData_NULL = CompactDataBoolNull.new nil
      CompactData_TRUE = CompactDataBoolNull.new true
      CompactData_FALSE = CompactDataBoolNull.new false

      def to_s
        "CompactDataBoolNull: #{@value}"
      end

      def to_j
        @value
      end

      def to_m
        @value.nil? ? 'null' : @value
      end
    end

    # Convert a Ruby Hash/Array/Primitive to a CompactData object.
    def self.to_compactdata(obj)
      if obj.instance_of? Float
        CompactDataFloat.new obj
      elsif obj.instance_of? Integer
        CompactDataInteger.new obj
      elsif obj.instance_of? String
        CompactDataString.new obj
      elsif obj.instance_of? Hash
        if obj.keys.length == 1
          key = obj.keys[0]
          CompactDataPair.new key, to_compactdata(obj[key])
        else
          CompactDataMap.new(obj.keys.map { |k| CompactDataPair.new k, to_compactdata(obj[k]) })
        end
      elsif obj.instance_of? Array
        CompactDataArray.new(obj.map { |i| to_compactdata i })
      elsif obj.instance_of? TrueClass
        CompactDataBoolNull::CompactData_TRUE
      elsif obj.instance_of? FalseClass
        CompactDataBoolNull::CompactData_FALSE
      elsif obj.instance_of? NilClass
        CompactDataBoolNull::CompactData_NULL
      else
        puts "Cannot handle #{obj}"
        exit
      end
    end
  end
end
