//==============================================================================
// Global Defines for PUnC LC3 Computer
//==============================================================================

// Add defines here that you'll use in both the datapath and the controller

//------------------------------------------------------------------------------
// Opcodes
//------------------------------------------------------------------------------
`define OC 15:12       // Used to select opcode bits from the IR

`define OC_ADD 4'b0001 // Instruction-specific opcodes
`define OC_AND 4'b0101
`define OC_BR  4'b0000
`define OC_JMP 4'b1100
`define OC_JSR 4'b0100
`define OC_LD  4'b0010
`define OC_LDI 4'b1010
`define OC_LDR 4'b0110
`define OC_LEA 4'b1110
`define OC_NOT 4'b1001
`define OC_ST  4'b0011
`define OC_STI 4'b1011
`define OC_STR 4'b0111
`define OC_HLT 4'b1111

`define IMM_BIT_NUM 5  // Bit for distinguishing ADDR/ADDI and ANDR/ANDI
`define IS_IMM 1'b1
`define IMM_SIGN 4
`define IMM 4:0

`define JSR_BIT_NUM 11 // Bit for distinguishing JSR/JSRR
`define IS_JSR 1'b1

`define BR_N 11        // Location of special bits in BR instruction
`define BR_Z 10
`define BR_P 9

// PC OFFSETS
// offset mux
`define PC_OFFSET0 2'b00
`define PC_OFFSET9 2'b01
`define PC_OFFSET11 2'b10
// offset bits
`define PC_OFFSET9_BITS 8:0
`define PC_OFFSET9_SIGN 8
`define PC_OFFSET11_BITS 10:0
`define PC_OFFSET11_SIGN 10     // Location of sign bit
`define IS_NEG 1'b1

// Memory Mux
`define MEM_MUX_PC 2'b00
`define MEM_MUX_RF 2'b01
`define MEM_MUX_RDATA 2'b10

// Alu select
`define ALU_ADD 2'b00
`define ALU_AND 2'b01
`define ALU_NOT 2'b10


// RF write mux
`define RF_WDATA_PC 2'b00
`define RF_WDATA_MEM 2'b01
`define RF_WDATA_ALU 2'b10

// MEM write mux
`define MEM_WDATA_RF0 1'b0
`define MEM_WDATA_RF1 1'b1
