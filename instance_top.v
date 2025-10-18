module instance_top(
    clk, reset, entry,result,flags,current_fsm_state
    );
    input clk;
    input reset;
    input [15:0] entry;
    
   
    output [15:0] result;
output [4:0] flags; // CORREGIDO: Ancho de [8:0] a [4:0]
output wire [3:0] current_fsm_state;
    wire op_enable;
    wire isResult;
    wire [1:0] partResult;
    wire alu_enable;
    wire showFlags;
    wire [3:0] fsm_state_internal;
mainfsm fsm_1(
        .clk(clk),
        .reset(reset),
        .entry(entry[2:0]),
        .op_enable(op_enable),
        .isResult(isResult),
        .partResult(partResult),
        .alu_enable(alu_enable),
        .showFlags(showFlags),
        .current_state(fsm_state_internal) // <-- Conecta la salida de la FSM
    );
    
    
    datapath dp(.clk(clk),
    .reset(reset),
    .entry(entry),
    .showFlags(showFlags),
    .op_enable(op_enable),
    .isResult(isResult),
    .partResult(partResult),
     .alu_enable(alu_enable),
     .result(result),.flags(flags),
     .fsm_state(fsm_state_internal));
    assign current_fsm_state = fsm_state_internal;
endmodule
