require_relative "Token.rb"
include Token

module Lexer
    def lex(expression)
        # Check if current character is a digit.
        is_digit = ->(char) { 
            i += 1
            char === /\d/ 
        }

        # Check if the current character is a character (ignoring case)
        is_char = ->(char) { 
            i += 1
            char === /[a-z]/i 
        }

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

        # remove carriage returns (if any)
        while (expression.chomp! != nil); end

        # loop variables
        i = 0;
        token_type = :invalid_token
        token_source = '';
        start_index = end_index = -1;
        tokens = [];

        while (i < expression.length)
            case expression[i]
            when 
            when
            else
            end
        end

        tokens
    end
end