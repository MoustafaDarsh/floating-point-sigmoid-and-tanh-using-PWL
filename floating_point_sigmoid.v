module floating_point_sigmoid #(parameter
DATA_WIDTH = 32,
M = 23,
E = 8
) ( ///////// INPUT/OUTPUT PORTS DECLARATION
input wire                   sigmoid_enable,
input wire  [DATA_WIDTH-1:0] in,
output wire [DATA_WIDTH-1:0] out
);
/// INTERNAL SIGNALS
wire sign_bit;
wire  [DATA_WIDTH-1:0]  out_reg_for_positive_number ; ///f(|x|)
wire  [DATA_WIDTH-1:0]  minus_of_out_reg_for_positive_number ;  ///(-f(|x|))
wire  [DATA_WIDTH-1:0]  one_with_zero_fraction ; // 1.0000
wire  [DATA_WIDTH-1:0]  one_with_zero_fraction_minus_out_reg_for_positive_number ; // 1.000 - f(|x|)
wire  [DATA_WIDTH-1:0]  out_reg ;

////////////////assignment statements ///////////////////////////////////////////////////////
assign sign_bit = in [DATA_WIDTH-1] ;
assign one_with_zero_fraction = {1'b0 , 1'b0 , {(E-1){1'b1}}, {M{1'b0}} }  ;     //1.0000   
assign minus_of_out_reg_for_positive_number = {1'b1 , out_reg_for_positive_number [DATA_WIDTH-2:0]} ; ///(-f(|x|))
assign out_reg = (sign_bit)  ? one_with_zero_fraction_minus_out_reg_for_positive_number : out_reg_for_positive_number ;
assign out = (sigmoid_enable) ? out_reg : in ;

/////////////////////////////////////////////////////////////////////////////////////////////

///////////instantiations////////////

floating_point_sigmoid_for_positive_number #( // f(|x|)
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)
) 
floating_point_sigmoid_for_positive_number_insta 
(
.in(in),
.out_reg_for_positive_number(out_reg_for_positive_number)
);

////////////////////////////////////////////////////////////


floating_point_adder #(  // 1.00 - f(|x|)
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)

) f_p_adder_insta_1 (
 .in1(one_with_zero_fraction),
 .in2(minus_of_out_reg_for_positive_number),
 .out(one_with_zero_fraction_minus_out_reg_for_positive_number)
);


endmodule