package FIFO_rst_sequence_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;
	
	class FIFO_rst_sequence extends  uvm_sequence #(FIFO_seq_item);
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_rst_sequence)

		FIFO_seq_item seq_item;
	
		// Constructor
		function new(string name = "FIFO_rst_sequence");
			super.new(name);
		endfunction : new

//FIFO_1(reset)
		task body();
			seq_item=FIFO_seq_item::type_id::create("seq_item");
			start_item(seq_item);
			seq_item.rst_n=0;
			seq_item.rd_en=1;
			seq_item.wr_en=1;
			seq_item.data_in=16'hFFFF;
			finish_item(seq_item);
		endtask : body
	
	endclass : FIFO_rst_sequence
endpackage : FIFO_rst_sequence_pkg