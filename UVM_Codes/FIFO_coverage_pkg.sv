package FIFO_coverage_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;
	class FIFO_coverage extends uvm_component;
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_coverage)

		uvm_analysis_export #(FIFO_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
		FIFO_seq_item seq_item_cov;

		covergroup CovGp ();
		 	wr_full: cross seq_item_cov.wr_en, seq_item_cov.full;
		 	wr_rd_almostfull: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.almostfull;
		 	wr_rd_empty: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.empty;
		 	wr_rd_almostempty: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.almostempty;
		 	wr_rd_overflow: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.overflow;
		 	wr_rd_underflow: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.underflow;
		 	wr_rd_wr_ack: cross seq_item_cov.wr_en, seq_item_cov.rd_en, seq_item_cov.wr_ack;
		 endgroup : CovGp
		 
		// Constructor
		function new(string name = "FIFO_coverage", uvm_component parent=null);
			super.new(name, parent);
			CovGp=new();
		endfunction : new

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export=new("cov_export",this);
			cov_fifo=new("cov_fifo",this);
		endfunction : build_phase

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction : connect_phase

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				CovGp.sample();
			end
		endtask : run_phase
	
	endclass : FIFO_coverage
endpackage : FIFO_coverage_pkg