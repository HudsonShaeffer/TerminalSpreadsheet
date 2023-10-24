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
            strt = @tokens[@i].start_index  # store start index of these tree nodes
            left = equals() # init left for base case
            while assert_type?(:logical_and) || assert_type?(:logical_or) # loop over all ands or ors
                term = @tokens[@i].end_index # grab term of this node
                right = equals() # grab right
                if operand_type?(:logical_and) # check for the stored operand type from assert_type?
                    left = And.new(left, right, strt, term) # AND tree node
                elsif operand_type?(:logical_or) # check for the stored operand type from assert_type?
                    left = Or.new(left, right, strt, term)  # OR tree node
                end
            end
            left # return the node
        end

        def equals
            strt = @tokens[@i].start_index
            left = relational()
            while assert_type?(:equals) || assert_type?(:not_equals)
                term = @tokens[@i].end_index
                right = relational()
                if operand_type?(:equals)
                    left = Equals.new(left, right, strt, term)
                elsif operand_type?(:not_equals)
                    left = NotEquals.new(left, right, strt, term)
                end
            end
            left
        end

        def relational
            strt = @tokens[@i].start_index
            left = bitcomp()
            while assert_type?(:LessThan) || assert_type?(:GreaterThan) || assert_type?(:LessThanEqual) || assert_type?(:GreaterThanEqual)
                term = @tokens[@i].end_index
                right = bitcomp()
                if operand_type?(:less_than)
                    left = LessThan.new(left, right, strt, term)
                elsif operand_type?(:greater_than)
                    left = GreaterThan.new(left, right, strt, term)
                elsif operand_type?(:less_than_equal)
                    left = LessThanEqual.new(left, right, strt, term)
                elsif operand_type?(:greater_than_equal)
                    left = GreaterThanEqual.new(left, right, strt, term)
                end
            end
            left
        end

        def bitcomp
            strt = @tokens[@i].start_index
            left = bitshift()
            
            left
        end

        def bitshift
            strt = @tokens[@i].start_index
            left = sum()

            left
        end

        def sum
            strt = @tokens[@i].start_index
            left = product()

            left
        end

        def product 
            strt = @tokens[@i].start_index
            left = unary()

            left
        end

        def unary
            strt = @tokens[@i].start_index
            operand = casting()

            operand
        end

        def casting
            strt = @tokens[@i].start_index
            operand = atom()

            operand
        end

        # Evaluates to: NewInteger, NewFloat, NewBoolean, NewString, 
        #       Lvalue, Rvalue, Max, Min, Mean, Sum, or recurses within parenthesis.
        def atom
            strt = @tokens[@i].start_index
            if inbounds? && type?(:string)
                term = @tokens[@i].end_index
                NewString.new(capture(), strt, term)
            elsif inbounds? && type?(:boolean)
                term = @tokens[@i].end_index
                NewBoolean.new(captureBoolean(), strt, term)
            elsif inbounds? && type?(:integer)
                term = @tokens[@i].end_index
                NewInteger.new(captureInt(), strt, term)
            elsif inbounds? && type?(:float)
                term = @tokens[@i].end_index
                NewFloat.new(captureFloat(), strt, term)
            else
            end
        end

        #==============================================================================|
        #                 Misc Helper Methods Below This Point:
        #==============================================================================|
        
        # move along to next token
        def skip; @i += 1; end

        # check if current token both exists and meets provided type
        def type?(type); inbounds? && @tokens[@i].type == type; end

        # same behavior of type? + store the type & skip the token if it meets provided type
        def assert_type?(type); type?(type) ? (@cur_type = type; skip(); true) : false; end
        
        # check if the stored type meets provided type
        def operand_type?(type); @cur_type == type; end

        # returns true if I'th token exists
        def inbounds?; @i < @tokens.length; end

        # returns true if I'th token does not exist
        def outbounds?; !inbounds?; end
        
        # return current token's source string
        def capture
            src = @tokens[@i].source
            skip()
            src
        end

        # return current token's source string as an int
        def captureInt
            src = @tokens[@i].source.to_i
            skip()
            src
        end

        # return current token's source string as a float
        def captureFloat
            src = @tokens[@i].source.to_f
            skip()
            src
        end

        # return current token's source string as a boolean
        def captureBoolean
            if @tokens[@i].source == "true" || @tokens[@i].source == "True"
                skip()
                true
            elsif @tokens[@i].source == "false" || @tokens[@i].source == "False"
                skip()
                false
            end
        end
    end
end