//==============================================================================
// Control Unit for PUnC LC3 Processor
//==============================================================================

`include "Defines.v"

module PUnCControl(
	// External Inputs
	input clk,            // Clock
	input rst,            // Reset

	// Add more ports here
	input [3:0] opcode,

	input can_branch,
	
	output reg mem_w_en,

	output reg rf_w_en,
	output reg rf_addr0_8_6,
	output reg rf_addr1_11_9,
	output reg rf_waddr_111,

	output reg [1:0] alu_select,

	output reg [1:0] rf_wdata_mux,

	output reg ir_ld,

	output reg cc_ld,

	output reg [1:0] mem_addr_mux,

	output reg [1:0] pc_offset_mux,

	output reg pmu_rf,
		
	output reg pc_ld,
	output reg pc_clr,
	output reg pc_inc,

	output reg mem_wdata_mux
);
	// Declare Local Vars Here
	// reg [X:0] state;
	// reg [X:0] next_state;
	reg [4:0]	state;
	reg [4:0]	next_state;

	// FSM States
	// Add your FSM State values as localparams here
	localparam STATE_FETCH 	    = 5'd0;
	localparam STATE_DECODE     = 5'd1;
	localparam STATE_ADD 	    = 5'd2;
	localparam STATE_AND	    = 5'd3;
	localparam STATE_BR1	    = 5'd4;
	localparam STATE_BR2     	= 5'd5;
	localparam STATE_JMP_RET    = 5'd6;
	localparam STATE_JSR1     	= 5'd7;
	localparam STATE_JSR2    	= 5'd8;
	localparam STATE_LD     	= 5'd9;
	localparam STATE_LDI1     	= 5'd10;
	localparam STATE_LDI2     	= 5'd11;
	localparam STATE_LDR     	= 5'd12;
	localparam STATE_LEA     	= 5'd13;
	localparam STATE_NOT     	= 5'd14;
	localparam STATE_ST     	= 5'd15;
	localparam STATE_STI1     	= 5'd16;
	localparam STATE_STI2     	= 5'd17;
	localparam STATE_STR     	= 5'd18;
	localparam STATE_HALT     	= 5'd19;

	// State, Next State
	// reg [X:0] state, next_state;

	// Output Combinational Logic
	always @( * ) begin
		// Set default values for outputs here (prevents implicit latching)
		mem_w_en = 0;

		rf_w_en = 0;
		rf_addr0_8_6 = 0;
		rf_addr1_11_9 = 0;

		alu_select = 0;

		rf_wdata_mux = 0;

		ir_ld = 0;

		cc_ld = 0;

		mem_addr_mux = 0;

		pc_offset_mux = `PC_OFFSET0;

		pmu_rf = 0;
				
		pc_ld = 0;
		pc_clr = 0;
		pc_inc = 0;

		mem_wdata_mux = 0;

		rf_waddr_111 = 0;
			
		case (state)
			STATE_FETCH: begin
				ir_ld = 1;
				mem_addr_mux = `MEM_MUX_PC;
			end
			STATE_DECODE: begin
				pc_inc = 1;
			end
			STATE_ADD: begin
				rf_addr0_8_6 = 1;
				rf_w_en = 1;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_ALU;
				alu_select = `ALU_ADD;
			end
			STATE_AND: begin
				rf_addr0_8_6 = 1;
				rf_w_en = 1;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_ALU;
				alu_select = `ALU_AND;
			end
			STATE_BR1: begin
			end
			STATE_BR2: begin
				pc_ld = 1;
				pc_offset_mux = `PC_OFFSET9;
			end
			STATE_JMP_RET: begin
				rf_addr0_8_6 = 1;
				pc_ld = 1;
				pmu_rf = 1;
			end
			STATE_JSR1: begin
				rf_w_en = 1;
				rf_waddr_111 = 1;
				rf_wdata_mux = `RF_WDATA_PC;
			end
			STATE_JSR2: begin
				pc_ld = 1;
				rf_addr0_8_6 = 1;
				pc_offset_mux = `PC_OFFSET11;
			end
			STATE_LD: begin
				rf_w_en = 1;
				pc_offset_mux = `PC_OFFSET9;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_MEM;
				mem_addr_mux = `MEM_MUX_PC;
			end
			STATE_LDI1: begin
				pc_offset_mux = `PC_OFFSET9;
				cc_ld = 1;
				mem_addr_mux = `MEM_MUX_PC;
			end
			STATE_LDI2: begin
				rf_w_en = 1;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_MEM;
				mem_addr_mux = `MEM_MUX_RDATA;
			end
			STATE_LDR: begin
				rf_addr0_8_6 = 1;
				rf_w_en = 1;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_MEM;
				mem_addr_mux = `MEM_MUX_RF;
			end
			STATE_LEA: begin
				rf_w_en = 1;
				pc_offset_mux = `PC_OFFSET9;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_PC;
				
			end
			STATE_NOT: begin
				rf_addr0_8_6 = 1;
				rf_w_en = 1;
				cc_ld = 1;
				rf_wdata_mux = `RF_WDATA_ALU;
				alu_select = `ALU_NOT;
				
			end
			STATE_ST: begin
				mem_w_en = 1;
				pc_offset_mux = `PC_OFFSET9;
				mem_addr_mux = `MEM_MUX_PC;
				mem_wdata_mux = `MEM_WDATA_RF0;
			end
			STATE_STI1: begin
				pc_offset_mux = `PC_OFFSET9;;
				mem_addr_mux = `MEM_MUX_PC;			
			end
			STATE_STI2: begin
				mem_w_en = 1;
				rf_addr0_8_6 = 1;
				mem_addr_mux = `MEM_MUX_RDATA;
				mem_wdata_mux = `MEM_WDATA_RF0;
				
			end
			STATE_STR: begin
				mem_w_en = 1;
				rf_addr0_8_6 = 1;
				mem_addr_mux = `MEM_MUX_RF;
				mem_wdata_mux = `MEM_WDATA_RF1;
				rf_addr1_11_9 = 1;
			end
			STATE_HALT: begin
				
			end
		endcase

		if (rst) begin
			pc_clr = 1;
		end

	end

	// Next State Combinational Logic
	always @( * ) begin
		// Set default value for next state here
		next_state = state;

		// Add your next-state logic here
		case (state)
			STATE_FETCH: begin
				next_state = STATE_DECODE;
			end
			STATE_DECODE: begin
				case(opcode)
					`OC_ADD: begin
						next_state = STATE_ADD;
					end
					`OC_AND: begin
						next_state = STATE_AND;
					end
					`OC_BR: begin
						next_state = STATE_BR1;
					end
					`OC_JMP: begin
						next_state = STATE_JMP_RET;
					end
					`OC_JSR: begin
						next_state = STATE_JSR1;
					end
					`OC_LD: begin
						next_state = STATE_LD;
					end
					`OC_LDI: begin
						next_state = STATE_LDI1;
					end
					`OC_LDR: begin
						next_state = STATE_LDR;
					end
					`OC_LEA: begin
						next_state = STATE_LEA;
					end
					`OC_NOT: begin
						next_state = STATE_NOT;
					end
					`OC_ST: begin
						next_state = STATE_ST;
					end
					`OC_STI: begin
						next_state = STATE_STI1;
					end
					`OC_STR: begin
						next_state = STATE_STR;
					end
					`OC_HLT: begin
						next_state = STATE_HALT;
					end
				endcase
			end
			STATE_ADD: begin
				next_state = STATE_FETCH;
			end
			STATE_AND: begin
				next_state = STATE_FETCH;
			end
			STATE_BR1: begin
				if (can_branch) begin
					next_state = STATE_BR2;
				end
				else begin
					next_state = STATE_FETCH;
				end
			end
			STATE_BR2: begin
				next_state = STATE_FETCH;
			end
			STATE_JMP_RET: begin
				next_state = STATE_FETCH;
			end
			STATE_JSR1: begin
				next_state = STATE_JSR2;
			end
			STATE_JSR2: begin
				next_state = STATE_FETCH;
			end
			STATE_LD: begin
				next_state = STATE_FETCH;
			end
			STATE_LDI1: begin
				next_state = STATE_LDI2;
			end
			STATE_LDI2: begin
				next_state = STATE_FETCH;
			end
			STATE_LDR: begin
				next_state = STATE_FETCH;
			end
			STATE_LEA: begin
				next_state = STATE_FETCH;
				
			end
			STATE_NOT: begin
				next_state = STATE_FETCH;
				
			end
			STATE_ST: begin
				next_state = STATE_FETCH;
			end
			STATE_STI1: begin
				next_state = STATE_STI2;		
			end
			STATE_STI2: begin
				next_state = STATE_FETCH;
				
			end
			STATE_STR: begin
				next_state = STATE_FETCH;
			end
			STATE_HALT: begin
				next_state = STATE_HALT;
			end
		endcase
	end

	// State Update Sequential Logic
	always @(posedge clk) begin
		if (rst) begin
			// Update state to reset state
			state <= STATE_FETCH;
		end
		else begin
			// Update state to next state
			state <= next_state;
		end
	end

endmodule
