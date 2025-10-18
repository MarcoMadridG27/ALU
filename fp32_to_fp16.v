module fp32_to_fp16(input [31:0] s, output [15:0] h);
  wire sign=s[31]; wire [7:0] es=s[30:23]; wire [22:0] fs=s[22:0];
  wire is_den = (es==0);
  wire is_inf = (es==8'hFF) && (fs==0);
  wire is_nan = (es==8'hFF) && (fs!=0);
  wire [4:0] e = is_den ? 5'd0 : (es - 8'd127 + 5'd15);
  wire [9:0] f = fs[22:13]; // sin rounding aquí (puedes añadirlo)
  assign h = is_nan ? 16'h7E00 :
             is_inf ? {sign,5'h1F,10'd0} :
                      {sign,e,f};
endmodule