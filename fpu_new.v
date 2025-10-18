// MÓDULO FPU (sin cambios)
// Este módulo selecciona entre fp16_new y fp32_new
module fpu_new (
    input  wire [31:0] SrcA,
    input  wire [31:0] SrcB,
    input  wire    FPUControl,
    input  wire        precision,  // 0 = FP32, 1 = FP16
    output wire [31:0] FPUResult,
    output wire [4:0]  FPUFlags   // 5 bits
);

    wire [31:0] out_fp32;
    wire [31:0] out_fp16;
    wire [4:0] Flags16;
    wire [4:0] Flags32;
    
    fp16_new fpu16_inst (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .FPUControl(FPUControl),
        .out_fp16(out_fp16),
        .Flags16(Flags16)
    );
    
    fp32_new fpu32_inst (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .FPUControl(FPUControl),
        .out_fp32(out_fp32),
        .Flags32(Flags32)
    );
    
    mux2 #(32) mux2fpu_inst (
        .d1(out_fp16), // precision=1
        .d0(out_fp32), // precision=0
        .s(precision),
        .y(FPUResult)
    );
    
    mux2 #(5) mux2Flags (
        .d1(Flags16),  // precision=1
        .d0(Flags32),  // precision=0
        .s(precision),
        .y(FPUFlags)
    );
        
endmodule
