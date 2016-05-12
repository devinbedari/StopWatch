`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:06:16 05/03/2016 
// Design Name: 
// Module Name:    Debouncer 
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
module Debouncer(
    input button,
	 input src_rst,
	 input src_clk,
    output deb_sig
    );

wire q0, q1, q2;
d_ff d0(.D(button), .s_rst(src_rst), .s_clk(src_clk), .Q(q0));
d_ff d1(.D(q0), .s_rst(src_rst), .s_clk(src_clk), .Q(q1));
d_ff d2(.D(q1), .s_rst(src_rst), .s_clk(src_clk), .Q(q2));

assign deb_sig = q0 & q1 & ~q2;
	
endmodule
