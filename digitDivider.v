`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:58:31 05/13/2016 
// Design Name: 
// Module Name:    digitDivider 
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
module digitDivider(
    input src_clk,
    input src_rst,
    input [11:0] seconds,
    output reg [3:0] sec_u,
    output reg [3:0] sec_t,
    output reg [3:0] min_u,
    output reg [3:0] min_t
    );

reg [5:0] min;
reg [5:0] sec;
//reg [] div_sec;
//reg [] div_min;
always @ (posedge src_clk)
begin
	// Reset case
	if ( src_rst )
	begin 
		sec_u <= 0;
		sec_t <= 0;
		min_u <= 0;
		min_t <= 0;
	end
	// Otherwise
	else
	begin
		// Calculate the number of minutes in the seconds counter
		min <= seconds / 60;
		// Calculate the number of seconds
		sec <= seconds - (min * 60);
		// Assign the units and tens position for the minutes
		min_u <= min % 10;
		min_t <= min / 10;
		// Assign the units and tens position for the seconds
		sec_u <= sec % 10;
		sec_t <= sec / 10;
	end
end

endmodule
