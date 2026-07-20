module state_controller(reset, count, ns_light, ew_light, 
										  counter_rst);
		
	parameter green = 2'b00, yellow = 2'b01, red = 2'b10;
	
	parameter green_time = 4'd13, yellow_time = 2'd3; 
	
	parameter state1 = 2'b00, state2 = 2'b01, state3 = 2'b10, state4 = 2'b11;
	
	input reset;
	input [3:0] count;
	reg [1:0] state;
	
	output reg [1:0] ns_light;
	output reg [1:0] ew_light;
	
	output reg counter_rst;
	
	always @(count or reset)
		begin
			case (state)
				state1: 
				begin
					ns_light <= green;
					ew_light <= red;
					
					if ((count == green_time) && (reset == 1'b0))
						begin
							state <= state2;
							counter_rst <= 1'b1;
						end
				end
				
				state2:
				begin
					ns_light <= yellow;
					ew_light <= red;
					
					if (count == yellow_time)
						begin
							state <= state3;
						end
				end
				
				state3:
				begin
					ns_light <= red;
					ew_light <= green;
					
					if (count == green_time)
						begin
							state <= state4;
						end
				end
				
				state4:
				begin
					ns_light <= red;
					ew_light <= yellow;
					
					if (count == yellow_time)
						begin
							state <= state1;
						end
				end
				
				default:
				
				begin
					ns_light <= green;
					ew_light <= red;
					
					if ((count == green_time) && (reset == 1'b0))
						begin
							state <= state2;
							counter_rst <= 1'b1;
						end
				end
				
				endcase
		end
	
	
	
	
endmodule