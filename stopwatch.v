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
	 input btnS,
	 input btnR,
	 input [2:0] sw,
    input clk,
	 output reg [3:0] an,
	 output reg [7:0] seg 
    );


///////////////////////////////////////////////////////////////////////////////////
//                               Debouncing PushButtons                          //
///////////////////////////////////////////////////////////////////////////////////

// Debounce the left button
wire rst;
Debouncer d1(.button(btnS), .src_rst(rst), .src_clk(clk), .deb_sig(rst));

// Debounce the right button
wire btnR_db;
Debouncer d2(.button(btnR), .src_rst(rst), .src_clk(clk), .deb_sig(btnR_db));

///////////////////////////////////////////////////////////////////////////////////
//                                Setting Pause Value                            //
///////////////////////////////////////////////////////////////////////////////////

reg pause;

always @ (posedge clk)
begin
	// Set pause to 0 on reset
	if(rst)
	begin
		pause <= 0;
	end
	
	// Set pause to the opposite of what it is, when pause is pressed
	if(btnR_db)
	begin
		pause <= ~pause;
	end
end 

//////////////////////////////////////////////////////////////////////////////////
//                             Clock Divider Output                             //
//////////////////////////////////////////////////////////////////////////////////
wire oneHz, twoHz, fourHz, fiftyHz;
clock_divider ckdv(.reset(rst), .src_clk(clk), .clk_1hz(oneHz), .clk_2hz(twoHz), .clk_4hz(fourHz), .clk_50hz(fiftyHz));

//////////////////////////////////////////////////////////////////////////////////
//                                 Implementation                               //
//////////////////////////////////////////////////////////////////////////////////
reg [3:0] s_units;
reg [3:0] s_tens;
reg [3:0] m_units;
reg [3:0] m_tens;

// Store the counter's values in a wire
wire [3:0] cnt_val_one;
wire [3:0] cnt_val_two;
modulo10_counter mtc_one(.src_rst(rst), .src_clk(oneHz), .out(cnt_val_one));
modulo10_counter mtc_two(.src_rst(rst), .src_clk(twoHz), .out(cnt_val_two));

// 1Hz clock segments
always @ (posedge clk)
begin

	// Reset sets all digits to zero
	if( rst )
	begin
		s_units <= 0;
		s_tens <= 0;
		m_units <= 0;
		m_tens <= 0;
	end
	
	// for adj = 0 implies normal stopwatch
	else if( sw[0] == 0 && sw[1] == 0 && pause == 0)
	begin
		// An hour is up; make all digits zero
		if (m_tens == 5 && m_units == 9 && s_tens == 5 && s_units == 9)
		begin
			m_tens <= 0;
			m_units <= 0;
			s_tens <= 0;
			s_units <= 0;
		end
			
		// x9:59 is done, where x!=5
		else if (m_units == 9 && s_tens == 5 && s_units == 9)
		begin
			m_tens <= m_tens + 4'b1;
			m_units <= 0;
			s_tens <= 0;
			s_units <= 0;
		end 
			
		// 0x:59 is done, where x!= 9
		else if (s_units == 9 && s_tens == 5)
		begin
			m_units <= m_units + 4'b1;
			s_tens <= 0;
			s_units <= 0;
		end
			
		// 00:x9 is done, where x!=5
		else if ( s_units == 9 )
		begin 
			s_tens <= s_tens + 4'b1;
			s_units <= 0;
		end
			
		// set the unit digits to 0
		else
		begin
			s_units <= cnt_val_one;
		end
	end
	
	// In adjust mode
	else if (sw[0] == 1 && sw[1] == 0 && pause == 0)
	begin
	
		// Up minutes 
		if(sw[2] == 0)
		begin
			// Set the at 59
			if(m_tens == 5 && m_units == 9)
			begin
				m_tens <= 0;
				m_units <= 0;
			end
			
			// At x9, where x!=5
			else if(m_units == 9)
			begin
				m_tens <= m_tens + 4'b1;
				m_units <= 0;
			end
			
			// Set the units to the counter values
			else
			begin
				m_units <= cnt_val_two;
			end
			
		end
		
		// Up seconds
		else
		begin
		
			// Set the at 59
			if(s_tens == 5 && s_units == 9)
			begin
				s_tens <= 0;
				s_units <= 0;
			end
			
			// At x9, where x!=5
			else if(s_units == 9)
			begin
				s_tens <= s_tens + 4'b1;
				s_units <= 0;
			end
			
			// Set the units place as per the module output
			else
			begin
				s_units <= cnt_val_two;
			end
			
		end
	end
	
	// Adj is in countdown mode
	else if ( sw[0] == 0 && sw[1] == 1 && pause == 0 )
	begin
		// 00:00 -> 59:59
		if (m_tens == 0 && m_units == 0 && s_tens == 0 && s_units == 0)
		begin
			m_tens <= 5;
			m_units <= 9;
			s_tens <= 5;
			s_units <= 9;
		end
			
		// x0:00 -> (x-1)9:59 for x!=0
		else if (m_units == 0 && s_tens == 0 && s_units == 0)
		begin
			m_tens <= m_tens - 4'b1;
			m_units <= 9;
			s_tens <= 5;
			s_units <= 9;
		end 
			
		// yx:00 -> y(x-1):59 for x!=0
		else if (s_units == 0 && s_tens == 0)
		begin
			m_units <= m_units - 4'b1;
			s_tens <= 5;
			s_units <= 9;
		end
		
		//zy:x0 -> zy:(x-1)9 for x!=0
		else if ( s_units == 0 )
		begin 
			s_tens <= s_tens - 4'b1;
			s_units <= 9;
		end
			
		// set the unit digits to 0
		else
		begin
			s_units <= 4'd9 - cnt_val_one;
		end
	end
	
	// Pause
	else
	begin
		s_units <= s_units;
		s_tens <= s_tens;
		m_units <= m_units;
		m_tens <= m_tens;
	end
end

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
	else if (digPos == 2)
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
endmodule
