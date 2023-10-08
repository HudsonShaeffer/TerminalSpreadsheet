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
    
end 
run_tests(LexerTester)

lex("&[1, 2]").each() { |token| puts token.to_s}
lex("\"Hello World.\"").each() { |token| puts token.to_s}
lex("1 2.3. 123.3 true").each() { |token| puts token.to_s}
lex("true").each() { |token| puts token.to_s}