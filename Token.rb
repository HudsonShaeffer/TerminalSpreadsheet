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
# ----------- Possible Token Types as Follows: -----------
#    Keywords    x|     Delimiters     x|   Primitives  x|
# :float_int_cast | :open_bracket       | :integer       |
# :int_float_cast | :close_bracket      | :float         |
# :max            | :open_parenthesis   | :boolean       |
# :min            | :close_parenthesis  | :string        |
# :mean           | :ampersand          |================|
# :sum            | :comma              |    Invalid    x|
#=================|=====================| :invalid_token |
#    Bitwise     x|      Logical       x|================|
# :bitwise_and    | :logical_and        |   Arithmetic  x|
# :bitwise_or     | :logical_or         | :add           |
# :bitwise_xor    | :logical_not        | :subtract      |
# :bitwise_not    |=====================| :multiply      |
# :bitshift_left  |     Relational     x| :divide        |
# :bitshift_right | :equals             | :modulo        |
#=================| :not_equals         |================|
#=================| :less_than          |================|
#=================| :less_than_equal    |================|
#=================| :greater_than       |================|
#=================| :greater_than_equal |================|
#=================|=====================|================|