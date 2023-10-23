require_relative "Parser.rb"
require_relative "Lexer.rb"
require_relative "Token.rb"
include ParserModule
include Lexer
include Tokens

parser = Parser.new()
puts parser.parse(lex("true&&true"))