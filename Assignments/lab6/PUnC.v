//==============================================================================
// Module for PUnC LC3 Processor
//==============================================================================

`include "PUnCDatapath.v"
`include "PUnCControl.v"

module PUnC(
	// External Inputs
	input  clk,            // Clock
	input  rst,            // Reset

	// Debug Signals
	input [15:0] mem_debug_addr,
	input [2:0]  rf_debug_addr,
	output wire [15:0] mem_debug_data,
	output wire [15:0] rf_debug_data,
	output wire [15:0] pc_debug_data
);

	//----------------------------------------------------------------------
	// Interconnect Wires
	//----------------------------------------------------------------------

	// Declare your wires for connecting the datapath to the controller here
	wire [3:0] opcode;

	wire mem_w_en;

	wire rf_w_en;
	wire rf_addr0_8_6;
	wire rf_addr1_11_9;

	wire [1:0] alu_select;

	wire [1:0] rf_wdata_mux;

	wire ir_ld;

	wire cc_ld;

	wire [1:0] mem_addr_mux;
	wire mem_wdata_mux;

	wire [1:0] pc_offset_mux;

	wire pmu_rf;
	wire pc_ld;
	wire pc_clr;
	wire pc_inc;

	wire wmu_rf0;
	wire wmu_rf1;

	wire can_branch;

	wire rf_waddr_111;

	//----------------------------------------------------------------------
	// Control Module
	//----------------------------------------------------------------------
	PUnCControl ctrl(
		.clk            (clk),
		.rst            (rst),

		// Add more ports here
		.opcode			(opcode),
	
		.mem_w_en		(mem_w_en),

		.rf_w_en		(rf_w_en),
		.rf_addr0_8_6	(rf_addr0_8_6),
		.rf_addr1_11_9	(rf_addr1_11_9),
		.rf_waddr_111	(rf_waddr_111),

		.alu_select		(alu_select),

		.rf_wdata_mux	(rf_wdata_mux),

		.ir_ld			(ir_ld),

		.cc_ld			(cc_ld),

		.mem_addr_mux		(mem_addr_mux),

		.pc_offset_mux	(pc_offset_mux),

		.pmu_rf			(pmu_rf),
		.pc_ld			(pc_ld),
		.pc_clr			(pc_clr),
		.pc_inc			(pc_inc),

		.mem_wdata_mux  (mem_wdata_mux),

		.can_branch		(can_branch)
	);

	//----------------------------------------------------------------------
	// Datapath Module
	//----------------------------------------------------------------------
	PUnCDatapath dpath(
		.clk             (clk),
		.rst             (rst),

		.mem_debug_addr   (mem_debug_addr),
		.rf_debug_addr    (rf_debug_addr),
		.mem_debug_data   (mem_debug_data),
		.rf_debug_data    (rf_debug_data),
		.pc_debug_data    (pc_debug_data),

		// Add more ports here
		.opcode			(opcode),
	
		.mem_w_en		(mem_w_en),

		.rf_w_en		(rf_w_en),
		.rf_addr0_8_6	(rf_addr0_8_6),
		.rf_addr1_11_9	(rf_addr1_11_9),
		.rf_waddr_111	(rf_waddr_111),

		.alu_select		(alu_select),

		.rf_wdata_mux	(rf_wdata_mux),

		.ir_ld			(ir_ld),

		.cc_ld			(cc_ld),

		.mem_addr_mux	(mem_addr_mux),

		.pc_offset_mux	(pc_offset_mux),
		.pmu_rf			(pmu_rf),
		.pc_ld			(pc_ld),
		.pc_clr			(pc_clr),
		.pc_inc			(pc_inc),

		.mem_wdata_mux  (mem_wdata_mux),

		.can_branch		(can_branch)
	);

endmodule
