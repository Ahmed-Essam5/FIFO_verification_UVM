package FIFO_main_sequence_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	import FIFO_sequence_item_pkg::*;
	
	class FIFO_main_sequence extends  uvm_sequence #(FIFO_seq_item);
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_main_sequence)

		FIFO_seq_item seq_item;
	
		// Constructor
		function new(string name = "FIFO_main_sequence");
			super.new(name);
		endfunction : new

		task body();
//FIFO_2(write_only_sequence)
			repeat (10) begin
				seq_item=FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.rst_n=1;
				seq_item.wr_en=1;
				seq_item.rd_en=0;
				seq_item.data_in=$random();
				finish_item(seq_item);
			end
			//after the 8th loop we can't write anymore and the output should be don't care throghout this repeat loop

//FIFO_3(read_only_sequence)
			repeat (10) begin
				seq_item=FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.rst_n=1;
				seq_item.wr_en=0;
				seq_item.rd_en=1;
				seq_item.data_in=$random();
				finish_item(seq_item);
			end
			//the out will read the data we write previosly and after the 8th loop the out will be fixed to the last value

//FIFO_4(write_read_sequence)
			repeat (10) begin
				seq_item=FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.rst_n=1;
				seq_item.wr_en=1;
				seq_item.rd_en=1;
				seq_item.data_in=$random();
				finish_item(seq_item);
			end
			//with every write the the out will read the write that preceded it except for the first read because from the previos loop the mem was empty

//FIFO_5(random_sequence)
				seq_item=FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				seq_item.rst_n=0;
				finish_item(seq_item);

			repeat (10000) begin
				seq_item=FIFO_seq_item::type_id::create("seq_item");
				start_item(seq_item);
				assert(seq_item.randomize());
				finish_item(seq_item);
			end
		endtask : body
	
	endclass : FIFO_main_sequence
endpackage : FIFO_main_sequence_pkg