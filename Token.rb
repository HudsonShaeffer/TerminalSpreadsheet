module Tokens
    class Token
        attr_reader :type, :source, :start_index, :end_index
        def initialize(type, source, start_index, end_index)
            @type = type
            @source = source
            @start_index = start_index
            @end_index = end_index
        end

        def equals?(other)
            @type == other.type && @source == other.source && @start_index == other.start_index && @end_index == end_index
        end

        def to_s
            puts "Token Type: #{type}. Source: #{source}. [#{start_index} to #{end_index}]\n"
        end
    end
end
# --------- Possible Token Types as Follows: ---------
#    Keywords     |     Delimiters      |   Primitives   |
# :true           | :open_bracket       | :integer       |
# :false          | :close_bracket      | :float         |
# :max            | :open_parenthesis   | :boolean       |
# :min            | :close_parenthesis  | :string        |
# :mean           | :ampersand          |================|
# :sum            | :comma              |    Invalid     |
# :float_int_cast |=====================| :invalid_token |
# :int_float_cast |      Logical        |================|
#=================| :logical_and        |   Arithmetic   |
#    Bitwise      | :logical_or         | :add           |
# :bitwise_and    | :logical_not        | :subtract      |
# :bitwise_or     |=====================| :multiply      |
# :bitwise_xor    |     Relational      | :divide        |
# :bitwise_not    | :equals             | :modulo        |
# :bitshift_left  | :not_equals         |================|
# :bitshift_right | :less_than          |
#=================| :less_than_equal    |
#                 | :greater_than       |
#                 | :greater_than_equal |
#                 |=====================|