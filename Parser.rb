require_relative "Token.rb"
require_relative "Model.rb"
include Tokens
include Model

module ParserModule
    class Parser
        def initialize()
        end
        # init parser recursion
        def parse(tokens)
            @tokens = tokens
            @i = 0
            logical()
        end

        # expression = logical so logical is first
        def logical
            outbounds?()
            strt = @tokens[@i].start_index  # store start index of these tree nodes
            left = equals() # init left for base case
            while type?(:logical_and) || type?(:logical_or) # loop over all ands or ors
                current_operator = get_type() # remember which operand it entered on and inc to next token
                invalid?()
                right = equals() # grab right
                term = right.end_index # grab right index of the right branch of this tree-node
                if current_operator == :logical_and # check for the stored operand type from type?
                    left = And.new(left, right, strt, term) # AND tree node
                elsif current_operator == :logical_or # check for the stored operand type from type?
                    left = Or.new(left, right, strt, term)  # OR tree node
                end
            end
            invalid?()
            left # return the node
        end

        def equals
            outbounds?()
            strt = @tokens[@i].start_index
            left = relational()
            while type?(:equals) || type?(:not_equals)
                current_operator = get_type()
                invalid?()
                right = relational()
                term = right.end_index
                if current_operator == :equals
                    left = Equals.new(left, right, strt, term)
                elsif current_operator == :not_equals
                    left = NotEquals.new(left, right, strt, term)
                end
            end
            left
        end

        def relational
            outbounds?()
            strt = @tokens[@i].start_index
            left = bitcomp()
            while type?(:less_than) || type?(:greater_than) || type?(:less_than_equal) || type?(:greater_than_equal)
                current_operator = get_type()
                invalid?()
                right = bitcomp()
                term = right.end_index
                if current_operator == :less_than
                    left = LessThan.new(left, right, strt, term)
                elsif current_operator == :greater_than
                    left = GreaterThan.new(left, right, strt, term)
                elsif current_operator == :less_than_equal
                    left = LessThanEqual.new(left, right, strt, term)
                elsif current_operator == :greater_than_equal
                    left = GreaterThanEqual.new(left, right, strt, term)
                end
            end
            left
        end

        def bitcomp
            outbounds?()
            strt = @tokens[@i].start_index
            left = bitshift()
            while type?(:bitwise_and) || type?(:bitwise_or) || type?(:bitwise_xor)
                current_operator = get_type()
                invalid?()
                right = bitshift()
                term = right.end_index
                if current_operator == :bitwise_and
                    left = BitwiseAnd.new(left, right, strt, term)
                elsif current_operator == :bitwise_or
                    left = BitwiseOr.new(left, right, strt, term)
                elsif current_operator == :bitwise_xor
                    left = BitwiseXor.new(left, right, strt, term)
                end
            end
            left
        end

        def bitshift
            outbounds?()
            strt = @tokens[@i].start_index
            left = sum()
            while type?(:bitshift_left) || type?(:bitshift_right)
                current_operator = get_type()
                invalid?()
                right = sum()
                term = right.end_index
                if current_operator == :bitshift_left
                    left = BitwiseLeftShift.new(left, right, strt, term)
                elsif current_operator == :bitshift_right
                    left = BitwiseLeftShift.new(left, right, strt, term)
                end
            end
            left
        end

        def sum
            outbounds?()
            strt = @tokens[@i].start_index
            left = product()
            while type?(:add) || type?(:subtract)
                current_operator = get_type()
                invalid?()
                right = product()
                term = right.end_index
                if current_operator == :add
                    left = Add.new(left, right, strt, term)
                elsif current_operator == :subtract
                    left = Subtract.new(left, right, strt, term)
                end
            end
            left
        end

        def product 
            outbounds?()
            strt = @tokens[@i].start_index
            left = casting()
            while type?(:multiply) || type?(:divide) || type?(:modulo)
                current_operator = get_type()
                invalid?()
                right = casting()
                term = right.end_index
                if current_operator == :multiply
                    left = Multiply.new(left, right, strt, term)
                elsif current_operator == :divide
                    left = Divide.new(left, right, strt, term)
                elsif current_operator == :modulo
                    left = Modulo.new(left, right, strt, term)
                end
            end
            left
        end

        def casting
            outbounds?()
            strt = @tokens[@i].start_index
            if type?(:to_int_cast) || type?(:to_float_cast)
                current_operator = get_type()
                operand_type = just_get_type()
                invalid?()
                operand = unary()
                term = operand.end_index
                if current_operator == :to_int_cast
                    return FloatToInt.new(operand, strt, term)
                elsif current_operator == :to_float_cast
                    return IntToFloat.new(operand, strt, term)
                end
            else
                return unary() # of keyword is not found then continue
            end
        end

        def unary
            outbounds?()
            strt = @tokens[@i].start_index # grab start index of the unary operator
            if type?(:logical_not) || type?(:bitwise_not) || type?(:subtract)
                current_operator = get_type() # grap operator type and increment
                operand_type = just_get_type() # grab operand's type
                invalid?() # check for invaliditiy on the operand
                operand = atom() # build right branch
                term = operand.end_index # grab end_index of right branch
                if current_operator == :logical_not
                    return Not.new(operand, strt, term)
                elsif current_operator == :bitwise_not
                    return BitwiseNot.new(operand, strt, term)
                elsif current_operator == :subtract
                    if operand_type == :integer # if integer then make a complement integer
                        return NewInteger.new(0 - operand.value, strt, term)
                    elsif operand_type == :float # if float then make a complement float
                        return NewFloat.new(0.0 - operand.value, strt, term)
                    end
                end
            else
                return atom() # of unary op is not found then continue
            end
        end

        # Evaluates to: NewInteger, NewFloat, NewBoolean, NewString, 
        #       Lvalue, Rvalue, Max, Min, Mean, Sum, or recurses within parenthesis.
        def atom
            outbounds?()
            invalid?()
            strt = @tokens[@i].start_index
            if type?(:string)
                term = @tokens[@i].end_index
                return NewString.new(capture(), strt, term)
            elsif type?(:boolean)
                term = @tokens[@i].end_index
                return NewBoolean.new(captureBoolean(), strt, term)
            elsif type?(:integer)
                term = @tokens[@i].end_index
                return NewInteger.new(captureInt(), strt, term)
            elsif type?(:float)
                term = @tokens[@i].end_index
                return NewFloat.new(captureFloat(), strt, term)

            elsif type?(:dollar_sign)
                return munch_lvalue()
            elsif type?(:open_bracket)
                return munch_rvalue()

            elsif type?(:max)
                skip()
                return munch_stat(strt, :max)
            elsif type?(:min)
                skip()
                return munch_stat(strt, :min)
            elsif type?(:mean)
                skip()
                return munch_stat(strt, :mean)
            elsif type?(:sum)
                skip()
                return munch_stat(strt, :sum)

            elsif type?(:open_parenthesis)
                skip()
                expression = logical()
                if type?(:close_parenthesis)
                    term = @tokens[@i].end_index
                    skip()
                    return expression
                else; unexpected(); end
            else
                puts "This Shouldn't be reachable"
            end
        end

        #==============================================================================|
        #                 Auxiliary Parser Methods Below This Point:
        #==============================================================================|

        # syntax checks for the factors of an rvalue and returns an rvalue
        def munch_rvalue
            strt = @tokens[@i].start_index
            if type?(:open_bracket)
                skip()
                if type?(:integer)
                    x = captureInt()
                    if type?(:comma)
                        skip()
                        if type?(:integer)
                            y = captureInt()
                            if type?(:close_bracket)
                                term = @tokens[@i].end_index
                                skip()
                                return Rvalue.new(create_address(x,y), strt, term)
                            else; unexpected(); end
                        else; unexpected(); end
                    else; unexpected(); end
                else; unexpected(); end
            end # if rvalue has yet to be initiated then no need to raise exception
        end

        # syntax checks for the factors of an lvalue and returns an lvalue
        def munch_lvalue
            strt = @tokens[@i].start_index
            if type?(:dollar_sign)
                skip()
                if type?(:open_bracket)
                    skip()
                    if type?(:integer)
                        x = captureInt()
                        if type?(:comma)
                            skip()
                            if type?(:integer)
                                y = captureInt()
                                if type?(:close_bracket)
                                    term = @tokens[@i].end_index
                                    skip()
                                    return Lvalue.new(create_address(x,y), strt, term)
                                else; unexpected(); end
                            else; unexpected(); end
                        else; unexpected(); end
                    else; unexpected(); end
                else; unexpected(); end
            end # if rvalue has yet to be initiated then no need to raise exception
        end

        # syntax checks for the factors of a stat function call and returns a stat function
        def munch_stat(strt, operation)
            if type?(:open_parenthesis)
                skip()
                top_left = munch_lvalue()
                if type?(:comma)
                    skip()
                    bottom_right = munch_lvalue()
                    if type?(:close_parenthesis)
                        term = @tokens[@i].end_index
                        skip()
                        case operation
                        when :max   
                            return Max.new(top_left, bottom_right, strt, term)
                        when :min    
                            return Min.new(top_left, bottom_right, strt, term)
                        when :mean    
                            return Mean.new(top_left, bottom_right, strt, term)
                        when :sum
                            return Sum.new(top_left, bottom_right, strt, term)
                        else
                        end
                    else; unexpected(); end
                else; unexpected(); end
            else; unexpected(); end
        end

        #==============================================================================|
        #                 Misc Helper Methods Below This Point:
        #==============================================================================|
        
        # move along to next token
        def skip; @i += 1; end

        # check if current token both exists and meets provided type
        def type?(type); inbounds? && @tokens[@i].type == type; end

        # raises err if invalid token is present
        def invalid?; type?(:invalid_token) ? (raise TypeError.new("Invalid token at [#{@tokens[@i].start_index}...#{@tokens[@i].end_index}]: \"#{capture}\"")) : 0; end

        def unexpected; outbounds?; raise TypeError.new("Unexpected token at [#{@tokens[@i].start_index}...#{@tokens[@i].end_index}]: \"#{capture}\""); end;

        # raises err if out of bounds
        def outbounds?; !inbounds?() ? (raise IndexError.new("Ran out of tokens to parse at #{@i}.")) : 0; end

        # returns true if I'th token exists
        def inbounds?; @i < @tokens.length; end

        # return current token's type and increment to the next token
        def get_type; type = @tokens[@i].type; skip(); type; end

        # return current token's type
        def just_get_type; @tokens[@i].type; end
        
        # return current token's source string
        def capture; src = @tokens[@i].source; skip(); src; end

        # return current token's source string as an int
        def captureInt; capture().to_i; end

        # return current token's source string as a float
        def captureFloat; capture().to_f; end

        # return current token's source string as a boolean
        def captureBoolean
            if @tokens[@i].source == "true" || @tokens[@i].source == "True"
                skip()
                return true
            elsif @tokens[@i].source == "false" || @tokens[@i].source == "False"
                skip()
                return false
            end
        end
    end
end