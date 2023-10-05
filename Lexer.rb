require_relative "Token.rb"
include Token

module Lexer
    def lex(expression)
        i = 0;
        tokenSoFar = '';
        tokens = [];

        # Check if current character is target.
        def has(target) 
            i < expression.length && expression[i] === target;
        end

        # Check if current character is not target.
        def hasNot(target) 
            i < expression.length && expression[i] !== target;
        end

        # Check if current character is a digit.
        def hasDigit() 
            i < expression.length && '0' <= expression[i] && expression[i] <= '9';
        end

        # Add current character to token and move along.
        def capture() 
            tokenSoFar += expression[i];
            i += 1;
        end

        # Ignore character, reset token.
        def abandon() 
            i += 1;
            tokenSoFar = '';
        end

        # Ignore character, but don't reset token.
        def skip() 
            i += 1;
        end

        # Append the accumulated token to the list and reset.
        def emitToken(type, start_index, end_index) 
            tokens.push(Token.new(type, tokenSoFar, start_index, end_index));
            tokenSoFar = '';
        end


    end
end