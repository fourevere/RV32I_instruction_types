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
    //adder
    initial begin
        $readmemh("instruction_mem_sort.mem", instr_rom);
    end
    //sort
    // initial begin
    //     $readmemh("instruction_code.mem", instr_rom);
    // end
`endif
    assign instr_code = instr_rom[instr_addr[31:2]];
endmodule


//R-type
// instr_rom[0] = 32'h0041_82b3;  
// instr_rom[1] = 32'h4061_87b3;  
// instr_rom[2] = 32'h0021_92b3;  
// instr_rom[3] = 32'h0027_a2b3;  
// instr_rom[4] = 32'h0027_b2b3;  
// instr_rom[5] = 32'h0033_c2b3;  
// instr_rom[6] = 32'h0022_52b3;  
// instr_rom[7] = 32'h4071_8233;  
// instr_rom[8] = 32'h4022_52b3;  
// instr_rom[9] = 32'h0031_62b3;  
// instr_rom[10] = 32'h0031_72b3; 

//I-type
// instr_rom[0] = 32'hffd0_0793;  
// instr_rom[1] = 32'h0027_a293;  
// instr_rom[2] = 32'h0027_b293;  
// instr_rom[3] = 32'h0033_c293;  
// instr_rom[4] = 32'h0031_6293;  
// instr_rom[5] = 32'h0021_f293;  
// instr_rom[6] = 32'h0021_9293;  
// instr_rom[7] = 32'h0022_5293;  
// instr_rom[8] = 32'h4027_d293;  

//B-type
//instr_rom[0] = 32'h0021_0463;
//instr_rom[1] = 32'h0031_0463;
//instr_rom[2] = 32'h0031_1463;
//instr_rom[3] = 32'h0021_1463;
//instr_rom[4] = 32'h0031_4463;
//instr_rom[5] = 32'h0021_C463;
//instr_rom[6] = 32'h0021_D463;
//instr_rom[7] = 32'h0031_5463;
//instr_rom[8] = 32'h0031_6463;
//instr_rom[9] = 32'h0021_E463;
//instr_rom[10] = 32'h0021_F463;
//instr_rom[11] = 32'h0031_7463;
//instr_rom[12] = 32'h0021_0463;
//instr_rom[13] = 32'h0021_0463;
//instr_rom[14] = 32'h0021_0463;

//S-type

// instr_rom[0]  = 32'h0144_2023;  // S-type SW 
// instr_rom[1]  = 32'h0004_2C83;  // IL-type LW

// instr_rom[2]  = 32'h0004_2023;  // S-type SW 
// instr_rom[3]  = 32'h0134_1023;  // S-type SH 
// instr_rom[4]  = 32'h0124_1123;  // S-type SH 
// instr_rom[5]  = 32'h0004_2D03;  // IL-type LW

// instr_rom[6]  = 32'h0004_2023;  // S-type SW 
// instr_rom[7]  = 32'h0154_0023;  // S-type SB 
// instr_rom[8]  = 32'h0164_00A3;  // S-type SB 
// instr_rom[9]  = 32'h0174_0123;  // S-type SB 
// instr_rom[10] = 32'h0184_01A3;  // S-type SB 

//IL-type

// instr_rom[0] = 32'h0004_2C83;  // IL-type LW 
// instr_rom[1] = 32'h0004_2D03;  // IL-type LW 
// instr_rom[2] = 32'h0004_2D83;  // IL-type LW 
// instr_rom[3] = 32'h0034_0E03;  // IL-type LB 
// instr_rom[4] = 32'h0024_4E83;  // IL-type LBU
// instr_rom[5] = 32'h0024_1F03;  // IL-type LH 
// instr_rom[6] = 32'h0004_5F83;  // IL-type LHU

//U-type

// instr_rom[0] = 32'h1234_5537; 
// instr_rom[1] = 32'h0000_1597; 
// instr_rom[2] = 32'h0000_0037; 

//J-type
// JAL
// instr_rom[0] = 32'h0100_02ef;
// 예상결과: x5 = 32'h0000_0004, 다음 실행 위치 = instr_rom[4]

// instr_rom[1] = 32'h0000_006f;
// instr_rom[2] = 32'h0000_006f;
// instr_rom[3] = 32'h0000_006f;

// JALR
// instr_rom[4] = 32'h0161_0367;
// 예상결과: x6 = 32'h0000_0014, 다음 실행 위치 = instr_rom[6]

// instr_rom[5] = 32'h0000_006f;