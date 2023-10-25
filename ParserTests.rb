require_relative "Parser.rb"
require_relative "Lexer.rb"
require_relative "Token.rb"
include ParserModule
include Lexer
include Tokens

parser = Parser.new()
puts parser.parse(lex("true&&true"))
puts parser.parse(lex("true||true"))
puts parser.parse(lex("true==true"))
puts parser.parse(lex("true!=true"))
puts parser.parse(lex("1<1"))
puts parser.parse(lex("1<=1"))
puts parser.parse(lex("1>1"))
puts parser.parse(lex("1>=1"))
puts parser.parse(lex("1&1"))
puts parser.parse(lex("1|1"))
puts parser.parse(lex("1^1"))
puts parser.parse(lex("1<<1"))
puts parser.parse(lex("1>>1"))
puts parser.parse(lex("1+1"))
puts parser.parse(lex("1-1"))
puts parser.parse(lex("1*1"))
puts parser.parse(lex("1/1"))
puts parser.parse(lex("1%1"))
puts parser.parse(lex("!true"))
puts parser.parse(lex("~1"))
puts parser.parse(lex("-1"))
puts parser.parse(lex("-1.0"))
puts parser.parse(lex("float 1"))
puts parser.parse(lex("int 1.0"))
puts parser.parse(lex("float -1"))
puts parser.parse(lex("int -1.0"))
puts parser.parse(lex("1"))
puts parser.parse(lex("1.0"))
puts parser.parse(lex("true"))
puts parser.parse(lex("\"monky\""))
puts parser.parse(lex("$[0,0]"))
puts parser.parse(lex("[0,0]"))
puts parser.parse(lex("Max($[0,0],$[0,0])"))
puts parser.parse(lex("Min($[0,0],$[0,0])"))
puts parser.parse(lex("Mean($[0,0],$[0,0])"))
puts parser.parse(lex("Sum($[0,0],$[0,0])"))
puts parser.parse(lex("2*(1+1)"))
# invalid token
# puts parser.parse(lex("#"))
# unexpected token within syntax
# puts parser.parse(lex("Sum[$[0,0],$[0,0])"))
# ran out of tokens to parse
# puts parser.parse(lex("Sum($[0,0],$[0,0]"))