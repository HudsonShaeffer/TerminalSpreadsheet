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
        
        # Check if current character is a valid boolean keyword (case sensitive)
        def is_true_t?; $i < $expression.length && $expression[$i] == "t"; end; # true
        def is_true_r?; $i < $expression.length && $expression[$i] == "r"; end;
        def is_true_u?; $i < $expression.length && $expression[$i] == "u"; end;
        def is_true_e?; $i < $expression.length && $expression[$i] == "e"; end;
        def is_false_f?; $i < $expression.length && $expression[$i] == "f"; end; # false
        def is_false_a?; $i < $expression.length && $expression[$i] == "a"; end;
        def is_false_l?; $i < $expression.length && $expression[$i] == "l"; end;
        def is_false_s?; $i < $expression.length && $expression[$i] == "s"; end;
        def is_false_e?; $i < $expression.length && $expression[$i] == "e"; end;

        # Check if current character is a valid keyword (not case sensitive)
        def is_m?; $i < $expression.length && ($expression[$i] == "m" || $expression[$i] == "M"); end; 
        def is_a?; $i < $expression.length && ($expression[$i] == "a" || $expression[$i] == "A"); end; 
        def is_e?; $i < $expression.length && ($expression[$i] == "e" || $expression[$i] == "E"); end;
        def is_i?; $i < $expression.length && ($expression[$i] == "i" || $expression[$i] == "I"); end; 
        def is_n?; $i < $expression.length && ($expression[$i] == "n" || $expression[$i] == "N"); end; 
        def is_u?; $i < $expression.length && ($expression[$i] == "u" || $expression[$i] == "U"); end; 
        def is_s?; $i < $expression.length && ($expression[$i] == "s" || $expression[$i] == "S"); end; 
        def is_x?; $i < $expression.length && ($expression[$i] == "x" || $expression[$i] == "X"); end; 
        def is_f?; $i < $expression.length && ($expression[$i] == "f" || $expression[$i] == "F"); end;
        def is_l?; $i < $expression.length && ($expression[$i] == "l" || $expression[$i] == "L"); end;
        def is_o?; $i < $expression.length && ($expression[$i] == "o" || $expression[$i] == "O"); end;
        def is_t?; $i < $expression.length && ($expression[$i] == "t" || $expression[$i] == "T"); end;
        
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
                emitToken() # emit string token

            elsif is_digit? # --------------------------------- Float/Integer Primitives Branch
                $start_index = $i
                capture
                while is_digit? # munch all consecutive digits
                    capture
                end
                if is_decimal? # ------------------- Floats SubBranch
                    capture
                    while is_digit? # munch all consecutive digits
                        capture
                    end
                    $end_index = $i
                    $token_type = :float
                    emitToken() # emit float token
                else # ---------------------------- Integers SubBranch
                    $end_index = $i
                    $token_type = :integer
                    emitToken() #emit integer token
                end

            elsif is_true_t? # -------------------------------- True Keyword Branch
                $start_index = $i
                capture
                if is_true_r? # munch r
                    capture
                    if is_true_u? # munch u
                        capture
                        if is_true_e? # munch e
                            capture
                            $end_index = $i
                            $token_type = :boolean
                            emitToken() # emit boolean token
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif is_false_f? # ------------------------------- False Keyword Branch
                $start_index = $i
                capture
                if is_false_a? # munch a
                    capture
                    if is_false_l? # munch l
                        capture
                        if is_false_s? # munch s
                            capture
                            if is_false_e? # munch e
                                capture
                                $end_index = $i
                                $token_type = :boolean
                                emitToken() # emit boolean token
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end
                
            elsif is_m? # ------------------------------------- Max, Min, & Mean Keyword Branch
                $start_index = $i
                capture
                if is_a? # munch a for max
                    capture
                    if is_x? # munch x for max
                        capture
                        $end_index = $i
                        $token_type = :max
                        emitToken()
                    else; abandon; end
                elsif is_i? # munch i for min
                    capture
                    if is_n? # munch n for min
                        capture
                        $end_index = $i
                        $token_type = :min
                        emitToken()
                    else; abandon; end
                elsif is_e? # munch e for mean
                    capture
                    if is_a? # munch a for mean
                        capture
                        if is_n? # munch n for mean
                            capture
                            $end_index = $i
                            $token_type = :mean
                            emitToken()
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif if_s? # ------------------------------------- Sum Keyword Branch
                $start_index = $i
                capture
                if is_u?
                    capture
                    if is_m?
                        capture 
                        $end_index = $i
                        $token_type = :sum
                        emitToken()
                    else; abandon; end
                else; abandon; end

            elsif if_f? # ------------------------------------- Float Casting Keyword Branch
                $start_index = $i
                capture
                if is_l? # munch l of float
                    capture
                    if is_o? # munch o of float
                        capture
                        if is_a? # munch a of float
                            capture
                            if is_t?
                                capture
                                $end_index = $i
                                $token_type = :float_int_cast
                                emitToken()
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif if_i? # ------------------------------------- Int Casting Keyword Branch
                $start_index = $i
                capture
                if is_n? # munch n of int
                    capture
                    if is_t? # munch t of int
                        capture
                        $end_index = $i
                        $token_type = :int_float_cast
                        emitToken()
                    else; abandon; end
                else; abandon; end

            elsif is_ampersand? # ----------------------------- Ampersand Branch
                $start_index = $i
                capture
                $end_index = $i 
                $token_type = :ampersand
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

            elsif false
                $start_index = $i
                capture
            elsif false
                $start_index = $i
                capture
            else # -------------------------------------------- Default Branch
                abandon
            end
        end

        $tokens
    end
end

