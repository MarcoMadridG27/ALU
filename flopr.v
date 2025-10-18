module flopr (
	clk,
	reset,
	d,
	q
);
	parameter WIDTH = 8;
	input wire clk;
	input wire reset;
	input wire [WIDTH - 1:0] d;
	output reg [WIDTH - 1:0] q;

	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= {WIDTH {1'b0}}; // Reset to 0
		else
			q <= d;
	end
endmodule