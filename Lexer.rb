require_relative "Token.rb"
include Tokens

module Lexer
    def initialize
    end

    def lex(expression)

        # loop variables
        $i = 0
        $expression = expression
        $token_type = :invalid_token
        $token_source = ''
        $start_index = $end_index = -1
        $token_count = 0
        $tokens = []

        # Add current character to token and move along.
        def capture() 
            $token_source += $expression[$i]
            $i += 1
        end

        # Ignore character, reset token.
        def abandon() 
            $i += 1
            $token_type = :invalid_token
            $token_source = ''
        end

        # Ignore character, but don't reset token.
        def skip() 
            $i += 1
        end

        # Append the accumulated token to the list and reset.
        def emitToken
            $tokens[$token_count] = Token.new($token_type, $token_source, $start_index, $end_index)
            $token_count += 1
            $token_source = ''
        end

        # Check if the current character is a character (ignoring case)
        def is_char; $i < $expression.length && $expression[$i] === /[a-z]/i; end;
        
        # Check if current character is a valid string char.
        def is_str; $i < $expression.length && $expression[$i] === /\w/; end;
        
        # Check if current character is a valid boolean char.
        def is_first_true; $i < $expression.length && $expression[$i] === "t"; end; # true
        def is_second_true; $i < $expression.length && $expression[$i] === "r"; end;
        def is_third_true; $i < $expression.length && $expression[$i] === "u"; end;
        def is_fourth_true; $i < $expression.length && $expression[$i] === "e"; end;
        def is_first_false; $i < $expression.length && $expression[$i] === "f"; end; # false
        def is_second_false; $i < $expression.length && $expression[$i] === "a"; end;
        def is_third_false; $i < $expression.length && $expression[$i] === "l"; end;
        def is_fourth_false; $i < $expression.length && $expression[$i] === "s"; end;
        def is_fifth_false; $i < $expression.length && $expression[$i] === "e"; end;
        
        # Check if current character is a digit.
        def is_digit; $i < $expression.length && $expression[$i] === /\d/; end;

        # Check if the current character is a dot
        def is_decimal; $i < $expression.length && $expression[$i] === "."; end;

        # Check if the current character is a quote
        def is_quote; $i < $expression.length && $expression[$i] === '"'; end;

        # Check if the current character is a whitespace
        def is_whitespace; $i < $expression.length && $expression[$i] === " "; end;

        # lexing loop
        while ($i < $expression.length)
            if is_whitespace # ---------------------------- Whitespace (noop) Branch
                abandon

            elsif is_quote # --------------------------------- String Primitive Branch
                $start_index = $i
                capture
                while !is_quote # after first quote, loop until another quote is detected
                    capture
                end
                # once closing quote is found capture it again
                $end_index = $i
                capture
                # emit finished string token
                $token_type = :string
                emitToken 

            elsif is_digit # --------------------------------- Float/Integer Primitives Branch
                $start_index = $i
                capture
                while is_digit # after first digit is found, loop through all digits
                    $end_index = $i
                    capture
                end
                if is_decimal # ------------------- Floats SubBranch
                    capture
                    while is_digit # loop through all remaining digits
                        $end_index = $i
                        capture
                    end
                    $token_type = :float
                    emitToken
                elsif is_whitespace # ------------- Integer SubBranch
                    $token_type = :integer
                    emitToken
                else # ---------------------------- Bad number subbranch :(
                    abandon
                end

            elsif is_first_true # ---------------------------- True Branch
                $start_index = $i
                capture
                if is_second_true
                    capture
                    if is_third_true
                        capture
                        if is_fourth_true
                            $end_index = $i
                            capture
                        else
                            abandon
                        end
                    else
                        abandon
                    end
                else
                    abandon
                end
                # once word is complete, if its followed by a whitespace or the end of the $expression then its a boolean primitive value
                if !($i < $expression.length) || is_whitespace
                    $token_type = :boolean
                    emitToken
                else
                    $token_type = :invalid_token
                    abandon
                end

            elsif is_first_false # --------------------------- False Branch
                $start_index = $i
                capture
                if is_second_false
                    capture
                    if is_third_false
                        capture
                        if is_fourth_false
                            capture
                            if is_fifth_false
                                $end_index = $i
                                capture
                            else
                                abandon
                            end
                        else
                            abandon
                        end
                    else
                        abandon
                    end
                else
                    abandon
                end
                # once word is complete, if its followed by a whitespace or the end of the $expression then its a boolean primitive value
                if !($i < $expression.length) || is_whitespace
                    $token_type = :boolean
                    emitToken
                else
                    $token_type = :invalid_token
                    abandon
                end

            elsif false
            elsif false
            else # ------------------------------------------ Default Branch
                p "reached default"
                $i += 1
            end
        end

        $tokens
    end
end
