`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:25:29 05/05/2016 
// Design Name: 
// Module Name:    clock_divider 
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
module clock_divider(
    input reset,
    input src_clk,
    output reg clk_1hz,  //count seconds
    output reg clk_2hz,  //stuff
    output reg clk_4hz,  //blinking seven segment display
    output reg clk_50hz  //multiplexing seven segment display
    );

reg [25:0] onehz; 
reg [24:0] twohz; 
reg [23:0] fourhz; 
reg [24:0] fiftyhz; 


always @ (posedge src_clk)
begin
	if(reset)
	begin
		onehz <= 26'd0;
		clk_1hz <= 0;
	end
	else if (onehz == 26'd50000000) //50000000
	begin
		onehz <= 26'd0;
		clk_1hz <= ~clk_1hz;
	end
	else
	begin
		onehz <= onehz + 26'd1;	
	end
end

always @ (posedge src_clk)
begin
	if(reset)
	begin
		twohz <= 25'd0;
		clk_2hz <= 0;
	end
	else if (twohz == 25'd25000000)
	begin
		twohz <= 25'd0;
		clk_2hz <= ~clk_2hz;
	end
	else
		twohz <= twohz + 25'd1;
end

always @ (posedge src_clk)
begin
	if(reset)
	begin
		fourhz <= 24'd0;
		clk_4hz <= 0;
	end
	else if (fourhz == 26'd12500000)
	begin
		fourhz <= 24'd0;
		clk_4hz <= ~clk_4hz;
	end
	else
		fourhz <= fourhz + 24'd1;	
end

always @ (posedge src_clk)
begin
	if(reset)
	begin
		fiftyhz <= 25'd0;
		clk_50hz <= 0;
	end
	else if (fiftyhz == 25'd1000000)
	begin
		fiftyhz <= 25'd0;
		clk_50hz <= ~clk_50hz;
	end
	else
		fiftyhz <= fiftyhz + 25'd1;	
end
endmodule
