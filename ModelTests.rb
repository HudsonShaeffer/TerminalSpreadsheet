require_relative "Model.rb"
include Model

def assert_equal(expected, actual, message)
    if expected != actual
        puts "#{message}. Expected: #{expected}   Actual: #{actual}"
    end
end

class ModelTester
    def initialize
        puts 
        puts "----------~ Testing Abstractions ~---------------"
        puts
        puts "  Testing Grid:"                  # Grid Tests
        # Create testee
        @grid = Grid.new()
        # Test place
        @grid.place(create_address(0,0), NewInteger.new(4));
        # Test retrieve
        assert_equal(4, @grid.retrieve(create_address(0,0)).value, 
                        "Retrieve Test Failed")
        puts
        puts "  Testing Enviornment:"           # Enviornment Tests
        # Create testee
        @enviornment = Enviornment.new(@grid)
        # Test evaluate
        assert_equal(4, @enviornment.evaluate(create_address(0,0)).value, 
                        "Evaluate Test Failed")
        assert_equal(4, @enviornment.evaluate(Lvalue.new(create_address(0,0))).value, 
                        "Evaluate Test Failed")
        assert_equal(nil, @enviornment.evaluate(create_address(-1,-1)), 
                        "Nil Evaluate Test Failed")
        puts
    end

    def test_New_Primitives
        puts 
        puts "----------~ Testing Primitives ~---------------"
        puts
        puts "  Testing NewInteger:"            # NewInteger Tests
        # Create testees
        testee_integer_zero = NewInteger.new(0)
        # Test equalities
        assert_equal(0, testee_integer_zero.value, 
                        "Zero Equality Test Failed")
        # Test evaluate equalities
        assert_equal(testee_integer_zero.value, testee_integer_zero.evaluate(@enviornment).value, 
                        "Zero Equality Test Using Evaluate Failed")
        puts
        puts "  Testing NewFloat:"              # NewFloat Tests
        # Create testees
        testee_float_zero = NewFloat.new(0.0)
        # Test eqalities
        assert_equal(0.0, testee_float_zero.value, 
                        "Zero Equality Test Failed")
        # Test evaluate equalities
        assert_equal(testee_float_zero.value, testee_float_zero.evaluate(@enviornment).value, 
                        "Zero Equality Test Using Evaluate Failed")
        puts
        puts "  Testing NewBoolean:"            # NewBoolean Tests
        # Create testees
        testee_bool_true = NewBoolean.new(true)
        testee_bool_false = NewBoolean.new(false)
        # Test equalities
        assert_equal(true, testee_bool_true.value, 
                        "True Equality Test Failed")
        assert_equal(false, testee_bool_false.value, 
                        "False Equality Test Failed")
        # Test evaluate equalities
        assert_equal(testee_bool_true.value, testee_bool_true.evaluate(@enviornment).value, 
                        "True Equality Test Using Evaluate Failed")
        assert_equal(testee_bool_false.value, testee_bool_false.evaluate(@enviornment).value, 
                        "True Equality Test Using Evaluate Failed")
        puts
        puts "  Testing NewString:"             # NewString Tests
        # Create testees
        testee_string = NewString.new("Hello!")
        testee_string_empty = NewString.new("")
        # Test equalities
        assert_equal("Hello!", testee_string.value, 
                        "Message Equality Test Failed")
        assert_equal("", testee_string_empty.value, 
                        "Empty Message Equality Test Failed")
        # Test evaluate equalities
        assert_equal(testee_string.value, testee_string.evaluate(@enviornment).value, 
                        "Message Equality Test Using Evaluate Failed")
        assert_equal(testee_string_empty.value, testee_string_empty.evaluate(@enviornment).value, 
                        "Empty Message Equality Test Using Evaluate Failed")
        puts
    end

    def test_Cell_References
        puts
        puts "----------~ Testing Cell References ~---------------"
        puts
        puts "  Testing Lvalue: "               # Lvalue Tests
        # Create testee
        testee_lvalue = Lvalue.new(create_address(0,0))
        # Test evaluate equality
        assert_equal(create_address(0,0), testee_lvalue.evaluate(@enviornment), "Evaluate Test Failed")
        puts
        puts "  Testing Rvalue: "               # Rvalue Tests
        # Create testees
        testee_rvalue = Rvalue.new(create_address(0,0))
        # Test evaluate equality
        assert_equal(4, testee_rvalue.evaluate(@enviornment).value, "Evaluate Test Failed")
        # Test uninitialized cell retrieval
        begin Rvalue.new(create_address(-1,-1)).evaluate(@enviornment)
            puts "        Uninitialized Cell Checking: FAILED"
        rescue
            puts "        Uninitialized Cell Checking: Successful"
        end
        puts
    end

    def test_Arithmetic_Operations
        puts 
        puts "----------~ Testing Arithmetic Operations ~---------------"
        puts
        puts "  Testing Add: "                  # Add Tests
        # Create Testees
        testee_add_positive_integer = Add.new(NewInteger.new(2), NewInteger.new(2))
        testee_add_positive_float = Add.new(NewFloat.new(2.0), NewFloat.new(2.0))
        # Test equality
        assert_equal(4, testee_add_positive_integer.evaluate(@enviornment).value, 
                        "Integers Equality Test Failed")
        assert_equal(4.0, testee_add_positive_float.evaluate(@enviornment).value, 
                        "Floats Equality Test Failed")
        # Test Typechecking
        begin Add.new(NewInteger.new(2), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Add.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Add.new(NewInteger.new(2.0), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Subtract: "             # Subtract Tests
        # Create Testees
        testee_subtract_positive_integer = Subtract.new(NewInteger.new(2), NewInteger.new(2))
        testee_subtract_positive_float = Subtract.new(NewFloat.new(2.0), NewFloat.new(2.0))
        # Test equality
        assert_equal(0, testee_subtract_positive_integer.evaluate(@enviornment).value, 
                        "Integers Equality Test Failed")
        assert_equal(0.0, testee_subtract_positive_float.evaluate(@enviornment).value, 
                        "Floats Equality Test Failed")
        # Test Typechecking
        begin Subtract.new(NewInteger.new(2), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Subtract.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Subtract.new(NewInteger.new(2.0), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Divide: "               # Divide Tests
        # Create Testees
        testee_divide_positive_integer = Divide.new(NewInteger.new(4), NewInteger.new(2))
        testee_divide_positive_float = Divide.new(NewFloat.new(4.0), NewFloat.new(2.0))
        # Test equality
        assert_equal(2, testee_divide_positive_integer.evaluate(@enviornment).value, 
                        "Integers Equality Test Failed")
        assert_equal(2.0, testee_divide_positive_float.evaluate(@enviornment).value, 
                        "Floats Equality Test Failed")
        # Test Typechecking
        begin Divide.new(NewInteger.new(2), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Divide.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Divide.new(NewInteger.new(2.0), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Multiply: "             # Multiply Tests
        # Create Testees
        testee_multiply_positive_integer = Multiply.new(NewInteger.new(2), NewInteger.new(2))
        testee_multiply_positive_float = Multiply.new(NewFloat.new(2.0), NewFloat.new(2.0))
        # Test equality
        assert_equal(4, testee_multiply_positive_integer.evaluate(@enviornment).value, 
                        "Positive Integers Equality Test Failed")
        assert_equal(4.0, testee_multiply_positive_float.evaluate(@enviornment).value, 
                        "Positive Floats Equality Test Failed")
        # Test Typechecking
        begin Multiply.new(NewInteger.new(2), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Multiply.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Multiply.new(NewInteger.new(2.0), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Modulo: "               # Modulo Tests
        # Create Testees
        testee_modulo_positive_integer = Modulo.new(NewInteger.new(3), NewInteger.new(2))
        testee_modulo_positive_float = Modulo.new(NewFloat.new(3.0), NewFloat.new(2.0))
        # Test equality
        assert_equal(1, testee_modulo_positive_integer.evaluate(@enviornment).value, 
                        "Positive Integrs Equality Test Failed")
        assert_equal(1.0, testee_modulo_positive_float.evaluate(@enviornment).value, 
                        "Positive Floats Equality Test Failed")
        # Test Typechecking
        begin Modulo.new(NewInteger.new(2), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Modulo.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Modulo.new(NewInteger.new(2.0), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
    end

    def test_Logical_Operations
        puts
        puts "----------~ Testing Logical Operations ~---------------"
        puts
        puts "  Testing And:"                   # And Tests
        # create testee
        testee_and = And.new(NewBoolean.new(true), NewBoolean.new(false))
        # Test equality
        assert_equal(false, testee_and.evaluate(@enviornment).value, 
                        "Equality Test failed")
        # Test Typechecking
        begin And.new(NewBoolean.new(true), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin And.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin And.new(NewBoolean.new(true), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Or:"                    # Or Tests
        # create testee
        testee_or = And.new(NewBoolean.new(true), NewBoolean.new(false))
        # Test equality
        assert_equal(false, testee_or.evaluate(@enviornment).value, 
                        "Equality Test failed")
        # Test Typechecking
        begin Or.new(NewBoolean.new(true), NewFloat.new(2.0)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Or.new(NewInteger.new(2.0), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Or.new(NewBoolean.new(true), NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing Not:"                   # And Tests
        # create testee
        testee_not = Not.new(NewBoolean.new(true))
        # Test equality
        assert_equal(false, testee_and.evaluate(@enviornment).value, 
                        "Equality Test failed")
        # Test Typechecking
        begin Not.new(NewInteger.new(2)).evaluate(@enviornment) 
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Not.new(NewFloat.new(2.0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin Not.new(NewString.new("hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
    end

    def test_Relational_Operations
        puts 
        puts "----------~ Testing Relational Operations ~---------------"
        puts
        puts "  Testing Equals:"                # Equals Tests
        # Create testee
        testee_equals = Equals.new(NewBoolean.new(true), NewBoolean.new(true))
        # Test Equality
        assert_equal(true, testee_equals.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
        puts "  Testing NotEquals:"             # NotEquals Tests
        # Create testee
        testee_not_equals = NotEquals.new(NewBoolean.new(true), NewBoolean.new(true))
        # Test Equality
        assert_equal(false, testee_not_equals.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
        puts "  Testing LessThan:"              # LessThan Tests
        # Create testee
        testee_less_than = LessThan.new(NewInteger.new(0), NewInteger.new(1))
        # Test Equality
        assert_equal(true, testee_less_than.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
        puts "  Testing LessThanEqual:"         # LessThanEqual Tests
        # Create testee
        testee_less_than_equal = LessThanEqual.new(NewInteger.new(0), NewInteger.new(0))
        # Test Equality
        assert_equal(true, testee_less_than_equal.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
        puts "  Testing GreaterThan:"           # GreaterThan Tests
        # Create testee
        testee_greater_than = GreaterThan.new(NewInteger.new(1), NewInteger.new(0))
        # Test Equality
        assert_equal(true, testee_greater_than.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
        puts "  Testing GreaterThanEqual:"      # GreaterThanEqual Tests
        # Create testee
        testee_greater_than_equal = GreaterThanEqual.new(NewInteger.new(0), NewInteger.new(0))
        # Test Equality
        assert_equal(true, testee_greater_than_equal.evaluate(@enviornment).value, 
                        "Failed Equality Test");
        puts
    end

    def test_Bitwise_Operations
        puts 
        puts "----------~ Testing Bitwise Operations ~---------------"
        puts
        puts "  Testing BitwiseNot:"            # BitwiseNot Tests
        # Create testee
        testee_bitwise_not = BitwiseNot.new(NewInteger.new(1))
        # Test Evaluate Equality
        assert_equal(-2, testee_bitwise_not.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseNot.new(NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseNot.new(NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseNot.new(NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing BitwiseAnd:"            # BitwiseAnd Tests
        # Create testee
        testee_bitwise_and = BitwiseAnd.new(NewInteger.new(4), NewInteger.new(6))
        # Test Evaluate Equality
        assert_equal(4, testee_bitwise_and.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseAnd.new(NewInteger.new(4), NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseAnd.new(NewInteger.new(4), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseAnd.new(NewInteger.new(4), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing BitwiseOr:"             # BitwiseOr Tests
        # Create testee
        testee_bitwise_or = BitwiseOr.new(NewInteger.new(4), NewInteger.new(6))
        # Test Evaluate Equality
        assert_equal(6, testee_bitwise_or.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseOr.new(NewInteger.new(4), NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseOr.new(NewInteger.new(4), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseOr.new(NewInteger.new(4), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing BitwiseXor:"            # BitwiseXor Tests
        # Create testee
        testee_bitwise_xor = BitwiseXor.new(NewInteger.new(4), NewInteger.new(6))
        # Test Evaluate Equality
        assert_equal(2, testee_bitwise_xor.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseXor.new(NewInteger.new(4), NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseXor.new(NewInteger.new(4), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseXor.new(NewInteger.new(4), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing BitwiseLeftShift:"       # BitwiseLeftShift Tests
        # Create testee
        testee_bitwise_left_shift = BitwiseLeftShift.new(NewInteger.new(4), NewInteger.new(1))
        # Test Evaluate Equality
        assert_equal(8, testee_bitwise_left_shift.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseLeftShift.new(NewInteger.new(4), NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseLeftShift.new(NewInteger.new(4), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseLeftShift.new(NewInteger.new(4), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
        puts "  Testing BitwiseRightShift:"      # BitwiseRightShift Tests
        # Create testee
        testee_bitwise_right_shift = BitwiseRightShift.new(NewInteger.new(4), NewInteger.new(1))
        # Test Evaluate Equality
        assert_equal(2, testee_bitwise_right_shift.evaluate(@enviornment).value, 
                        "Failed Equality Test")
        # Test Typechecking
        begin BitwiseRightShift.new(NewInteger.new(4), NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseRightShift.new(NewInteger.new(4), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin BitwiseRightShift.new(NewInteger.new(4), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        puts
    end

    def test_Casting_Operators
        puts
        puts "----------~ Testing Casting Operators ~---------------"
        puts
        puts "  Testing FloatToInt:"            # FloatToInt Tests
        # Create testee
        testee_float_to_int = FloatToInt.new(NewFloat.new(2.2))
        # Test conversion
        assert_equal(true, testee_float_to_int.evaluate(@enviornment).is_a?(NewInteger),
                        "Failed Conversion Test")
        assert_equal(2.0, testee_float_to_int.evaluate(@enviornment).value,
                        "Failed Evaluate Test")
        # Test typechecking
        begin FloatToInt.new(NewInteger.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin FloatToInt.new(NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin FloatToInt.new(NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end             
        puts
        puts "  Testing IntToFloat:"            # IntToFloat Tests
        # Create testee
        testee_int_to_float = IntToFloat.new(NewInteger.new(2))
        # Test conversion
        assert_equal(true, testee_int_to_float.evaluate(@enviornment).is_a?(NewFloat),
                        "Failed Evaluate Test")
        # Test typechecking
        begin IntToFloat.new(NewFloat.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin IntToFloat.new(NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end
        begin IntToFloat.new(NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => error
            puts "        Type Checking: Successful"
        end  
        puts
    end

    def test_Satistical_Functions
        # add cells needed for testing
        @grid.place(create_address(0,1), NewInteger.new(0));
        puts
        puts "----------~ Testing Statistical Functions ~---------------"
        puts
        puts "  Testing Max:"                   # Max Tests
        # Create testee
        testee_max = Max.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,1)))
        # Test evaluate
        assert_equal(4, testee_max.evaluate(@enviornment).value, "Failed Evaluate Test")
        # Test Index error
        begin Max.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(-1,0))).evaluate(@enviornment)
            puts "        BadIndex Checking: FAILED"
        rescue IndexError => exception
            puts "        BadIndex Checking: Successful"
        end
        # Test Typechecking
        begin Max.new(Lvalue.new(create_address(0,0)), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Max.new(Lvalue.new(create_address(0,0)), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Max.new(Lvalue.new(create_address(0,0)), NewInteger.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Max.new(Lvalue.new(create_address(0,0)), NewFloat.new(0.0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        # Test uninitialized cell within range
        begin Max.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,2))).evaluate(@enviornment)
            puts "        Uninitialized Cell Checking: FAILED"
        rescue
            puts "        Uninitialized Cell Checking: Successful"
        end
        puts
        puts "  Testing Min:"                   # Min Tests
        # Create testee
        testee_min = Min.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,1)))
        # Test evaluate
        assert_equal(0, testee_min.evaluate(@enviornment).value, "Failed Evaluate Test")
        # Test Index error
        begin Min.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(-1,0))).evaluate(@enviornment)
            puts "        BadIndex Checking: FAILED"
        rescue IndexError => exception
            puts "        BadIndex Checking: Successful"
        end
        # Test Typechecking
        begin Min.new(Lvalue.new(create_address(0,0)), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Min.new(Lvalue.new(create_address(0,0)), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Min.new(Lvalue.new(create_address(0,0)), NewInteger.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Min.new(Lvalue.new(create_address(0,0)), NewFloat.new(0.0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        # Test uninitialized cell within range
        begin Min.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,2))).evaluate(@enviornment)
            puts "        Uninitialized Cell Checking: FAILED"
        rescue
            puts "        Uninitialized Cell Checking: Successful"
        end
        puts
        puts "  Testing Mean:"                  # Mean Tests
        # Create testee
        testee_mean = Mean.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,1)))
        # Test evaluate
        assert_equal(2, testee_mean.evaluate(@enviornment).value, "Failed Evaluate Test")
        # Test Index error
        begin Mean.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(-1,0))).evaluate(@enviornment)
            puts "        BadIndex Checking: FAILED"
        rescue IndexError => exception
            puts "        BadIndex Checking: Successful"
        end
        # Test Typechecking
        begin Mean.new(Lvalue.new(create_address(0,0)), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Mean.new(Lvalue.new(create_address(0,0)), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Mean.new(Lvalue.new(create_address(0,0)), NewInteger.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Mean.new(Lvalue.new(create_address(0,0)), NewFloat.new(0.0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        # Test uninitialized cell within range
        begin Mean.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,2))).evaluate(@enviornment)
            puts "        Uninitialized Cell Checking: FAILED"
        rescue
            puts "        Uninitialized Cell Checking: Successful"
        end
        puts
        puts "  Testing Sum:"                   # Sum Tests
        # Create testee
        testee_sum = Sum.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,1)))
        # Test evaluate
        assert_equal(4, testee_sum.evaluate(@enviornment).value, "Failed Evaluate Test")
        # Test Index error
        begin Sum.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(-1,0))).evaluate(@enviornment)
            puts "        BadIndex Checking: FAILED"
        rescue IndexError => exception
            puts "        BadIndex Checking: Successful"
        end
        # Test Typechecking
        begin Sum.new(Lvalue.new(create_address(0,0)), NewBoolean.new(true)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Sum.new(Lvalue.new(create_address(0,0)), NewString.new("Hi")).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Sum.new(Lvalue.new(create_address(0,0)), NewInteger.new(0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        begin Sum.new(Lvalue.new(create_address(0,0)), NewFloat.new(0.0)).evaluate(@enviornment)
            puts "        Type Checking: FAILED"
        rescue TypeError => exception
            puts "        Type Checking: Successful"
        end
        # Test uninitialized cell within range
        begin Sum.new(Lvalue.new(create_address(0,0)), Lvalue.new(create_address(0,2))).evaluate(@enviornment)
            puts "        Uninitialized Cell Checking: FAILED"
        rescue
            puts "        Uninitialized Cell Checking: Successful"
        end
        puts
    end
end

# State of grid !!WITHIN MODEL_TESTER!!
# [x, y] = value (ints for simplicity)
# [0, 0] = 4
# [0, 1] = 0
# [0, 2] = nil   (intentionally left uninitialized for nil testing)

def run_tests(testee)
    testClass = testee.new
    methods = testClass.methods
    testMethods = methods.filter { |name| name.to_s.include? "test_" }
    testMethods.each { |method| testClass.send(method) }
    puts
end 
run_tests(ModelTester)

puts "----------~ Dynamic Testing ~---------------"
# Construct Grid and Enviornment
grid = Grid.new()
enviornment = Enviornment.new(grid)

# Demonstrace putting an Add expression in and out
grid.place(create_address(0,0), Add.new(NewInteger.new(2), NewInteger.new(2)))
p enviornment.evaluate(create_address(0,0))

# Demonstrate putting a Casting expression in and out
grid.place(create_address(5,5), FloatToInt.new(NewFloat.new(6.4)))
p enviornment.evaluate(create_address(5,5))

# Demonstrate that cell references work
p enviornment.evaluate(Lvalue.new(create_address(5,5)))
p Rvalue.new(create_address(5,5)).evaluate(enviornment)
puts