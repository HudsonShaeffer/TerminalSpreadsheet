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

        # Reset token, but don't Ignore character. 
        # (if this change ruins tokenizing, make it ignore character again)
        def abandon
            $token_type = :invalid_token
            $token_source = ''
            $start_index = $end_index = -1
        end

        def invalidate
            $token_type = :invalid_token
            emitToken()
        end

        # Ignore character, but don't reset token.
        def skip
            $i += 1
        end

        # Append the accumulated token to the list and reset.
        def emitToken
            $tokens[$token_count] = Token.new($token_type, $token_source, $start_index, $end_index)
            $token_count += 1
            abandon
        end
        
        # Check if current character is a valid boolean keyword character (lowercase sensitive)
        def is_true_r?; $i < $expression.length && $expression[$i] == "r"; end;
        def is_true_u?; $i < $expression.length && $expression[$i] == "u"; end;
        def is_true_e?; $i < $expression.length && $expression[$i] == "e"; end;
        def is_false_a?; $i < $expression.length && $expression[$i] == "a"; end;
        def is_false_l?; $i < $expression.length && $expression[$i] == "l"; end;
        def is_false_s?; $i < $expression.length && $expression[$i] == "s"; end;
        def is_false_e?; $i < $expression.length && $expression[$i] == "e"; end;

        # Check if current character is a valid keyword character (not case sensitive)
        def is_m?; $i < $expression.length && ($expression[$i] == 'm' || $expression[$i] == 'M'); end; 
        def is_char_a?; $i < $expression.length && ($expression[$i] == 'a' || $expression[$i] == 'A'); end; 
        def is_e?; $i < $expression.length && ($expression[$i] == 'e' || $expression[$i] == 'E'); end;
        def is_i?; $i < $expression.length && ($expression[$i] == 'i' || $expression[$i] == 'I'); end; 
        def is_n?; $i < $expression.length && ($expression[$i] == 'n' || $expression[$i] == 'N'); end; 
        def is_u?; $i < $expression.length && ($expression[$i] == 'u' || $expression[$i] == 'U'); end; 
        def is_s?; $i < $expression.length && ($expression[$i] == 's' || $expression[$i] == 'S'); end; 
        def is_x?; $i < $expression.length && ($expression[$i] == 'x' || $expression[$i] == 'X'); end; 
        def is_f?; $i < $expression.length && ($expression[$i] == 'f' || $expression[$i] == 'F'); end;
        def is_l?; $i < $expression.length && ($expression[$i] == 'l' || $expression[$i] == 'L'); end;
        def is_o?; $i < $expression.length && ($expression[$i] == 'o' || $expression[$i] == 'O'); end;
        def is_t?; $i < $expression.length && ($expression[$i] == 't' || $expression[$i] == 'T'); end;

        # Check if current character is a digit
        def is_digit?; $i < $expression.length && "0" <= $expression[$i] && $expression[$i] <= "9"; end;
        
        # Check if current character is a delimiter
        def is_decimal?; $i < $expression.length && $expression[$i] == "."; end;
        def is_comma?; $i < $expression.length && $expression[$i] == ","; end;
        def is_quote?; $i < $expression.length && $expression[$i] == '"'; end;
        def is_dollar?; $i < $expression.length && $expression[$i] == '$'; end;
        def is_open_bracket?; $i < $expression.length && $expression[$i] == '['; end;
        def is_close_bracket?; $i < $expression.length && $expression[$i] == ']'; end;
        def is_open_parenthesis?; $i < $expression.length && $expression[$i] == '('; end;
        def is_close_parenthesis?; $i < $expression.length && $expression[$i] == ')'; end;
        def is_whitespace?; $i < $expression.length && $expression[$i] == " "; end;
        def is_end_of_line?; !($i < $expression.length); end;

        # Check if current character is a operand
        def is_plus?; $i < $expression.length && $expression[$i] === '+'; end;
        def is_minus?; $i < $expression.length && $expression[$i] === '-'; end;
        def is_multiply?; $i < $expression.length && $expression[$i] === '*'; end;
        def is_divide?; $i < $expression.length && $expression[$i] === '/'; end;
        def is_modulo?; $i < $expression.length && $expression[$i] === '%'; end;
        def is_and?; $i < $expression.length && $expression[$i] == '&'; end;
        def is_or?; $i < $expression.length && $expression[$i] == '|'; end;
        def is_xor?; $i < $expression.length && $expression[$i] == '^'; end;
        def is_bitwise_not?; $i < $expression.length && $expression[$i] == '~'; end;
        def is_logical_not?; $i < $expression.length && $expression[$i] == '!'; end;
        def is_equals?; $i < $expression.length && $expression[$i] == '='; end;
        def is_less_than?; $i < $expression.length && $expression[$i] == '<'; end;
        def is_greater_than?; $i < $expression.length && $expression[$i] == '>'; end;
        def is_left_shift?; $i < $expression.length && $expression[$i] == '<'; end;
        def is_right_shift?; $i < $expression.length && $expression[$i] == '>'; end;

        # lexing loop
        while ($i < $expression.length)
            if is_whitespace? # ------------------------------- Whitespace (noop) Branch
                skip
                abandon

            elsif is_quote? # --------------------------------- String Primitive Branch
                $start_index = $i
                capture
                while !is_quote? # munch all chars up until the closing quote
                    capture
                end
                # munch closing quote
                capture
                $end_index = $i
                $token_type = :string
                emitToken() # emit string token

            elsif is_digit? # --------------------------------- Positive Float/Integer Primitives Branch
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

            elsif is_minus? # --------------------------------- Negative / Subtraction Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :subtract
                emitToken()

            elsif is_t? # ------------------------------------- True Boolean Branch
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

            elsif is_f? # ------------------------------------- False Boolean Branch
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
                elsif is_l? # munch l of float
                    capture
                    if is_o? # munch o of float
                        capture
                        if is_char_a? # munch a of float
                            capture
                            if is_t?
                                capture
                                $end_index = $i
                                $token_type = :to_float_cast
                                emitToken()
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif is_m? # ------------------------------------- Max, Min, & Mean Keyword Branch
                $start_index = $i
                capture
                if is_char_a? # munch a for max
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
                    if is_char_a? # munch a for mean
                        capture
                        if is_n? # munch n for mean
                            capture
                            $end_index = $i
                            $token_type = :mean
                            emitToken()
                        else; abandon; end
                    else; abandon; end
                else; abandon; end

            elsif is_s? # ------------------------------------- Sum Keyword Branch
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

            elsif is_i? # ------------------------------------- Int Casting Keyword Branch
                $start_index = $i
                capture
                if is_n? # munch n of int
                    capture
                    if is_t? # munch t of int
                        capture
                        $end_index = $i
                        $token_type = :to_int_cast
                        emitToken()
                    else; abandon; end
                else; abandon; end

            elsif is_dollar? # -------------------------------- Ampersand Branch
                $start_index = $i
                capture
                $end_index = $i 
                $token_type = :dollar_sign
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

            elsif is_plus? # ---------------------------------- Add Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :add
                emitToken()

            elsif is_multiply? # ------------------------------ Multiply Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :multiply
                emitToken()

            elsif is_divide? # -------------------------------- Divide Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :divide
                emitToken()

            elsif is_modulo? # -------------------------------- Modulo Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :modulo
                emitToken()

            elsif is_and? # ----------------------------------- Bitwise & Logical And Branch
                $start_index = $i
                capture
                if is_and? # if there is another & immediately following
                    capture
                    $end_index = $i
                    $token_type = :logical_and
                else # otherwise, that was the end of the token, dont skip or anything
                    $end_index = $i
                    $token_type = :bitwise_and
                end
                emitToken()

            elsif is_or? # ------------------------------------ Bitwise & Logical Or Branch
                $start_index = $i
                capture
                if is_or? # if there is another & immediately following
                    capture
                    $end_index = $i
                    $token_type = :logical_or
                else # otherwise, that was the end of the token, dont skip or anything
                    $end_index = $i
                    $token_type = :bitwise_or
                end
                emitToken()

            elsif is_logical_not? # --------------------------- Logical Not & NotEquals Branch
                $start_index = $i
                capture
                if is_equals? # check for the not equals
                    capture
                    $end_index = $i
                    $token_type = :not_equals
                else # if theres no equals, thats the end of the token
                    $end_index =  $i
                    $token_type = :logical_not
                end
                emitToken()

            elsif is_bitwise_not? # --------------------------- Bitwise Not Branch
                $start_index = $i
                capture
                $end_index =  $i
                $token_type = :bitwise_not
                emitToken()
                
            elsif is_xor? # ----------------------------------- Bitwise Xor Branch
                $start_index = $i
                capture
                $end_index =  $i
                $token_type = :bitwise_xor
                emitToken()
                
            elsif is_equals? # -------------------------------- Equals Branch
                $start_index = $i
                capture
                if is_equals?
                    capture
                    $end_index = $i
                    $token_type = :equals
                    emitToken()
                end

            elsif is_less_than? # ----------------------------- Less Than & Less Than Equals Branch
                $start_index = $i
                capture
                if is_equals? # check for the less than equal operator
                    capture
                    $end_index = $i
                    $token_type = :less_than_equal
                elsif is_left_shift? # make sure theres a second arrow consecutively
                    capture
                    $end_index =  $i
                    $token_type = :bitshift_left
                else # otherwise thats the end of the token
                    $end_index = $i
                    $token_type = :less_than
                end
                emitToken()
                
            elsif is_greater_than? # -------------------------- Greater Than & Greater Than Equals Branch
                $start_index = $i
                capture
                if is_equals? # check for the less than equal operator
                    capture
                    $end_index = $i
                    $token_type = :greater_than_equal
                elsif is_right_shift? # make sure theres a second arrow consecutively
                    capture
                    $end_index =  $i
                    $token_type = :bitshift_right
                else # otherwise thats the end of the token
                    $end_index = $i
                    $token_type = :greater_than
                end
                emitToken()

            else # -------------------------------------------- Invalid Token (Default) Branch
                $start_index = $i
                capture
                $end_index = $i
                $token_type = :invalid_token
                emitToken()

            end
        end

        $tokens
    end
end

