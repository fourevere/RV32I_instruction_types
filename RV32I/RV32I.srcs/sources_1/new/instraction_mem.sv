`timescale 1ns / 1ps

module instraction_mem (  //instruction
    input  logic [31:0] instr_addr,
    output logic [31:0] instr_code
);

    logic [31:0] instr_rom[0:127];
    initial begin
        instr_rom[0] = 32'h0080_056F;  
        instr_rom[1] = 32'h0000_006F; 
        instr_rom[2] = 32'h0000_006F; 
    end
`ifdef TEST_SIMULATION
    initial begin
        $readmemh("instruction_mem_sort.mem", instr_rom);
    end
    // initial begin
    //     $readmemh("instruction_code.mem", instr_rom);
    // end
`endif
    assign instr_code = instr_rom[instr_addr[31:2]];
endmodule








