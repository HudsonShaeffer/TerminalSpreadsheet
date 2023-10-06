module Tokens
    class Token
        attr_reader :type, :source, :start_index, :end_index
        def initialize(type, source, start_index, end_index)
            @type = type
            @source = source
            @start_index = start_index
            @end_index = end_index
        end

        def to_s
            puts "Token Type: #{type}. Source: #{source}. [#{start_index} to #{end_index}]\n"
        end
    end
end
# ---- Possible Token Types as Follows:
#   Primitives    |   Relational          |   Bitwise
# :integer        | :equals               | :bitwise_and
# :float          | :not_equals           | :bitwise_or
# :boolean        | :less_than            | :bitwise_xor
# :string         | :less_than_equal      | :bitwise_not
# :lvalue         | :greater_than         | :bitshift_left
# :rvalue         | :greater_than_equal   | :bitshift_right
#   Arithmetic    | # Statistical         | # Logical
# :add            | :max                  | :logical_and
# :subtract       | :min                  | :logical_or
# :multiply       | :mean                 | :logical_not
# :divide         | :sum                  |
# :modulo         |                       |
#   Casting       | # Invalid             |
# :float_int_cast | :invalid_token        |
# :int_float_cast |                       |