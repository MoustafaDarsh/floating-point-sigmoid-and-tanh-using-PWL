module floating_point_sigmoid_for_positive_number #(parameter
DATA_WIDTH = 32,
M = 23,
E = 8
) (
    /// INPUT/OUTPUT PORTS DECLARATION
input  wire  [DATA_WIDTH-1:0] in,
output reg   [DATA_WIDTH-1:0] out_reg_for_positive_number
);
//// Internal signals///////////
wire [DATA_WIDTH-1:0] abs_x ; // |x|
wire [DATA_WIDTH-1:0] one_with_zero_fraction ; // 1.000...
wire [DATA_WIDTH-1:0] five_with_zero_fraction ; // 5.000...
wire [DATA_WIDTH-1:0] two_with_fraction ;  //2.375000...
wire [DATA_WIDTH-1:0] fraction_1 ;    // 0.03125
wire [DATA_WIDTH-1:0] fraction_2 ; // 0.125
wire [DATA_WIDTH-1:0] fraction_3 ; // 0.25
wire [DATA_WIDTH-1:0] fraction_4 ; // 0.5
wire [DATA_WIDTH-1:0] fraction_5 ; // 0.625
wire [DATA_WIDTH-1:0] fraction_6 ;  // 0.84375

/////////////////////////////////////////////////////////////

wire abs_x_greater_than_one_with_zero_fraction ; // |x| > 1.000 
wire abs_x_greater_than_two_with_fraction ; // |x| > 2.37500 
wire abs_x_smaller_than_five_with_zero_fraction ; // |x| < 5.000 
/////////////////////////////////////////////////////////////////////////////
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_1 ; // 0.03125 * |x|
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_2 ; // 0.125 * |x|
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_3 ; // 0.25 * |x|
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_1_plus_fraction_6 ; // 0.03125 * |x| + 0.84375
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_2_plus_fraction_5 ; // 0.125 * |x| + 0.625
wire [DATA_WIDTH-1:0] abs_x_multiplied_by_fraction_3_plus_fraction_4 ; // 0.25 * |x| + 0.5



 


