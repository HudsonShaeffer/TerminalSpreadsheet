require_relative "Lexer.rb"
require_relative "Token.rb"
include Lexer
include Tokens

def assert_equal(expected, actual, message)
    if !expected.equals?(actual)
        puts "#{message}. Expected: #{expected}   Actual: #{actual}"
    end
end

class LexerTester
    def initialize
    end

    def test_lex

    end
end

def run_tests(testee)
    testClass = testee.new; methods = testClass.methods; testMethods = methods.filter { |name| name.to_s.include? "test_" }
    testMethods.each { |method| testClass.send(method) }
    puts 
end 
run_tests(LexerTester)

puts lex("&[4, 1]")[0].to_s