module floating_point_comparator #(parameter
	           DATA_WIDTH = 10,
	           M = 5,
               E = 4)
    ( /// INPUT/OUTPUT Port declaration
    input      [DATA_WIDTH-1:0] in1,
    input      [DATA_WIDTH-1:0] in2,
    output wire                 N1_larger_or_equal                
    );

 /// Internal Signals
    wire sign1,sign2;

    wire [E-1:0] Exponent1 ;
    wire [E-1:0] Exponent2 ;

    wire [M:0] MantissaUnNORMALIZED1;
    wire [M:0] MantissaUnNORMALIZED2;
    
    wire EX1_greater_than_EX2;
    wire EX1_equal_EX2 ;
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////// ASSIGNMENT STATEMENTS///////////////////////////////////////////////////

    assign sign1 = in1[DATA_WIDTH-1];
    assign sign2 = in2[DATA_WIDTH-1];

    assign Exponent1 = in1[DATA_WIDTH-2:DATA_WIDTH-E-1];
    assign Exponent2 = in2[DATA_WIDTH-2:DATA_WIDTH-E-1];
    
    assign MantissaUnNORMALIZED1 = {1'b1, in1[M-1:0]};
    assign MantissaUnNORMALIZED2 = {1'b1, in2[M-1:0]};
    
    assign EX1_greater_than_EX2 = (Exponent1 > Exponent2);
    assign EX1_equal_EX2 = (Exponent1 == Exponent2); 
    

    // Determine which of in1 , in2 is larger using N1_larger_or_equal flag
    assign N1_larger_or_equal =    EX1_greater_than_EX2 ? 1'b1 : (EX1_equal_EX2 && (MantissaUnNORMALIZED1 >= MantissaUnNORMALIZED2)) ? 1'b1 : 1'b0;

/////////////////////////////////////////////////////////////////////////////////
endmodule