`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:12:58 05/03/2016 
// Design Name: 
// Module Name:    d_ff 
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
module d_ff(
    input D,
	 input s_rst,
    input s_clk,
    output reg Q
    );

always @ (posedge s_clk)
	if(~s_rst)	
		Q <= 1'b0;
	else
		Q <= D;
endmodule
