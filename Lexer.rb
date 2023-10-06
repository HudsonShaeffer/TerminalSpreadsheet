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
        
        # Check if current character is a valid boolean char.
        def is_first_true?; $i < $expression.length && $expression[$i] === "t"; end; # true
        def is_second_true?; $i < $expression.length && $expression[$i] === "r"; end;
        def is_third_true?; $i < $expression.length && $expression[$i] === "u"; end;
        def is_fourth_true?; $i < $expression.length && $expression[$i] === "e"; end;
        def is_first_false?; $i < $expression.length && $expression[$i] === "f"; end; # false
        def is_second_false?; $i < $expression.length && $expression[$i] === "a"; end;
        def is_third_false?; $i < $expression.length && $expression[$i] === "l"; end;
        def is_fourth_false?; $i < $expression.length && $expression[$i] === "s"; end;
        def is_fifth_false?; $i < $expression.length && $expression[$i] === "e"; end;
        
        # Check if current character is a digit, dot, or comma
        def is_digit?; $i < $expression.length && "0" <= $expression[$i] && $expression[$i] <= "9"; end;
        def is_decimal?; $i < $expression.length && $expression[$i] == "."; end;
        def is_comma?; $i < $expression.length && $expression[$i] == ","; end;

        # Check if the current character is a quote
        def is_quote?; $i < $expression.length && $expression[$i] == '"'; end;
        
        # Check if the current character is an ampersand
        def is_ampersand?; $i < $expression.length && $expression[$i] == '&'; end;
        
        # Check if the current character is an open bracket, close bracket, open parenthesis, or close parenthesis
        def is_open_bracket?; $i < $expression.length && $expression[$i] == '['; end;
        def is_close_bracket?; $i < $expression.length && $expression[$i] == ']'; end;
        def is_open_parenthesis?; $i < $expression.length && $expression[$i] == '('; end;
        def is_close_parenthesis?; $i < $expression.length && $expression[$i] == ')'; end;

        # Check if the current character is a whitespace
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
                elsif is_end_of_line? || is_whitespace? # ------------- Integer SubBranch
                    $end_index = $i
                    $token_type = :integer
                    emitToken #emit integer token
                else; abandon; end

            elsif is_first_true? # ---------------------------- True Branch
                $start_index = $i
                capture
                if is_second_true? # munch r
                    capture
                    if is_third_true? # munch u
                        capture
                        if is_fourth_true? # munch e
                            $end_index = $i
                            capture
                        else; abandon; end
                    else; abandon; end
                else; abandon; end
                # once word is complete, if its followed by a whitespace or the end of the expression then its a boolean primitive value
                if is_end_of_line? || is_whitespace?
                    $token_type = :boolean
                    emitToken # emit boolean token
                else; abandon; end

            elsif is_first_false? # --------------------------- False Branch
                $start_index = $i
                capture
                if is_second_false? # munch a
                    capture
                    if is_third_false? # munch l
                        capture
                        if is_fourth_false? # munch s
                            capture
                            if is_fifth_false? # munch e
                                $end_index = $i
                                capture
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end
                # once word is complete, if its followed by a whitespace or the end of the $expression then its a boolean primitive value
                if is_end_of_line? || is_whitespace?
                    $token_type = :boolean
                    emitToken # emit boolean token
                else; abandon; end

            elsif is_ampersand? # ----------------------------- Lvalue Branch
                $start_index = $i
                capture
                if is_open_bracket? # munch open bracket
                    capture
                    while is_whitespace?; skip; end # munch variable amount of whitespace [ num
                    if is_digit? # munch first x value digit
                        capture
                        while is_digit? # munch rest x digits
                            capture
                        end
                        while is_whitespace?; skip; end # munch variable amount of whitespace num ,
                        if is_comma? # munch comma delimiter
                            capture
                            while is_whitespace?; skip; end # munch variable amount of whitespace , num
                            if is_digit? # munch first y value digit
                                capture
                                while is_digit? # munch rest y digits
                                    capture
                                end
                                while is_whitespace?; skip; end # munch variable amount of whitespace num ]
                                if is_close_bracket? # munch close bracket
                                    $end_index = $i
                                    capture
                                    $token_type = :lvalue
                                    emitToken # emit lvalue token
                                else; abandon; end
                            else; abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end
            elsif is_open_bracket? # -------------------------- Rvalue Branch
                $start_index = $i
                capture
                while is_whitespace?; skip; end # munch variable amount of whitespace [ num
                if is_digit? # munch first x value digit
                    capture
                    while is_digit? # munch rest x digits
                        capture
                    end
                    while is_whitespace?; skip; end # munch variable amount of whitespace num ,
                    if is_comma? # munch comma delimiter
                        capture
                        while is_whitespace?; skip; end # munch variable amount of whitespace , num
                        if is_digit? # munch first y value digit
                            capture
                            while is_digit? # munch rest y digits
                                capture
                            end
                            while is_whitespace?; skip; end # munch variable amount of whitespace num ]
                            if is_close_bracket? # munch close bracket
                                $end_index = $i
                                capture
                                $token_type = :rvalue
                                emitToken # emit rvalue token
                            else abandon; end
                        else; abandon; end
                    else; abandon; end
                else; abandon; end
            elsif false
            elsif false 
            else # ------------------------------------------- Default Branch
                abandon
            end
        end

        $tokens
    end
end

