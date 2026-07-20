module state_controller_tb;

	reg fsm_reset;
	reg [3:0] count;
	reg illegal;
	
	wire counter_rst;
	wire [1:0] ns_output;
	wire [1:0] ew_output;
	
	parameter green = 2'b00;
	parameter yellow = 2'b01;
	parameter red = 2'b10;
	
	
	
	state_controller #(
							.green(2'b00), 
							.yellow(2'b01),  
							.red(2'b10), 
							.green_time(4'd13), 
							.yellow_time(2'd3),
							.state1(2'b00),
							.state2(2'b01),
							.state3(2'b10),
							.state4(2'b11)
							)
	
	 machine (.reset(fsm_reset),
	 .count(count),
	 .ns_light(ns_output),
	 .ew_light(ew_output),
	 .counter_rst(counter_rst)
	);
	
	initial
		begin
			$dumpfile("state_controller_tb.vcd");
			$dumpvars(0,machine);
			$monitor("reset=%b count_reset=%b count=%d NS=%b EW=%b illegal=%b",fsm_reset, 
			counter_rst, count, ns_output, ew_output, illegal);
			
			#200 $finish;
		end
		
	initial
		begin
			count = 4'b0000;
			
			repeat(150)
				#1 count = count + 4'b0001;
			
		end
		
	initial 
		begin
			fsm_reset = 0;
			
			#20 fsm_reset = 1;
			#5 fsm_reset = 0;
			
			#40 fsm_reset = 1;
			#5 fsm_reset = 0;
		end
		
	initial
		begin	
		
			if ((ns_output == machine.green && (ew_output == machine.green || ew_output == machine.yellow)) 
			     || (ew_output == machine.green && (ns_output == machine.green || ns_output == machine.yellow)))
				begin
					illegal = 1;
					 $display("ERROR: illegal condition, both lanes open, ns is %b and ew is %b", ns_output, ew_output);
				end
			else illegal = 0;
				
			if (ns_output == machine.red && ew_output == machine.red)
				begin
					illegal = 1;
					 $display("ERROR: illegal condition, both lanes closed, ns is %b and ew is %b", ns_output, ew_output);
				end
			else	illegal = 0;
		end
	
	initial
		begin
		
			case (ns_output)
					2'b00:
						$display("North-South light is now green");
					
					2'b01:
						$display("North-South light is now yellow");
					
					2'b10:
						$display("North-South light is now red");
			endcase
				
			case (ew_output)
					2'b00:
						$display("East-West light is now green");
					
					2'b01:
						$display("East-West light is now yellow");
					
					2'b10:
						$display("East-West light is now red");
			endcase
				
		end
	
endmodule