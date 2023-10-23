require_relative "Token.rb"
include Tokens

module Parser
    class Parser
        # init parser recursion
        def parse(tokens)
            @tokens = tokens
            @i = 0
            logical()
        end

        # expression = logical so logical is first
        def logical
            left = equals() 
            if assert_type?(:logical_and)
                
            elsif assert_type?(:logical_or)

            end
            left
        end

        def equals

        end

        def relational

        end

        def bitcomp

        end

        def bitshift

        end

        def sum

        end

        def product 

        end

        def unary

        end

        def casting

        end

        # Evaluates to: NewInteger, NewFloat, NewBoolean, NewString, 
        #       Lvalue, Rvalue, Max, Min, Mean, Sum, or recurses within parenthesis.
        def atom

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
        def capture; @tokens[@i].source; end

        # return current token's source string as an int
        def captureInt; @tokens[@i].source.to_i; end

        # return current token's source string as a float
        def captureFloat; @tokens[@i].source.to_f; end

        # return current token's source string as a boolean
        def captureBoolean
            if $tokens[$i].source == "true" || $tokens[$i].source == "True"
                true
            elsif $tokens[$i].source == "false" || $tokens[$i].source == "False"
                false
            end
        end
    end
end