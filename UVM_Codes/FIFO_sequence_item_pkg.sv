package FIFO_sequence_item_pkg;
	import uvm_pkg::*;
	`include "uvm_macros.svh"
	class FIFO_seq_item extends  uvm_sequence_item;
		// Provide implementations of virtual methods such as get_type_name and create
		`uvm_object_utils(FIFO_seq_item)

		parameter FIFO_WIDTH = 16;
		parameter FIFO_DEPTH = 8;

		logic clk;

		rand logic [FIFO_WIDTH-1:0] data_in;
		rand logic rst_n, wr_en, rd_en;
		logic [FIFO_WIDTH-1:0] data_out;
		logic wr_ack, overflow;
		logic full, empty, almostfull, almostempty, underflow;

		integer RD_EN_ON_DIST, WR_EN_ON_DIST;

		constraint reset_c {
			rst_n dist {1:/95, 0:/5};
		}
		constraint wr_c {
			wr_en dist {1:/WR_EN_ON_DIST, 0:/(100-WR_EN_ON_DIST)};
		}
		constraint rd_c {
			rd_en dist {1:/RD_EN_ON_DIST, 0:/(100-RD_EN_ON_DIST)};
		}
	
		// Constructor
		function new(string name = "FIFO_seq_item", integer wr_in_dist=70, integer rd_in_dist=30);
			super.new(name);
			RD_EN_ON_DIST=rd_in_dist;
			WR_EN_ON_DIST=wr_in_dist;
		endfunction : new

		function string convert2string();
			return $sformatf("%s rst_n=%0b wr_en=%0b rd_en=%0b data_in=%0b wr_ack=%0b overflow=%0b full=%0b empty=%0b almostfull=%0b almostempty=%0b underflow=%0b data_out",super.convert2string(),
				rst_n, wr_en, rd_en, data_in, wr_ack, overflow, full, empty, almostfull, almostempty, underflow, data_out);
		endfunction : convert2string
	
	endclass : FIFO_seq_item
endpackage : FIFO_sequence_item_pkg