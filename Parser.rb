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
            strt = @tokens[@i].start_index
            left = equals() 
            while assert_type?(:logical_and)
                term = @tokens[@i].end_index
                right = equals()
                left = And.new(left, right, strt, term)
            end
            while assert_type?(:logical_or)
                term = @tokens[@i].end_index
                right = equals()
                left = Or.new(left, right, strt, term)
            end
            left
        end

        def equals
            left = relational()

            left
        end

        def relational
            left = bitcomp()

            left
        end

        def bitcomp
            left = bitshift()

            left
        end

        def bitshift
            left = sum()

            left
        end

        def sum
            left = product()

            left
        end

        def product 
            left = unary()

            left
        end

        def unary
            left = casting()

            left
        end

        def casting
            left = atom()

            left
        end

        # Evaluates to: NewInteger, NewFloat, NewBoolean, NewString, 
        #       Lvalue, Rvalue, Max, Min, Mean, Sum, or recurses within parenthesis.
        def atom
            if inbounds? && type?(:string)
               capture()
            elsif inbounds? && type?(:boolean)
                captureBoolean()
            elsif inbounds? && type?(:integer)
                captureInt()
            elsif inbounds? && type?(:float)
                captureFloat()
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

        # same behavior of type? + skip the token if it meets provided type
        def assert_type?(type); type?(type) ? (skip(); true) : false; end

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