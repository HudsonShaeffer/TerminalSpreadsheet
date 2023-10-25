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
        puts "\nString Primitive:\n"
        lex("\"Hello World.\"").each() { |token| token.to_s}
        puts "\nInteger & Float Primitives:\n"
        lex("15 -15 0 1.5 -1.5").each() { |token| token.to_s}
        puts "\nBoolean Primitives:\n"
        lex("truefalseTrueFalse").each() { |token| token.to_s}
        puts "\nKeywords:\n"
        lex("maxminmeansumfloatint").each() { |token| token.to_s}
        puts "\nDelimiters:\n"
        lex("($[,],$[,])").each() { |token| token.to_s}
        puts "\nOperators:\n"
        lex("+-/*%").each() { |token| token.to_s}
        lex("==!=").each() { |token| token.to_s}
        lex("&|~^&&||!>><<").each() { |token| token.to_s}
        lex("< <=> >=").each() { |token| token.to_s}
        puts "\nOperations:\n"
        lex("5+5").each() { |token| token.to_s}
        lex("5-5").each() { |token| token.to_s}
        lex("5*5").each() { |token| token.to_s}
        lex("5/5").each() { |token| token.to_s}
        lex("5%5").each() { |token| token.to_s}
        lex("5&5").each() { |token| token.to_s}
        lex("5|5").each() { |token| token.to_s}
        lex("5^5").each() { |token| token.to_s}
        lex("~5").each() { |token| token.to_s}
        lex("5<<5").each() { |token| token.to_s}
        lex("5>>5").each() { |token| token.to_s}
        lex("true==true").each() { |token| token.to_s}
        lex("true!=true").each() { |token| token.to_s}
        lex("true||true").each() { |token| token.to_s}
        lex("true&&true").each() { |token| token.to_s}
        lex("!true").each() { |token| token.to_s}
        lex("5<5").each() { |token| token.to_s}
        lex("5<=5").each() { |token| token.to_s}
        lex("5>5").each() { |token| token.to_s}
        lex("5>=5").each() { |token| token.to_s}
        puts "\nInvalid Token Locations:\n"
        lex("#4").each() { |token| token.to_s}
        lex("2#4").each() { |token| token.to_s}
        lex("2+#").each() { |token| token.to_s}
        puts "\n"
    end
end

def run_tests(testee)
    testClass = testee.new; methods = testClass.methods; testMethods = methods.filter { |name| name.to_s.include? "test_" }
    testMethods.each { |method| testClass.send(method) }
    
end 
run_tests(LexerTester)