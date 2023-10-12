module floating_point_tanh #(parameter
DATA_WIDTH = 32,
M = 23,
E = 8
) (
input wire                   tanh_enable,
input wire  [DATA_WIDTH-1:0] in,
output wire [DATA_WIDTH-1:0] out   //// tanhx = 2f(2x) -1 ,, where f(x) = sigmoid (x)
);
////////////////////// internal signals 
wire [DATA_WIDTH-1:0] two_with_zero_fraction ; /// 2.000
wire [DATA_WIDTH-1:0] minus_one_with_zero_fraction ; // -1.000
wire [DATA_WIDTH-1:0] multiplied_input_by_two ; //2x
wire [DATA_WIDTH-1:0] out_from_floating_point_sigmoid ; // f(2x)
wire [DATA_WIDTH-1:0] multiplied_out_from_floating_point_sigmoid ; // 2f(2x)
wire [DATA_WIDTH-1:0] multiplied_out_from_floating_point_sigmoid_minus_one ; //2f(2x)-1
////////////////////////////////////////////////////////////

/////////////assignments////////////

assign two_with_zero_fraction = {1'b0 , 1'b1 , {(E-1){1'b0}} , {M{1'b0}}}  ;  //2.00000
assign minus_one_with_zero_fraction = {1'b1 , 1'b0 , {(E-1){1'b1}}, {M{1'b0}} }  ;     //-1.0000  
assign out = (tanh_enable) ? multiplied_out_from_floating_point_sigmoid_minus_one :  in ;

/////////////////////////////////////////////////////////////////////////////////
//////// INSTANTIATIONS //////////////////////////

floating_point_sigmoid #( //f(2x)
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)
) floating_point_sigmoid_inst (
.sigmoid_enable(tanh_enable),
.in(multiplied_input_by_two),
.out(out_from_floating_point_sigmoid)
);
/////////////////////////////////////////////////////////////////////////////////////////////////

floating_point_mul #(   // 2x
 .DATA_WIDTH(DATA_WIDTH), 
 .M(M), 
 .E(E)

 ) f_p_mul_insta_1 (
.in1(in),
.in2(two_with_zero_fraction),
.out(multiplied_input_by_two)
 );

  floating_point_mul #(   // 2f(2x)
 .DATA_WIDTH(DATA_WIDTH), 
 .M(M), 
 .E(E)

 ) f_p_mul_insta_2 (
.in1(out_from_floating_point_sigmoid),
.in2(two_with_zero_fraction),
.out(multiplied_out_from_floating_point_sigmoid)
 );



/////////////////////////////////////////////////////////////////////////////////////////////////

floating_point_adder #(  // 2f(2x) - 1
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)


) f_p_adder_insta_1 (
 .in1(multiplied_out_from_floating_point_sigmoid),
 .in2(minus_one_with_zero_fraction),
 .out(multiplied_out_from_floating_point_sigmoid_minus_one)
);



endmodule