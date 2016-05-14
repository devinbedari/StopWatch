`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:39:53 05/10/2016 
// Design Name: 
// Module Name:    stopwatch 
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
module stopwatch(
	 btnS,
	 btnR,
	 sw,
    clk,
	 an,
	 seg,
	 Led,
	 LedA,
	 LedB
    );

input btnS;
input btnR;
output reg [2:0] Led;
output reg [1:0] LedA;
output reg LedB;
input [2:0] sw;
input clk;
output reg [3:0] an;
output reg [7:0] seg;

//////////////////////////////////////////////////////////////////////////////////
//                               Initialize Reset                               //
//////////////////////////////////////////////////////////////////////////////////
reg rst;
initial 
begin 
rst <= 0;
end

//////////////////////////////////////////////////////////////////////////////////
//                            Initial Four Hz Clock                             //
//////////////////////////////////////////////////////////////////////////////////
wire init_fourHz;
initFourHz initfourhz(.src_rst(rst), .src_clk(clk), .clk_out(init_fourHz));

///////////////////////////////////////////////////////////////////////////////////
//                               Debouncing PushButtons                          //
///////////////////////////////////////////////////////////////////////////////////
wire rst_db;
// Debounce the center button
Debouncer d1(.button(btnS), .src_clk(init_fourHz), .deb_sig(rst_db));

// Debounce the right button
wire btnR_db;
Debouncer d2(.button(btnR), .src_clk(init_fourHz), .deb_sig(btnR_db));

always @ (posedge clk)
begin
	rst <= btnS; //rst_db;
	LedA[1] <= rst;
end

wire oneHz, twoHz, fourHz, fiftyHz;
clock_divider ckdv(.reset(rst), .src_clk(clk), .clk_1hz(oneHz), .clk_2hz(twoHz), .clk_4hz(fourHz), .clk_50hz(fiftyHz));

///////////////////////////////////////////////////////////////////////////////////
//                                Setting Pause Value                            //
///////////////////////////////////////////////////////////////////////////////////
reg pause;

always @ (posedge clk)
begin
	// Set pause to 0 on reset
	if(rst)
		pause <= 0;
	else	// Set pause to the opposite of what it is, when pause is pressed
	begin
		pause <= btnR_db;
		LedA[0] <= pause;
	end
end 

///////////////////////////////////////////////////////////////////////////////////
//                                  Debugging LEDs                               //
///////////////////////////////////////////////////////////////////////////////////
always @ (posedge clk)
begin
	Led[0] = sw[0];
	Led[1] = sw[1];
	Led[2] = sw[2];
end 

//////////////////////////////////////////////////////////////////////////////////
//                                 Implementation                               //
//////////////////////////////////////////////////////////////////////////////////
wire [3:0] s_units;
wire [3:0] s_tens;
wire [3:0] m_units;
wire [3:0] m_tens;
reg [11:0] secs;

initial begin
secs <= 0;
end
 
// Store the counter's values in a wire
// wire [3:0] cnt_val_one;
// wire [3:0] cnt_val_two;
// modulo10_counter mtc_one(.src_rst(rst), .src_clk(oneHz), .out(cnt_val_one));
// modulo10_counter mtc_two(.src_rst(rst), .src_clk(twoHz), .out(cnt_val_two));

// Check mode and clock speed
wire clk_speed;
assign clk_speed = ((sw[0] == 1 && sw[1] == 0) ? twoHz : oneHz);

// Count Up
always @ (posedge clk_speed)
begin
	// Reset
	if (rst)
	begin
		secs <= 0;
		LedB <= 1;
	end
	// Regular clock mode
	else if (sw[0] == 0 && sw[0] == 0 && pause == 0)
	begin
		// 3600 seconds have elapsed
		if (secs == 3600)
		begin
			secs <= 0;
			LedB <= 0;
		end
		// Otherwise increment by one
		else
		begin
			secs <= secs + 12'd1;
			LedB <= 0;
		end
	end
	// Adjustment Mode
	else if (sw[0] == 1 && sw[1] == 0 && pause == 0)
	begin
		// 3600 or more seconds have elapsed
		if (secs >= 3600)
		begin
			secs <= secs - 3600;
			LedB <= 0;
		end
		// Otherwise increment by one
		else
		begin
			// minute mode?
			if(sw[2] == 0)
			begin
				secs <= secs + 12'd60;
				LedB <= 0;
			end
			// seconds mode?
			else
			begin
				secs <= secs + 12'd1;
				LedB <= 0;
			end
		end
	end
	// Countdown mode
	else if (sw[0] == 0 && sw[1] == 1 && pause == 0 )
	begin
		LedB <= 1;
		if (secs == 0)
		begin
			secs <= 3600;
			//LedB <= 0;
		end
		else
		begin
			secs <= secs - 12'd1;
			//LedB <= 0;
		end
	end
	// Pause
	else
	begin
		secs <= secs;
	end
end

digitDivider digDiv(.src_clk(clk), .src_rst(rst) ,.seconds(secs),.sec_u(s_units),.sec_t(s_tens),.min_u(m_units),.min_t(m_tens));

//////////////////////////////////////////////////////////////////////////////////
//                               Display 7-Segment                              //
//////////////////////////////////////////////////////////////////////////////////

// Assign the digit_value register with the correct data
reg [3:0] digit_value [0:3];

always @ (posedge clk)
begin
	if(rst)
	begin 
		digit_value[0] <= 4'd0;
		digit_value[1] <= 4'd0;
		digit_value[2] <= 4'd0;
		digit_value[3] <= 4'd0; 
	end
	else
	begin
		digit_value[0] <= s_units;
		digit_value[1] <= s_tens;
		digit_value[2] <= m_units;
		digit_value[3] <= m_tens; 
	end
end

// Set the digit to display
reg [1:0] digPos;	
reg decp;
always @ (posedge fiftyHz)
begin
	if ( rst )
	begin
		digPos <= 0;
		decp <= 0;
	end
	if (digPos == 1)
	begin
		decp <= 1;
		digPos <= digPos + 2'b01;
	end
	else
	begin
		decp <= 0;
		digPos <= digPos + 2'b01;
	end
end

// Set the seven segment display
wire [3:0]an_val;
wire [7:0]seg_val;
display_digit dispDig(.select(digPos), .digit_val(digit_value[digPos]), .dp(decp), .src_clk(fiftyHz), .src_rst(rst), .anode(an_val), .segment(seg_val));

// Assign anode and cathode values
always @ (posedge fiftyHz)
begin 
	an <= an_val;
	seg <= seg_val;
end

/*
//////////////////////////////////////////////////////////////////////////////////
//                                Implement Reset                               //
//////////////////////////////////////////////////////////////////////////////////

always @ (posedge clk)
begin
	rst <= rst_db;
	LedA[1] <= rst;
end
*/

endmodule
