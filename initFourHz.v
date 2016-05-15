`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:44 05/13/2016 
// Design Name: 
// Module Name:    fourHz 
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
module initFourHz(
    input src_rst,
    input src_clk,
    output reg clk_out
    );

reg [23:0] fourhz; 

always @ (posedge src_clk)
begin
	if(src_rst)
	begin
		fourhz <= 24'd0;
		clk_out <= 0;
	end
	else if (fourhz == 26'd6250000)
	begin
		fourhz <= 24'd0;
		clk_out <= ~clk_out;
	end
	else
		fourhz <= fourhz + 24'd1;	
end


endmodule

