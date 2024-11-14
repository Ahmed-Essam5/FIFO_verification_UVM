package FIFO_scoreboard_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;

	class FIFO_scoreboard extends uvm_scoreboard;
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_scoreboard)

		uvm_analysis_export #(FIFO_seq_item) sb_export;
		uvm_tlm_analysis_fifo #(FIFO_seq_item) sb_fifo;
		FIFO_seq_item seq_item_sb;

		static logic [15:0] data_out_ex;

		int error_count=0;
		int correct_count=0;

		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;

		localparam max_fifo_addr = $clog2(FIFO_DEPTH);

		logic [FIFO_WIDTH-1:0] mem [FIFO_DEPTH-1:0];
		
		logic [max_fifo_addr-1:0] wr_count, rd_count;
		logic [max_fifo_addr:0] count;

		// Constructor
		function new(string name = "FIFO_scoreboard", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			sb_export=new("sb_export",this);
			sb_fifo=new("sb_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			sb_export.connect(sb_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				sb_fifo.get(seq_item_sb);
				ref_model(seq_item_sb);
				if (seq_item_sb.data_out != data_out_ex) begin 	//compare between the design and the golden model
					`uvm_error("run_phase", "Comparsion failed")
					error_count++;
				end
				else begin
					correct_count++;
				end
			end
		endtask : run_phase

		function void report_phase(uvm_phase phase);
			super.report_phase(phase);
			`uvm_info("report_phase", $sformatf("correct :%0d", correct_count),UVM_MEDIUM);
			`uvm_info("report_phase", $sformatf("Error :%0d", error_count),UVM_MEDIUM);
		endfunction : report_phase

		task ref_model(FIFO_seq_item seq_item_sb);
			if (!seq_item_sb.rst_n) begin 	//the rst_n doesn't reset the output
				wr_count=0;
				rd_count=0;
				count=0;
			end
			else if (seq_item_sb.wr_en && seq_item_sb.rd_en) begin
				if (count==0) begin
					mem[wr_count]=seq_item_sb.data_in;
					wr_count++;
					count++;
				end
				else if (count==FIFO_DEPTH) begin
					data_out_ex=mem[rd_count];
					rd_count++;
					count--;
				end
				else begin
					data_out_ex=mem[rd_count];	//read first because if wr was first and "wr_count++"= "rd_count" "data_out_ex" will take the new value
					rd_count++;
					mem[wr_count]=seq_item_sb.data_in;
					wr_count++;
				end
			end
			else begin
				if (seq_item_sb.wr_en && (count!=FIFO_DEPTH)) begin
					mem[wr_count]=seq_item_sb.data_in;
					wr_count++;
					count++;
				end
				else if (seq_item_sb.rd_en && (count!=0)) begin
					data_out_ex=mem[rd_count];
					rd_count++;
					count--;
				end
			end
		endtask : ref_model
	
	endclass : FIFO_scoreboard
endpackage : FIFO_scoreboard_pkg