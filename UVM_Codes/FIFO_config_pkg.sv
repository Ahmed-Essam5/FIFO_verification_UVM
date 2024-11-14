package FIFO_config_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class FIFO_config extends  uvm_object;
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_config)

		virtual FIFO_inter FIFO_vif;
	
		// Constructor
		function new(string name = "FIFO_config");
			super.new(name);
		endfunction : new
	
	endclass : FIFO_config
endpackage : FIFO_config_pkg