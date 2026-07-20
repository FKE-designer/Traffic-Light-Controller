`timescale 1 ms/1 ns

module counter_tb;
	
	reg clk;
	reg reset;
	wire [3:0] count;
	
	counter DUT(.clk(clk),.reset(reset),.count(count));
	
	initial
		begin
			forever
			 begin
				#1 clk = !clk;
			 end


		end

	initial
		begin
			$dumpfile("counter.vcd");
			$dumpvars(0,DUT);
			$monitor("clk=%b count=%d reset=%b",clk,count,reset);
			
			clk = 1'b0;
			reset = 1'b1;
			#1 reset = 1'b0;
									
			#5 reset = 1'b1;
			#5 reset = 1'b0;
			
				
			#100$finish;
		
		end

endmodule