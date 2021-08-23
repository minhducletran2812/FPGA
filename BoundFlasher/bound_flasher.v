	module bound_flasher (clk,rst,flick,lamps,stage);

		 input flick, clk, rst;
		 
		 output [15:0]	lamps	;
		 output [2:0]	stage	;

		 reg [2:0] state;
		 reg [15:0] led;

		
		 
		 
		 parameter 
		 S0 	= 	3'd0, 
		 S1 	= 	3'd1, 
		 S2 	= 	3'd2, 
		 S3 	= 	3'd3, 
		 S4 	= 	3'd4, 
		 S5 	= 	3'd5, 
		 S6 	= 	3'd6;
		// S7 	= 	3'd7;
		 
		 assign lamps 	= 	led;
		 assign stage 	= 	state;
		 
		 always @(posedge clk or negedge rst) 
		 begin
			if (!rst) 
				begin
					led = 0;
					state = S0;
				end
			
			else
			
			 case(state)
			 
				  S0:
				  //
				  begin
						led = 0;
						state =S0;
						//fixed 
						
						
						 if (flick == 1) 
						 begin
							  state = S1;
							  led = 1;
						 end

				  end

				  S1:
				  begin
						led = led*2 + 1; //turn on inital
						if (led[5] == 1) 
							state = S2;
				  end

				  S2:
				  begin
						led = (led >> 1); //binary right shift //turn off 5->0
						//ked [0:15] led 4'00001 -> led =led >>1 = 00000
						if (led[0] == 0) 
							state = S3; 
				  end

				  S3:
				  begin
						led = led*2 + 1; //turn on 0->10 normal flow

						if(led[10]==1) //normal flow end
							state =S4;

						if(flick==1)				// if flick on (not normal flow)
						begin
						
							if (led[10] == 1 && led[11] == 0) 
								state =S2;
								
							if(led[5] == 1 && led[6] == 0)
								state =S2;
						
						end
			
								
				  end

				  S4:
				  begin
						led=(led>>1); // gradually turn off 10->5
						if(led[5]==0) //normal flow always, flick dont effect
							state =S5;
				  end

				  S5:
				  begin
						led = led*2 + 1;
						if (led[15] == 1)  //normal flow 15 
							state = S6;
							
						if(flick==1)//flick on
						begin
							if(led[5] == 1 && led[6] == 0) 
								state = S4;
								
							if(led[10] == 1 && led[11] == 0)
								state=S4;
						end      
					

				  end

				  S6:
				  begin
						led = (led >> 1);
						 if (led[0] == 0)
							state = S0; 
				  end

				  
			 endcase
		 end

	endmodule 

