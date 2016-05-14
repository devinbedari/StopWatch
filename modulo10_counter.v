`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:31:13 05/10/2016 
// Design Name: 
// Module Name:    modulo10_counter 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module modulo10_counter(
    input src_rst,
    input src_clk,
    output reg [3:0] out
    );

always @ (posedge src_clk)
begin
	if(src_rst)
	begin
		out <= 4'd0;
	end
	else if (out == 10) 
	begin
		out <= 4'd0;
	end
	else
		out <= out + 4'b1;
	begin
	end
end

endmodule
