`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:00:19 05/10/2016 
// Design Name: 
// Module Name:    display_digit 
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
module display_digit(input [1:0] select,
    input [3:0] digit_val,
    input dp,
	 input src_clk,
	 //input src_rst,
	 output reg [3:0]anode,
	 output reg [7:0]segment
    );
	
	always @ (posedge src_clk)
	begin
		// anode
		case(select)
			0:	anode <= 4'b1110;
			1: anode <= 4'b1101;
			2: anode <= 4'b1011;
			default: anode <= 4'b0111;
		endcase
				
		//cathodes
		case(digit_val)
			0:	segment <= 8'b11000000;//8'b00000011; // DP CG CF CE CD CC CB CA 
			1:	segment <= 8'b11111001;//8'b10011111;
			2:	segment <= 8'b10100100; //8'b00100011;
			3:	segment <= 8'b10110000;//8'b00001101;
			4:	segment <= 8'b10011001;//8'b10011101;
			5:	segment <= 8'b10010010; //8'b01001001;
			6:	segment <= 8'b10000010; //8'b01000001;
			7:	segment <= 8'b11111000; //8'b00011111;
			8:	segment <= 8'b10000000;//8'b00000001;
			default: segment <= 8'b10011000;//8'b00011001;
		endcase	
		
		// Set decimal point
		segment[7] <= ~dp;
		
		
		/*
		// Reset?
		if(src_rst) 
		begin
			segment <= 8'b11000000;//8'b00000011;
		end
		else
		begin
			// Code goes here
		end
		*/
	end
endmodule
