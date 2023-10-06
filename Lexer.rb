require_relative "Token.rb"
include Tokens

module Lexer
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
        def capture
            $token_source += $expression[$i]
            $i += 1
        end

        # Ignore character, reset token.
        def abandon
            $i += 1
            $token_type = :invalid_token
            $token_source = ''
            $start_index = $end_index = -1
        end

        # Ignore character, but don't reset token.
        def skip
            $i += 1
        end

        # Append the accumulated token to the list and reset.
        def emitToken
            $tokens[$token_count] = Token.new($token_type, $token_source, $start_index, $end_index)
            $token_count += 1
            $token_source = ''
        end
        
        # Check if current character is a valid boolean char
        def is_true_t?; $i < $expression.length && $expression[$i] == "t"; end; # true
        def is_true_r?; $i < $expression.length && $expression[$i] == "r"; end;
        def is_true_u?; $i < $expression.length && $expression[$i] == "u"; end;
        def is_true_e?; $i < $expression.length && $expression[$i] == "e"; end;
        def is_false_f?; $i < $expression.length && $expression[$i] == "f"; end; # false
        def is_false_a?; $i < $expression.length && $expression[$i] == "a"; end;
        def is_false_l?; $i < $expression.length && $expression[$i] == "l"; end;
        def is_false_s?; $i < $expression.length && $expression[$i] == "s"; end;
        def is_false_e?; $i < $expression.length && $expression[$i] == "e"; end;

        # Check if current character is a valid statistical char
        def is_m?; $i < $expression.length && ($expression[$i] == "m" || $expression[$i] == "M"); end; 
        def is_a?; $i < $expression.length && ($expression[$i] == "a" || $expression[$i] == "A"); end; 
        def is_x?; $i < $expression.length && ($expression[$i] == "x" || $expression[$i] == "X"); end; 
        def is_e?; $i < $expression.length && ($expression[$i] == "e" || $expression[$i] == "E"); end; 
        def is_i?; $i < $expression.length && ($expression[$i] == "i" || $expression[$i] == "I"); end; 
        def is_n?; $i < $expression.length && ($expression[$i] == "n" || $expression[$i] == "N"); end; 
        def is_u?; $i < $expression.length && ($expression[$i] == "u" || $expression[$i] == "U"); end; 
        def is_s?; $i < $expression.length && ($expression[$i] == "s" || $expression[$i] == "S"); end; 
        
        # Check if current character is a digit, dot, or comma
        def is_digit?; $i < $expression.length && "0" <= $expression[$i] && $expression[$i] <= "9"; end;
        def is_decimal?; $i < $expression.length && $expression[$i] == "."; end;
        def is_comma?; $i < $expression.length && $expression[$i] == ","; end;

        # Check if the current character is an open bracket, close bracket, open parenthesis, or close parenthesis
        def is_open_bracket?; $i < $expression.length && $expression[$i] == '['; end;
        def is_close_bracket?; $i < $expression.length && $expression[$i] == ']'; end;
        def is_open_parenthesis?; $i < $expression.length && $expression[$i] == '('; end;
        def is_close_parenthesis?; $i < $expression.length && $expression[$i] == ')'; end;

        # Check if the current character is a delimiter
        def is_ampersand?; $i < $expression.length && $expression[$i] == '&'; end;
        def is_quote?; $i < $expression.length && $expression[$i] == '"'; end;
        def is_whitespace?; $i < $expression.length && $expression[$i] == " "; end;
        def is_end_of_line?; !($i < $expression.length); end;

        # lexing loop
        while ($i < $expression.length)
            if is_whitespace? # ------------------------------- Whitespace (noop) Branch
                abandon

            elsif is_quote? # --------------------------------- String Primitive Branch
                $start_index = $i
                capture
                while !is_quote? # munch all chars up until the closing quote
                    capture
                end
                # munch closing quote
                $end_index = $i
                capture
                $token_type = :string
                emitToken # emit string token

            elsif is_digit? # --------------------------------- Float/Integer Primitives Branch
                $start_index = $i
                capture
                while is_digit? # munch all consecutive digits
                    $end_index = $i
                    capture
                end
                if is_decimal? # ------------------- Floats SubBranch
                    $end_index = $i
                    capture
                    while is_digit? # munch all consecutive digits
                        $end_index = $i
                        capture
                    end
                    $token_type = :float
                    emitToken # emit float token
                else # ---------------------------- Integers SubBranch
                    $end_index = $i
                    $token_type = :integer
                    emitToken #emit integer token
                end

            elsif is_true_t? # -------------------------------- True Branch
                $start_index = $i
                capture
                if is_true_r? # munch r
                    capture
                    if is_true_u? # munch u
                        capture
                        if is_true_e? # munch e
                            $end_index = $i
                            capture
                            $token_type = :boolean
                            emitToken # emit boolean token
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif is_false_f? # ------------------------------- False Branch
                $start_index = $i
                capture
                if is_false_a? # munch a
                    capture
                    if is_false_l? # munch l
                        capture
                        if is_false_s? # munch s
                            capture
                            if is_false_e? # munch e
                                $end_index = $i
                                capture
                                $token_type = :boolean
                                emitToken # emit boolean token
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif is_ampersand? # ----------------------------- Lvalue Branch
                $start_index = $i
                capture
                $end_index = $i 
                $token_type = :lvalue
                emitToken()

            elsif is_open_bracket? # -------------------------- Open Bracket Branch
                $start_index = $i
                capture
                $end_index = $i 
                $token_type = :open_bracket
                emitToken()

            elsif is_close_bracket? # ------------------------- Close Bracket Branch 
                $start_index = $i
                capture
                $end_index = $i 
                $token_type = :close_bracket
                emitToken()

            elsif is_open_parenthesis? # ---------------------- Open Parenthesis Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :open_parenthesis
                emitToken()

            elsif is_close_parenthesis? # --------------------- Close Parenthesis Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :close_parenthesis
                emitToken()

            elsif is_comma? # --------------------------------- Comma Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :comma
                emitToken()

            elsif is_m? # ------------------------------------- Max, Min, & Mean Branch
                $start_index = $i
                capture
                if is_a?

                elsif is_i?

                elsif is_e?
                    
                else
            else # -------------------------------------------- Default Branch
                abandon
            end
        end

        $tokens
    end
end

