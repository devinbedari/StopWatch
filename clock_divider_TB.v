`timescale 10ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:58:27 05/05/2016
// Design Name:   clock_divider
// Module Name:   C:/Users/User/Documents/Classes/CS M152a/Lab4/clock_divider_tb.v
// Project Name:  Lab4
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clock_divider_tb;

	// Inputs
	reg rst;
	reg clk;

	// Outputs
	wire clk_1hz;
	wire clk_2hz;
	wire clk_4hz;
	wire clk_50hz;

	// Instantiate the Unit Under Test (UUT)
	clock_divider uut (
		.rst(rst), 
		.clk(clk), 
		.clk_1hz(clk_1hz), 
		.clk_2hz(clk_2hz), 
		.clk_4hz(clk_4hz), 
		.clk_50hz(clk_50hz)
	);

	initial begin
		// Initialize Inputs
		rst = 0;
		clk = 0;
		//Initialize Outputs
		/*clk_1hz = 0;
		clk_2hz = 0;
		clk_4hz = 0;
		clk_50hz = 0;*/
		// Wait 100 ns for global reset to finish
		#10;
        
		// Add stimulus here
		rst = 1;
		#10
		rst = 0;
		//#100000
		//$finish;
	end
      
	always 
	begin
	#1 clk <= ~clk;
	end
endmodule

