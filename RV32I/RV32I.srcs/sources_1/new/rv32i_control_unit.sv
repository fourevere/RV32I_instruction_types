`timescale 1ns / 1ps
`include "define.vh"

module rv32i_control_unit (
    input  logic [31:0] instr_code,
    output logic        rf_we,
    output logic        branch,
    output logic        jal,
    output logic        jalr,
    output logic        alusrc_sel,
    output logic [ 3:0] alu_control,
    output logic [ 2:0] rfsrc_sel,
    output logic [ 2:0] mem_mode,
    output logic        dwe
);

    logic [6:0] funct7;
    logic [2:0] funct3;
    logic [6:0] opcode;

    assign opcode = instr_code[6:0];
    assign funct3 = instr_code[14:12];
    assign funct7 = instr_code[31:25];


    // [DEBUG]
    typedef enum logic [6:0] {
        DBG_R_TYPE  = `R_TYPE,
        DBG_S_TYPE  = `S_TYPE,
        DBG_IL_TYPE = `IL_TYPE,
        DBG_I_TYPE  = `I_TYPE,
        DBG_B_TYPE  = `B_TYPE,
        DBG_UL_TYPE = `UL_TYPE,
        DBG_UA_TYPE = `UA_TYPE,
        DBG_J_TYPE  = `J_TYPE,
        DBG_JL_TYPE = `JL_TYPE
    } opcode_dbg_e;

    opcode_dbg_e opcode_dbg;
    assign opcode_dbg = opcode_dbg_e'(opcode);

    //r_type
    typedef enum logic [3:0] { 
        DBG_ADD = `ADD,
        DBG_SUB = `SUB,
        DBG_SLL = `SLL,
        DBG_SLT = `SLT,
        DBG_SLTU = `SLTU,
        DBG_XOR = `XOR,
        DBG_SRL = `SRL,
        DBG_SRA = `SRA,
        DBG_OR = `OR,
        DBG_AND = `AND,
        NONE_DBG_R = 4'b1111

    } r_type_dbg_e;
    r_type_dbg_e r_type_dbg;
    //assign r_type_dbg = r_type_dbg_e'(alu_control);
    assign r_type_dbg = (opcode == `R_TYPE) ? r_type_dbg_e'(alu_control) : NONE_DBG_R;

    //i-type
    typedef enum logic [3:0] { 
        DBG_ADDI = `ADD,
        DBG_SUBI = `SUB,
        DBG_SLLI = `SLL,
        DBG_SLTI = `SLT,
        DBG_SLTIU = `SLTU,
        DBG_XORI = `XOR,
        DBG_SRLI = `SRL,
        DBG_SRAI = `SRA,
        DBG_ORI = `OR,
        DBG_ANDI = `AND,
        NONE_DBG_I = 4'b1111

    } i_type_dbg_e;
    i_type_dbg_e i_type_dbg;
    assign i_type_dbg = (opcode == `I_TYPE) ? i_type_dbg_e'(alu_control) : NONE_DBG_I;
    //assign i_type_dbg = i_type_dbg_e'(alu_control && opcode == `I_TYPE);

    //s-type
    typedef enum logic [3:0] { 
        DBG_SB = `SB,
        DBG_SH = `SH,
        DBG_SW = `SW,
        NONE_DBG_S = 4'b1111
    } s_type_dbg_e;
    s_type_dbg_e s_type_dbg;
    assign s_type_dbg = (opcode == `S_TYPE) ? s_type_dbg_e'(mem_mode) : NONE_DBG_S;

    always_comb begin
        rf_we = 0;
        branch = 0;
        jal = 0;
        jalr = 0;
        alusrc_sel = 0;
        alu_control = 0;
        rfsrc_sel = 3'b0;
        mem_mode = 3'b0;
        dwe = 0;
        case (opcode)
            `R_TYPE: begin
                rf_we = 1'b1;
                branch = 0;
                jal = 0;
                jalr = 0;
                alusrc_sel = 0;
                alu_control = {funct7[5], funct3};
                rfsrc_sel = 0;
                mem_mode = 3'b0;
                dwe = 0;
            end
            `S_TYPE: begin
                rf_we = 1'b0;
                branch = 0;
                jal = 0;
                jalr = 0;
                alusrc_sel = 1'b1;
                alu_control = `ADD;
                rfsrc_sel = 0;
                mem_mode = funct3;
                dwe = 1;
            end
            `IL_TYPE: begin
                rf_we = 1'b1;  //load
                branch = 0;
                jal = 0;
                jalr = 0;
                alusrc_sel = 1'b1;  //rs1 + imm
                alu_control = `ADD;
                rfsrc_sel = 1;  
                mem_mode = funct3;
                dwe = 0;  
            end
            `I_TYPE: begin
                rf_we = 1'b1; 
                branch = 0;
                jal = 0;
                jalr = 0;
                alusrc_sel = 1'b1;
                if (funct3 == 3'b101) alu_control = {funct7[5], funct3};
                else alu_control = {1'b0, funct3};
                rfsrc_sel = 0; 
                mem_mode = 0;  
                dwe = 0;
            end
            `B_TYPE: begin
                rf_we       = 1'b0;
                branch      = 1;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b0;  //rs1, rs2
                alu_control = {1'b0, funct3};
                rfsrc_sel   = 0;
                mem_mode    = 0;
                dwe         = 0;
            end
            `UL_TYPE, `UA_TYPE: begin
                rf_we       = 1'b1;
                branch      = 0;
                jal         = 0;
                jalr        = 0;
                alusrc_sel  = 1'b0;
                alu_control = 4'b0;
                if (opcode == `UL_TYPE) begin
                    rfsrc_sel = 3'b010;
                end else rfsrc_sel = 3'b011;
                mem_mode = 0;
                dwe      = 0;
            end
            `J_TYPE, `JL_TYPE: begin
                rf_we  = 1'b1;
                branch = 0;
                jal    = 1;
                if (opcode == `J_TYPE) begin
                    jalr = 0;
                end else begin
                    jalr = 1;
                end
                alusrc_sel  = 1'b0;
                alu_control = 4'b0;
                rfsrc_sel   = 3'b100;
                mem_mode    = 0;
                dwe         = 0;
            end
        endcase
    end

endmodule
