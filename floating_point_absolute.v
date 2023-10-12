module floating_point_absolute #(parameter
DATA_WIDTH = 5
) 
(
    ///////////// INPUT/OUTPUT PORTS DECLARATION
input  wire [DATA_WIDTH-1:0] x,
output wire [DATA_WIDTH-1:0] abs_x
);
///////////////// INTERNAL SIGNALS ///////////////
wire                  sign_bit ;

//////////////////////////////////////////////assignment statements//////////////////
assign sign_bit = x [DATA_WIDTH-1] ;
assign abs_x = sign_bit ? {!x[DATA_WIDTH-1],x[DATA_WIDTH-2:0]} : x ;


endmodule