/////////////////////////assignment & always blocks/////
assign one_with_zero_fraction = {1'b0 , 1'b0 , {(E-1){1'b1}}, {M{1'b0}} }  ;     //1.0000                                           
assign five_with_zero_fraction = {1'b0 , 1'b1 , {(E-2){1'b0}} , 1'b1  , 2'b01 , {(M-2){1'b0}}}  ;            // 5.0000                             
assign two_with_fraction = {1'b0 , 1'b1 , {(E-1){1'b0}} , 4'b0011 , {(M-4){1'b0}} }  ;  // 2.375000
assign fraction_1 =  { 1'b0 , 1'b0 , {(E-5){1'b1}} , 4'b1010 , {M{1'b0}}} ; // 0.03125
assign fraction_2 =  { 1'b0 , 1'b0 , {(E-3){1'b1}} , 2'b00 , {M{1'b0}}} ; // 0.125
assign fraction_3 =  { 1'b0 , 1'b0 , {(E-3){1'b1}} , 2'b01 , {M{1'b0}}} ; // 0.25
assign fraction_4 =  { 1'b0 , 1'b0 , {(E-2){1'b1}} , 1'b0 , {M{1'b0}}} ; // 0.5
assign fraction_5 =  { 1'b0 , 1'b0 , {(E-2){1'b1}} , 1'b0 , 2'b01 , {(M-2){1'b0}}} ; // 0.625
assign fraction_6 =  { 1'b0 , 1'b0 , {(E-2){1'b1}} , 1'b0 , 4'b1011 , {(M-4){1'b0}}} ;  // 0.84375


always @ (*)
begin
if ( abs_x_greater_than_two_with_fraction && abs_x_smaller_than_five_with_zero_fraction )  /// 2.375<=|x|<5
    begin
out_reg_for_positive_number = abs_x_multiplied_by_fraction_1_plus_fraction_6 ; // 0.03125 * |x| + 0.84375
    end
else if (abs_x_greater_than_one_with_zero_fraction && !abs_x_greater_than_two_with_fraction ) /// 1<=|x|<2.375
    begin
out_reg_for_positive_number = abs_x_multiplied_by_fraction_2_plus_fraction_5 ;  // 0.125 * |x| + 0.625
    end
else if (!abs_x_greater_than_one_with_zero_fraction)         /// 0<=|x|<1 
    begin
out_reg_for_positive_number = abs_x_multiplied_by_fraction_3_plus_fraction_4 ; // 0.25 * |x| + 0.5
    end
else // |x|>=5
    begin
out_reg_for_positive_number = one_with_zero_fraction ;
    end
    end

////////////////////////////////////////////
////////////// INSTANTIATIONS //////////////


floating_point_absolute #(.DATA_WIDTH(DATA_WIDTH)) floating_point_absolute_inst (
.x(in),
.abs_x(abs_x)
);

//////////////////////////////////////////////////////////////////////////////////////////


floating_point_comparator #(   /// |x| > 1.000 
 .DATA_WIDTH(DATA_WIDTH),
 .M(M), 
 .E(E)

) f_p_c_insta_1 (
.in1(abs_x),
.in2(one_with_zero_fraction),
.N1_larger_or_equal(abs_x_greater_than_one_with_zero_fraction)
);


floating_point_comparator #(  /// |x| > 2.37500 
 .DATA_WIDTH(DATA_WIDTH),
 .M(M), 
 .E(E)

) f_p_c_insta_2 (
.in1(abs_x),
.in2(two_with_fraction),
.N1_larger_or_equal(abs_x_greater_than_two_with_fraction)
);


floating_point_comparator #(   /// |x| < 5.000 
 .DATA_WIDTH(DATA_WIDTH),
 .M(M), 
 .E(E)

) f_p_c_insta_3 (
.in1(five_with_zero_fraction),
.in2(abs_x),
.N1_larger_or_equal(abs_x_smaller_than_five_with_zero_fraction)
);

//////////////////////////////////////////////////////////////////////////////////////////////////


 floating_point_mul #(   // 0.03125 * |x|
 .DATA_WIDTH(DATA_WIDTH), 
 .M(M), 
 .E(E)

 ) f_p_mul_insta_1 (
.in1(abs_x),
.in2(fraction_1),
.out(abs_x_multiplied_by_fraction_1)
 );

  floating_point_mul #(   // 0.125 * |x|
 .DATA_WIDTH(DATA_WIDTH), 
 .M(M), 
 .E(E)

 ) f_p_mul_insta_2 (
.in1(abs_x),
.in2(fraction_2),
.out(abs_x_multiplied_by_fraction_2)
 );


  floating_point_mul #(  // 0.25 * |x|
 .DATA_WIDTH(DATA_WIDTH), 
 .M(M), 
 .E(E)

 ) f_p_mul_insta_3 (
.in1(abs_x),
.in2(fraction_3),
.out(abs_x_multiplied_by_fraction_3)
 );

//////////////////////////////////////////////////////////////////////////////////////////////////



floating_point_adder #(  // 0.03125 * |x| + 0.84375
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)


) f_p_adder_insta_1 (
 .in1(abs_x_multiplied_by_fraction_1),
 .in2(fraction_6),
 .out(abs_x_multiplied_by_fraction_1_plus_fraction_6)
);

floating_point_adder #(   // 0.125 * |x| + 0.625
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)


) f_p_adder_insta_2 (  
 .in1(abs_x_multiplied_by_fraction_2),
 .in2(fraction_5),
 .out(abs_x_multiplied_by_fraction_2_plus_fraction_5)
);


floating_point_adder #(   // 0.25 * |x| + 0.5
 .DATA_WIDTH(DATA_WIDTH),
 .M(M),
 .E(E)


) f_p_adder_insta_3 (
 .in1(abs_x_multiplied_by_fraction_3),
 .in2(fraction_4),
 .out(abs_x_multiplied_by_fraction_3_plus_fraction_4)
);


//////////////////////////////////////////////////////////////////////////////////////////////////



endmodule