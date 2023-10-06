require_relative "Lexer.rb"
require_relative "Token.rb"
include Lexer
include Tokens

def assert_equal(expected, actual, message)
    if !expected.equals?(actual)
        puts "#{message}. Expected: #{expected}   Actual: #{actual}"
    end
end

puts lex("&[4, 1]")[0].to_s