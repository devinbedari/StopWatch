
/*
// 1Hz clock segments
always @ (posedge clk)
begin
	LedB <= 0;
	// Reset sets all digits to zero
	if( rst )
	begin
		LedB <= 1;
		s_units <= 0;
		s_tens <= 0;
		m_units <= 0;
		m_tens <= 0;
	end
	// for adj = 0 implies normal stopwatch
	else if( sw[0] == 0 && sw[1] == 0 && pause == 0)
	begin
		// An hour is up; make all digits zero
		if (m_tens == 6 && m_units == 10 && s_tens == 6 && s_units == 10)
		begin
			m_tens <= 0;
			m_units <= 0;
			s_tens <= 0;
			s_units <= 0;
		end
			
		// x9:59 is done, where x!=5
		else if (m_tens != 6 && m_units == 10 && s_tens == 6 && s_units == 10)
		begin
			m_tens <= m_tens + 4'b1;
			m_units <= 0;
			s_tens <= 0;
			s_units <= 0;
		end 
			
		// 0x:59 is done, where x!= 9
		else if (m_tens != 6 && m_units != 10 && s_units == 10 && s_tens == 6)
		begin
			m_units <= m_units + 4'b1;
			s_tens <= 0;
			s_units <= 0;
		end
			
		// 00:x9 is done, where x!=5
		else if ( m_tens != 6 && m_units != 10 && s_tens != 6 && s_units == 10)
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
*/