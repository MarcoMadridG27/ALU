`timescale 1ns / 1ps

// MÓDULO FPU (reemplaza a alu_fpu)
module fpu_unit (
    input wire [2:0]  opcode,  // MODIFICADO: 3 bits
    input wire [15:0] A1_d,
    input wire [15:0] A2_d,
    input wire [15:0] B1_d,
    input wire [15:0] B2_d,
    input wire [15:0] A1_b,    // Operando A para 16-bit
    input wire [15:0] A2_b,    // Operando B para 16-bit
    
    output wire [15:0] part_a,    // Resultado[31:16]
    output wire [15:0] part_b,    // Resultado[15:0]
    output wire [4:0]  fpu_flags  // MODIFICADO: 5 bits (solo FPU)
);

    // --- 1. Decodificación de Opcode ---
    wire is_16bit    = opcode[2];      // 0=32-bit, 1=16-bit
    wire [1:0] op_select = opcode[1:0];  // 00=add, 01=sub, 10=mul, 11=div

    // --- 2. Lógica de "Buffering" / Mux de Entradas ---
    // (Esta lógica no cambia)
    wire [31:0] SrcA, SrcB;
    assign SrcA = is_16bit ? {16'h0000, A1_b} : {A1_d, A2_d};
    assign SrcB = is_16bit ? {16'h0000, A2_b} : {B1_d, B2_d};

    // --- 3. Generación de Señales de Control FPU ---
    wire fpu_precision_signal = is_16bit;
    
    // FPUControl: 00/01 (ADD/SUB) -> 0
    //             10/11 (MUL/DIV) -> 1 
    // (Asumiendo que tu FPU interno maneja ADD/SUB con 0 y MUL/DIV con 1)
    wire fpu_control_signal   = op_select[1]; 

    // --- 4. Instanciación del FPU ---
    wire [31:0] fpu_result;
    wire [4:0]  fpu_flags_internal; // 5 bits

    // Instancia del FPU (versión nueva de 5 flags)
    fpu_new fpu_inst (
        .SrcA(SrcA),
        .SrcB(SrcB),
        .FPUControl(fpu_control_signal),
        .precision(fpu_precision_signal),
        .FPUResult(fpu_result),
        .FPUFlags(fpu_flags_internal) // 5 bits
    );

    assign part_a = is_16bit ? 16'h0000 : fpu_result[31:16];
    assign part_b = fpu_result[15:0]; // Siempre saca la parte baja

    // --- 7. Salida de Flags ---
    assign fpu_flags = fpu_flags_internal; // Salida directa de 5 bits

endmodule