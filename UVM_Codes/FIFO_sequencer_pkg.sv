package FIFO_sequencer_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;

	class FIFO_sequencer extends uvm_sequencer #(FIFO_seq_item);
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_component_utils(FIFO_sequencer)
		// Constructor
		function new(string name = "FIFO_sequencer", uvm_component parent=null);
			super.new(name, parent);
		endfunction : new
	
	endclass : FIFO_sequencer
endpackage : FIFO_sequencer_pkg