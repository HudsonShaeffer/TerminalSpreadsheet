module Model

    # Simple wrapper for UninitializedCellError, no special functions
    class UninitializedCellError < StandardError; end

    # NewInteger: Primitive Type
    # stores a value intended to be used as a integer
    # returns a NewInteger when evaluated
    class NewInteger
        attr_reader :value, :start_index, :end_index

        def initialize(value, start_index, end_index)
            @value = value
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            self
        end

        def to_s
            "#{@value} #{@start_index}-#{@end_index}"
        end
    end

    # NewFloat: Primitive Type
    # stores a value intended to be used as a float
    # returns a NewFloat when evaluated
    class NewFloat
        attr_reader :value, :start_index, :end_index

        def initialize(value, start_index, end_index)
            @value = value
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            self
        end

        def to_s
            "#{@value} #{@start_index}-#{@end_index}"
        end
    end

    # NewBoolean: Primitive Type
    # stores a value intended to be used as a boolean
    # returns a NewBoolean when evaluated
    class NewBoolean
        attr_reader :value, :start_index, :end_index

        def initialize(value, start_index, end_index)
            @value = value
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            self
        end

        def to_s
            "#{@value} #{@start_index}-#{@end_index}"
        end
    end

    # NewString: Primitive Type
    # stores a value intended to be used as a string
    # returns a NewString when evaluated
    class NewString
        attr_reader :value, :start_index, :end_index

        def initialize(value, start_index, end_index)
            @value = value
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            self
        end

        def to_s
            "#{@value} #{@start_index}-#{@end_index}"
        end 
    end

    # helper method, will return an address obj in the correct format.
    def create_address(x, y)
        [x,y]
    end

    # Lvalue: Cell Reference
    # works on an address and stores a value intended to be used as a cell address
    # returns the address of the cell
    class Lvalue
        attr_reader :address, :start_index, :end_index

        def initialize(address, start_index, end_index)
            @address = address
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            @address
        end

        def to_s
            "$[#{@address[0]}, #{@address[1]}] #{@start_index}-#{@end_index}"
        end
    end

    # Rvalue: Cell Reference
    # works on an address and stores the cell address as well as the evaluated contents of the cell
    # returns the value contained within the cell at address
    class Rvalue
        attr_reader :address, :start_index, :end_index

        def initialize(address, start_index, end_index)
            @address = address
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            expression = environment.evaluate(@address)
            if expression == nil
                raise UninitializedCellError.new("Rvalue: Attempted to retrieve an uninitialized cell")
            end
            return expression.evaluate(@address)
        end

        def to_s
            "[#{@address[0]}, #{@address[1]}] #{@start_index}-#{@end_index}"
        end
    end

    # Add: Arithmetic Operation
    # works on a left and right operand
    # returns a NewFloat or NewInteger depending on operand type
    class Add
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type float
            if left_primitive.is_a?(NewFloat) && right_primitive.is_a?(NewFloat)
                return NewFloat.new(left_primitive.value + right_primitive.value)
            # validate type integer
            elsif left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value + right_primitive.value)
            end 
            raise TypeError.new("Add: Failed to evaluate expression")
        end

        def to_s
            "(#{@left} + #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Subtract: Arithmetic Operation
    # works on a left and right operand
    # returns a NewFloat or NewInteger depending on operand type
    class Subtract
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type float
            if left_primitive.is_a?(NewFloat) && right_primitive.is_a?(NewFloat)
                return NewFloat.new(left_primitive.value - right_primitive.value)
            # validate type integer
            elsif left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value - right_primitive.value)
            end 
            raise TypeError.new("Subtract: Failed to evaluate expression")
        end

        def to_s
            "(#{@left} - #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Divide: Arithmetic Operation
    # works on a left and right operand
    # returns a NewFloat or NewInteger depending on operand type
    class Divide
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type float
            if left_primitive.is_a?(NewFloat) && right_primitive.is_a?(NewFloat)
                return NewFloat.new(left_primitive.value / right_primitive.value)
            # validate type integer
            elsif left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value / right_primitive.value)
            end 
            raise TypeError.new("Divide: Failed to evaluate expression")
        end

        def to_s
            "(#{@left} / #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Multiply: Arithmetic Operation
    # works on a left and right operand
    # returns a NewFloat or NewInteger depending on operand type
    class Multiply
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type float
            if left_primitive.is_a?(NewFloat) && right_primitive.is_a?(NewFloat)
                return NewFloat.new(left_primitive.value * right_primitive.value)
            # validate type integer
            elsif left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value * right_primitive.value)
            end 
            raise TypeError.new("Multiply: Failed to evaluate expression")
        end

        def to_s
            "(#{@left} * #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Modulo: Arithmetic Operation
    # works on a left and right operand
    # returns a NewFloat or NewInteger depending on operand type
    class Modulo
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type float
            if left_primitive.is_a?(NewFloat) && right_primitive.is_a?(NewFloat)
                return NewFloat.new(left_primitive.value % right_primitive.value)
            # validate type integer
            elsif left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value % right_primitive.value)
            end 
            raise TypeError.new("Modulo: Failed to evaluate expression")
        end

        def to_s
            "(#{@left} % #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # And: Logical Operation
    # works on a left and right operand
    # returns a NewBoolean
    class And
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            if left_primitive.value == false
                return NewBoolean(false)
            end
            right_primitive = @right.evaluate(environment)
            # validate type
            if left_primitive.is_a?(NewBoolean) && right_primitive.is_a?(NewBoolean)
                return NewBoolean.new(left_primitive.value && right_primitive.value)
            end 
            raise TypeError.new("And: Failed to evaluate boolean expression")
        end

        def to_s
            "(#{@left} && #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Or: Logical Operation
    # works on a left and right operand
    # returns a NewBoolean
    class Or
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            if left_primitive.value == true
                return NewBoolean(true)
            end
            right_primitive = @right.evaluate(environment)
            # validate type
            if left_primitive.is_a?(NewBoolean) && right_primitive.is_a?(NewBoolean)
                return NewBoolean.new(left_primitive.value || right_primitive.value)
            end
            raise TypeError.new("Or: Failed to evaluate boolean expression")
        end

        def to_s
            "(#{@left} || #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # Not: Logical Operation
    # works on a unary operand
    # returns a NewBoolean
    class Not
        attr_reader :operand, :start_index, :end_index

        def initialize(operand, start_index, end_index)
            @operand = operand
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evalute operand into primitive
            primitive = @operand.evaluate(environment)
            # validate type
            if primitive.is_a?(NewBoolean)
                return NewBoolean.new(!primitive.value)
            end
            raise TypeError.new("Not: Failed to evaluate boolean expression")
        end

        def to_s
            "(!#{@operand}) #{@start_index}-#{@end_index}"
        end
    end

    # Equal: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class Equals
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            return NewBoolean.new(left_primitive.value == right_primitive.value)
        end

        def to_s
            "(#{@left} == #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # NotEqual: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class NotEquals
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            return NewBoolean.new(left_primitive.value != right_primitive.value)
        end

        def to_s
            "(#{@left} != #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # LessThan: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class LessThan
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            if !(left_primitive.is_a?(NewBoolean) && left_primitive.is_a?(NewBoolean))
                return NewBoolean.new(left_primitive.value < right_primitive.value)
            end
            raise TypeError.new("Not: Failed to evaluate comparasion")
        end

        def to_s
            "(#{@left} < #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # LessThanEqual: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class LessThanEqual
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            if !(left_primitive.is_a?(NewBoolean) && left_primitive.is_a?(NewBoolean))
                return NewBoolean.new(left_primitive.value <= right_primitive.value)
            end
            raise TypeError.new("Not: Failed to evaluate comparasion")
        end

        def to_s
            "(#{@left} <= #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # GreaterThan: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class GreaterThan
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            if !(left_primitive.is_a?(NewBoolean) && left_primitive.is_a?(NewBoolean))
                return NewBoolean.new(left_primitive.value > right_primitive.value)
            end
            raise TypeError.new("Not: Failed to evaluate comparasion")
        end

        def to_s
            "(#{@left} > #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # GreaterThanEqual: Relational Operation
    # works on a left and right operand
    # returns a NewBoolean
    class GreaterThanEqual
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            if !(left_primitive.is_a?(NewBoolean) && left_primitive.is_a?(NewBoolean))
                return NewBoolean.new(left_primitive.value >= right_primitive.value)
            end
            raise TypeError.new("Not: Failed to evaluate comparasion")
        end

        def to_s
            "(#{@left} >= #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseAnd: Bitwise Operation
    # works on a left and right operand
    # returns a NewInteger
    class BitwiseAnd
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type
            if left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value & right_primitive.value)
            end 
            raise TypeError.new("BitwiseAnd: Failed to evaluate bAnd")
        end

        def to_s
            "(#{@left} & #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseOr: Bitwise Operation
    # works on a left and right operand
    # returns a NewInteger
    class BitwiseOr
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type
            if left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value | right_primitive.value)
            end 
            raise TypeError.new("BitwiseOr: Failed to evaluate bOr")
        end

        def to_s
            "(#{@left} | #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseXor: Bitwise Operation
    # works on a left and right operand
    # returns a NewInteger
    class BitwiseXor
        attr_reader :left, :right, :start_index, :end_index

        def initialize(left, right, start_index, end_index)
            @left = left
            @right = right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaulate left and right into primitives
            left_primitive = @left.evaluate(environment)
            right_primitive = @right.evaluate(environment)
            # validate type
            if left_primitive.is_a?(NewInteger) && right_primitive.is_a?(NewInteger)
                return NewInteger.new(left_primitive.value ^ right_primitive.value)
            end 
            raise TypeError.new("BitwiseXor: Failed to evaluate bXor")
        end

        def to_s
            "(#{@left} ^ #{@right}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseNot: Bitwise Operation
    # works on a unary operand
    # returns a NewInteger
    class BitwiseNot
        attr_reader :operand, :start_index, :end_index

        def initialize(operand, start_index, end_index)
            @operand = operand
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaluate the operand into a primitive
            primitive = @operand.evaluate(environment)
            # validate type
            if primitive.is_a?(NewInteger)
                return NewInteger.new(~primitive.value)
            end 
            raise TypeError.new("BitwiseNot: Failed to evaluate bNot")
        end

        def to_s
            "(~#{@operand}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseLeftShift: Bitwise Operation
    # works on bits and a shift
    # returns a NewInteger 
    class BitwiseLeftShift
        attr_reader :bits, :shift, :start_index, :end_index

        def initialize(bits, shift, start_index, end_index)
            @bits = bits
            @shift = shift
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaluate the bits and shift into primitive types
            bits_primitive = @bits.evaluate(environment)
            shift_primitive = @shift.evaluate(environment)
            #  validate type
            if bits_primitive.is_a?(NewInteger) && shift_primitive.is_a?(NewInteger)
                return NewInteger.new(bits_primitive.value << shift_primitive.value)
            end 
            raise TypeError.new("BitwiseLeftShift: Failed to evaluate bit shift")
        end

        def to_s
            "(#{@bits} << #{shift}) #{@start_index}-#{@end_index}"
        end
    end

    # BitwiseRightShift: Bitwise Operation
    # works on bits and a shift
    # returns a NewInteger 
    class BitwiseRightShift
        attr_reader :bits, :shift, :start_index, :end_index

        def initialize(bits, shift, start_index, end_index)
            @bits = bits
            @shift = shift
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate (environment)
            # evaluate the bits and shift into primitive types
            bits_primitive = @bits.evaluate(environment)
            shift_primitive = @shift.evaluate(environment)
            #  validate type
            if bits_primitive.is_a?(NewInteger) && shift_primitive.is_a?(NewInteger)
                return NewInteger.new(bits_primitive.value >> shift_primitive.value)
            end 
            raise TypeError.new("BitwiseRightShift: Failed to evaluate bit shift")
        end

        def to_s
            "(#{@bits} >> #{shift}) #{@start_index}-#{@end_index}"
        end
    end

    # FloatToInt: Casting Operator
    # works on any expression that evaluates to a float
    # returns a NewInteger primitive type of equivalent value
    class FloatToInt
        attr_reader :expression, :start_index, :end_index

        def initialize(expression, start_index, end_index)
            @expression = expression
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            # evaluate the expression into a primitive
            primitive = @expression.evaluate(environment)
            # validate primitive's type
            if primitive.is_a?(NewFloat)
                return NewInteger.new(primitive.value.round)
            end 
            raise TypeError.new("FloatToInt: Failed to evaluate cast")
        end

        def to_s
            "(int #{@expression}) #{@start_index}-#{@end_index}"
        end
    end

    # IntToFloat: Casting Operator
    # works on any expression that evaluates to an int
    # returns a NewFloat primitive type of equivalent value
    class IntToFloat
        attr_reader :expression, :start_index, :end_index

        def initialize(expression, start_index, end_index)
            @expression = expression
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            # evaluate the expression into a primitive
            primitive = @expression.evaluate(environment)
            # validate primitive's type
            if primitive.is_a?(NewInteger)
                return NewFloat.new(primitive.value.to_f)
            end 
            raise TypeError.new("IntToFloat: Failed to evaluate cast")
        end

        def to_s
            "(float #{@expression}) #{@start_index}-#{@end_index}"
        end
    end

    # Max: Statistical Function
    # works on a top_left and bottom_right coordinate set of Lvalues
    # returns the max integer or float value found within the cell set
    # !!IMPORTANT!! always returns a float
    class Max
        attr_reader :top_left, :bottom_right, :start_index, :end_index

        def initialize(top_left, bottom_right, start_index, end_index)
            @top_left = top_left
            @bottom_right = bottom_right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            if top_left.is_a?(Lvalue) && bottom_right.is_a?(Lvalue) # validate address type
                if top_left.address[0] <= bottom_right.address[0] && top_left.address[1] <= bottom_right.address[1]

                    # assign variables for readability
                    min_x_coord = top_left.address[0]
                    min_y_coord = top_left.address[1]
                    max_x_coord = bottom_right.address[0]
                    max_y_coord = bottom_right.address[1]
                    max = Float::MIN

                    # iterate through each column by x index
                    for x in min_x_coord..max_x_coord do
                        # iterate through each row of each column by y index
                        for y in min_y_coord..max_y_coord do
                            # get evaluated cell contents from environment
                            primitive = environment.evaluate(create_address(x,y))
                            # check if this cell is filled 
                            if primitive == nil
                                raise UninitializedCellError.new("Max: Came across an uninitialized cell.")
                            end
                            # verify that primitive is a valid type & if the new value is the new min
                            if (primitive.is_a?(NewInteger) || primitive.is_a?(NewFloat)) && max < primitive.value
                                max = primitive.value
                            end
                        end
                    end
                    return NewFloat.new(max)
                end
                raise IndexError.new("Max: Failed to evaluate cell range.")
            end
            raise TypeError.new("Max: Failed to evaluate cell range.")
        end

        def to_s
            "max(#{top_left}, #{bottom_right}) #{@start_index}-#{@end_index}"
        end
    end

    # Min: Statistical Function
    # works on a top_left and bottom_right coordinate set of Lvalues
    # returns the min integer or float value found within the cell set
    # !!IMPORTANT!! always returns a float
    class Min
        attr_reader :top_left, :bottom_right, :start_index, :end_index

        def initialize(top_left, bottom_right, start_index, end_index)
            @top_left = top_left
            @bottom_right = bottom_right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            if top_left.is_a?(Lvalue) && bottom_right.is_a?(Lvalue) # validate address type
                if top_left.address[0] <= bottom_right.address[0] && top_left.address[1] <= bottom_right.address[1] 

                    # assign variables for readability
                    min_x_coord = top_left.address[0]
                    min_y_coord = top_left.address[1]
                    max_x_coord = bottom_right.address[0]
                    max_y_coord = bottom_right.address[1]
                    min = Float::MAX

                    # iterate through each column by x index
                    for x in min_x_coord..max_x_coord do
                        # iterate through each row of each column by y index
                        for y in min_y_coord..max_y_coord do
                            # get evaluated cell contents from environment
                            primitive = environment.evaluate(create_address(x,y))
                            # check if this cell is filled
                            if primitive == nil
                                raise UninitializedCellError.new("Max: Came across an uninitialized cell.")
                            end
                            # verify that primitive is a valid type & if the new value is the new min
                            if (primitive.is_a?(NewInteger) || primitive.is_a?(NewFloat)) && primitive.value < min
                                min = primitive.value
                            end
                        end
                    end
                    return NewFloat.new(min)
                end
                raise IndexError.new("Min: Failed to evaluate cell range.")
            end
            raise TypeError.new("Min: Failed to evaluate cell range.")
        end

        def to_s
            "min(#{top_left}, #{bottom_right}) #{@start_index}-#{@end_index}"
        end
    end

    # Mean: Statistical Function
    # works on a top_left and bottom_right coordinate set
    # returns the mean value of all integer and float values found within the cell set
    # !!IMPORTANT!! always returns a float
    class Mean
        attr_reader :top_left, :bottom_right, :start_index, :end_index

        def initialize(top_left, bottom_right, start_index, end_index)
            @top_left = top_left
            @bottom_right = bottom_right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            if top_left.is_a?(Lvalue) && bottom_right.is_a?(Lvalue) # validate address type
                if top_left.address[0] <= bottom_right.address[0] && top_left.address[1] <= bottom_right.address[1] 

                    # assign variables for readability
                    min_x_coord = top_left.address[0]
                    min_y_coord = top_left.address[1]
                    max_x_coord = bottom_right.address[0]
                    max_y_coord = bottom_right.address[1]
                    mean = sum = count = 0

                    # iterate through each column by x index
                    for x in min_x_coord..max_x_coord do
                        # iterate through each row of each column by y index
                        for y in min_y_coord..max_y_coord do
                            # get evaluated cell contents from environment
                            primitive = environment.evaluate(create_address(x,y))
                            # check if this cell is filled
                            if primitive == nil
                                raise UninitializedCellError.new("Max: Came across an uninitialized cell.")
                            end
                            # verify that primitive is a valid type
                            if (primitive.is_a?(NewInteger) || primitive.is_a?(NewFloat))
                                sum += primitive.value
                                count += 1
                            end
                        end
                    end
                    mean = sum / count
                    return NewFloat.new(mean)
                end
                raise IndexError.new("Mean: Failed to evaluate cell range.")
            end 
            raise TypeError.new("Mean: Failed to evaluate cell range.")
        end

        def to_s
            "mean(#{top_left}, #{bottom_right}) #{@start_index}-#{@end_index}"
        end
    end

    # Sum: Statistical Function
    # works on a top_left and bottom_right coordinate set
    # returns the sum of all integer and float values found within the cell set
    # !!IMPORTANT!! always returns a float
    class Sum
        attr_reader :top_left, :bottom_right, :start_index, :end_index

        def initialize(top_left, bottom_right, start_index, end_index)
            @top_left = top_left
            @bottom_right = bottom_right
            @start_index = start_index
            @end_index = end_index
        end

        def evaluate(environment)
            if top_left.is_a?(Lvalue) && bottom_right.is_a?(Lvalue) # validate address type
                if top_left.address[0] <= bottom_right.address[0] && top_left.address[1] <= bottom_right.address[1]

                    # assign variables for readability
                    min_x_coord = top_left.address[0]
                    min_y_coord = top_left.address[1]
                    max_x_coord = bottom_right.address[0]
                    max_y_coord = bottom_right.address[1]
                    sum = 0

                    # iterate through each column by x index
                    for x in min_x_coord..max_x_coord do
                        # iterate through each row of each column by y index
                        for y in min_y_coord..max_y_coord do
                            # get evaluated cell contents from environment
                            primitive = environment.evaluate(create_address(x,y))
                            # check if this cell is filled
                            if primitive == nil
                                raise UninitializedCellError.new("Max: Came across an uninitialized cell.")
                            end
                            # verify that primitive is a valid type
                            if (primitive.is_a?(NewInteger) || primitive.is_a?(NewFloat))
                                sum += primitive.value
                            end
                        end
                    end
                    # return sum
                    return NewFloat.new(sum)
                end
                raise IndexError.new("Sum: Failed to evaluate cell range.")
            end
            raise TypeError.new("Sum: Failed to evaluate cell range.")
        end

        def to_s
            "sum(#{top_left}, #{bottom_right}) #{@start_index}-#{@end_index}"
        end
    end

    # Environment: Abstraction
    # holds a reference to the grid
    # evaluate works on an address (in address format, if invalid format the hash will
    #       return a nil value so no additional typechecking is in place) 
    #       and returns the evaluated cell contents at that location
    # evaluate returns a NewBoolean, NewFloat, NewInteger, NewString, or nil if the cell is empty
    class Environment
        def initialize(gridRef)
            @gridRef = gridRef
        end

        def evaluate(address)
            expression = @gridRef.retrieve(address)
            if expression != nil
                primitive = expression.evaluate(self)
                return primitive
            end
            # if retrieve returns nil then pass it along
            return nil
        end
    end

    # Grid: Abstraction
    # holds a reference to the hashmap that represents the grid values
    # addresses cannot have negative coordinates; the plane begins in the top left 
    #       and extends positively to the bottom right
    # place accepts an address in the form of [x, y] and any expression or primitive to be evaluated 
    #       and places it into the hashmap representation of the grid (no return value)
    # retrieve works on an address in the form of [x, y] and return the expression to be evaluated
    class Grid
        def initialize()
            @cells = {}
        end
        
        def place(address, expression)
            @cells[address] = expression
        end

        def retrieve(address)
            @cells[address]
        end
    end
end