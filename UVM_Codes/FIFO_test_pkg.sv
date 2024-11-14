package FIFO_test_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_config_pkg::*;
	import FIFO_main_sequence_pkg::*;
	import FIFO_rst_sequence_pkg::*;
	import FIFO_env_pkg::*;
	
	class FIFO_test extends uvm_test;
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_test)

		virtual FIFO_inter FIFO_vif;
		FIFO_config FIFO_cfg;
		FIFO_env env;
		FIFO_rst_sequence reset_seq;
		FIFO_main_sequence main_seq;
	
		// Constructor
		function new(string name = "FIFO_test", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new

		// Build_phase
		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			FIFO_cfg=FIFO_config::type_id::create("FIFO_cfg");
			env=FIFO_env::type_id::create("env", this);
			reset_seq=FIFO_rst_sequence::type_id::create("reset_seq");
			main_seq=FIFO_main_sequence::type_id::create("main_seq");
			
			if (!uvm_config_db#(virtual FIFO_inter)::get(this, "", "FIFO_IF", FIFO_cfg.FIFO_vif)) begin
				`uvm_fatal("build_phase", "TEST- unable to get the virtual interface");
			end
			uvm_config_db#(FIFO_config)::set(this, "*", "CFG", FIFO_cfg);
		endfunction : build_phase

		// Run_phase
		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			`uvm_info("run_phase", "Reset asserted", UVM_LOW)
			reset_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "Reset deasserted", UVM_LOW)

			`uvm_info("run_phase", "main begin", UVM_LOW)
			main_seq.start(env.agt.sqr);
			`uvm_info("run_phase", "main end", UVM_LOW)
			phase.drop_objection(this);
		endtask : run_phase	
	
	endclass : FIFO_test
endpackage : FIFO_test_pkg