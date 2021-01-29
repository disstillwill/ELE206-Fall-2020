//==============================================================================
// Datapath for PUnC LC3 Processor
//==============================================================================

`include "Memory.v"
`include "RegisterFile.v"
`include "Defines.v"



module PUnCDatapath(
	// External Inputs
	input clk,            // Clock
	input rst,            // Reset

	// DEBUG Signals
	input [15:0] mem_debug_addr,
	input  [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data,

	// Add more ports here
	output reg [3:0] opcode,
	
	input mem_w_en,

	input rf_w_en,
	input rf_addr0_8_6,
	input rf_addr1_11_9,
	input rf_waddr_111,

	input [1:0] alu_select,

	input [1:0] rf_wdata_mux,

	input ir_ld,

	input cc_ld,

	input [1:0] mem_addr_mux,

	input [1:0] pc_offset_mux,
	input pmu_rf,
	input pc_ld,
	input pc_clr,
	input pc_inc,

	input mem_wdata_mux,

	output reg can_branch
);

	// Local Registers
	reg  [15:0] pc;
	reg  [15:0] ir;

	// Declare other local wires and registers here

	// Condition codes
	reg n;								// Negative
	reg z;								// Zero
	reg p;								// Positive
	reg [1:0] rf_wdata_sign;

	// For memory block 
	reg [15:0] mem_addr;
	wire [15:0] mem_rdata;
	reg [15:0] mem_wdata;

	// For ALU
	reg [15:0] alu_rdata;
	reg [15:0] alu_wdata_1;
	reg [3:0] alu_temp;

	// For register file
	wire [15:0] rf_rdata_0;
	wire [15:0] rf_rdata_1;
	reg [15:0] rf_wdata;
	reg [2:0] rf_waddr;
	reg [2:0] rf_raddr0;
	reg [2:0] rf_raddr1;
	reg [5:0] r_temp;

	// For PC
	reg [15:0] pc_offset;
	reg [15:0] pc_wdata;
	reg [8:0] pc_temp9;
	reg [10:0] pc_temp11;


	// Assign PC debug net
	assign pc_debug_data = pc;

	


	//----------------------------------------------------------------------
	// Memory Module
	//----------------------------------------------------------------------

	// 1024-entry 16-bit memory (connect other ports)
	Memory mem(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (mem_addr),
		.r_addr_1 (mem_debug_addr),
		.w_addr   (mem_addr),
		.w_data   (mem_wdata),
		.w_en     (mem_w_en),
		.r_data_0 (mem_rdata),
		.r_data_1 (mem_debug_data)
	);

	//----------------------------------------------------------------------
	// Register File Module
	//----------------------------------------------------------------------

	// 8-entry 16-bit register file (connect other ports)
	RegisterFile rfile(
		.clk      (clk),
		.rst      (rst),
		.r_addr_0 (rf_raddr0),
		.r_addr_1 (rf_raddr1),
		.r_addr_2 (rf_debug_addr),
		.w_addr   (rf_waddr),
		.w_data   (rf_wdata),
		.w_en     (rf_w_en),
		.r_data_0 (rf_rdata_0),
		.r_data_1 (rf_rdata_1),
		.r_data_2 (rf_debug_data)
	);

	//----------------------------------------------------------------------
	// Add all other datapath logic here
	//----------------------------------------------------------------------
	
	always @(posedge clk) begin
		// Sequential Internal Logic Here
		if (ir_ld) begin
			ir <= mem_rdata;
			opcode <= mem_rdata[`OC];
		end

		if (pc_inc) begin
			pc <= pc + 16'd1;
		end

		if (pc_ld) begin
			pc <= pc_wdata;
		end

		if (cc_ld) begin 
			if (rf_wdata[15]) begin
				n <= 1;
				z <= 0;
				p <= 0;
			end
			else if (rf_wdata == 16'd0) begin
				n <= 0;
				z <= 1;
				p <= 0;
			end
			else begin 
				n <= 0;
				z <= 0;
				p <= 1;
			end
		end
	end
	
	always @( * ) begin
		// Output Logic Here
		if (pc_clr) begin
			pc = 16'd0;
		end

		// Output if any of the condition codes are true
		if ((n && ir[`BR_N]) || z && ir[`BR_Z] || p && ir[`BR_P]) begin
			can_branch = 1;
		end
		else begin
			can_branch = 0;
		end

		// Handles pc offset logic
		if (pc_offset_mux == `PC_OFFSET0) begin
			pc_offset = 16'd0;
		end
		else if (pc_offset_mux == `PC_OFFSET9) begin
			if (ir[`PC_OFFSET9_SIGN] == `IS_NEG) begin
				pc_temp9 = (~ir[`PC_OFFSET9_BITS]) + 9'd1;
				pc_offset = (~pc_temp9) + 9'd1;
			end
			else begin
				pc_offset = ir[`PC_OFFSET9_BITS];
			end
		end
		else if (pc_offset_mux == `PC_OFFSET11) begin
			if (ir[`PC_OFFSET11_SIGN] == `IS_NEG) begin
				pc_temp11 = (~ir[`PC_OFFSET11_BITS]) + 11'd1;
				pc_offset = (~pc_temp11) + 11'd1;
			end
			else begin
				pc_offset = ir[`PC_OFFSET11_BITS];
			end
		end
		
		// RF raddr0 mux
		if (rf_addr0_8_6) begin 
			rf_raddr0 = ir[8:6];
		end
		else begin
			rf_raddr0 = ir[11:9];
		end

		// RF raddr1 mux
		if (rf_addr1_11_9) begin 
			rf_raddr1 = ir[11:9];
		end
		else begin
			rf_raddr1 = ir[2:0];
		end
		// 	RF w_addr mux
		if (rf_waddr_111) begin
			rf_waddr = 3'b111;
		end
		else begin
			rf_waddr = ir[11:9];
		end


		// MEM addr mux 
		if (mem_addr_mux == `MEM_MUX_PC) begin
			mem_addr =  pc + pc_offset;
		end
		else if (mem_addr_mux == `MEM_MUX_RF) begin
			if (ir[5]) begin
				r_temp = (~ir[5:0]) + 6'd1;
				mem_addr = rf_rdata_0 + (~r_temp) + 6'd1;
			end
			else begin
				mem_addr = rf_rdata_0 + ir[5:0];
			end
		end
		else if (mem_addr_mux == `MEM_MUX_RDATA) begin
			mem_addr =  mem_rdata;
		end

		// ALU Mux
		if (ir[`IMM_BIT_NUM] == `IS_IMM) begin
			if (ir[`IMM_SIGN]) begin
				alu_temp = (~ir[`IMM]) + 16'd1;
				alu_wdata_1 = (~alu_temp) + 16'd1;
			end
			else begin
				alu_wdata_1 = ir[`IMM];
			end
		end
		else begin
			alu_wdata_1 = rf_rdata_1;
		end

		// ALU select
		if (alu_select == `ALU_ADD) begin				// Add
			alu_rdata = rf_rdata_0 + alu_wdata_1;
		end
		else if (alu_select == `ALU_AND) begin			// Bit-wise AND
			alu_rdata = rf_rdata_0 & alu_wdata_1;
		end
		else if (alu_select == `ALU_NOT) begin			// Bit-wise NOT
			alu_rdata = ~rf_rdata_0;
		end

		// RF wdata mux
		if (rf_wdata_mux == `RF_WDATA_PC) begin
			rf_wdata = pc + pc_offset;
		end
		else if (rf_wdata_mux == `RF_WDATA_MEM) begin
			rf_wdata = mem_rdata;
		end
		else if (rf_wdata_mux == `RF_WDATA_ALU) begin
			rf_wdata = alu_rdata;
		end

		if (mem_wdata_mux == `MEM_WDATA_RF0) begin
			mem_wdata = rf_rdata_0;
		end
		else if (mem_wdata_mux == `MEM_WDATA_RF1) begin
			mem_wdata = rf_rdata_1;
		end

		if (ir[`JSR_BIT_NUM] == 0 && ir[`BR_Z] == 0 && ir[`BR_P] == 0) begin
			pc_wdata = rf_rdata_0;
		end
		else if (pmu_rf) begin
			// PC wdata mux
			if (ir[5]) begin
				r_temp = (~ir[5:0]) + 6'd1;
				pc_wdata = rf_rdata_0 + (~r_temp) + 6'd1;
			end
			else begin
				pc_wdata = rf_rdata_0 + ir[5:0];
			end
		end
		else begin
			pc_wdata = pc + pc_offset;
		end
	end
endmodule
