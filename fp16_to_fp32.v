module fp16_to_fp32(input [15:0] h, output [31:0] s);
  wire sign=h[15]; wire [4:0] eh=h[14:10]; wire [9:0] fh=h[9:0];
  wire is_den = (eh==0);
  wire is_inf = (eh==5'h1F) && (fh==0);
  wire is_nan = (eh==5'h1F) && (fh!=0);
  wire [7:0] e = is_den ? 8'd0 : (eh - 5'd15 + 8'd127);
  wire [22:0] f = {fh,13'd0};
  assign s = is_nan ? 32'h7FC0_0000 :
             is_inf ? {sign,8'hFF,23'd0} :
                      {sign,e,f};
endmodule