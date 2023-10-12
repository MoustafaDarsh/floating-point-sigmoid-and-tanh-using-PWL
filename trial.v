module trial #(parameter
DATA_WIDTH = 32,
M=23,
E=8
)(
input  wire  [DATA_WIDTH-1:0] in,
output wire   [DATA_WIDTH-1:0] out_reg_for_positive_number
);


wire [DATA_WIDTH-1:0] fraction_1 ; 
wire [DATA_WIDTH-1:0] in_by_fraction_1 ; 

assign fraction_1 =  { 1'b0 , 1'b0 , {(E-5){1'b1}} , 4'b1010 , {M{1'b0}}} ; // 0.03125


floating_point_mul #(
.DATA_WIDTH(DATA_WIDTH),
.M(M), 
.E(E)


)floating_point_mul_insta (
.in1(in),
.in2(fraction_1),
.out(in_by_fraction_1)

);



floating_point_mul #(   // 0.03125 * |x|
 .DATA_WIDTH(DATA_WIDTH), 
 .M(E), 
 .E(M)

 ) f_p_mul_insta_1 (
.in1(in),
.in2(fraction_1),
.out(in_by_fraction_1)
 );
 
endmodule