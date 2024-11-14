import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh"

module FIFO_top ();
	bit clk;

	initial begin
		clk=0;
		forever
		#1 clk=~clk;
	end

	FIFO_inter inter (clk);
	FIFO DUT (
		.clk        (clk),
		.rd_en      (inter.rd_en),
		.wr_en      (inter.wr_en),
		.rst_n      (inter.rst_n),
		.data_in    (inter.data_in),
		.full       (inter.full),
		.empty      (inter.empty),
		.wr_ack     (inter.wr_ack),
		.data_out   (inter.data_out),
		.overflow   (inter.overflow),
		.underflow  (inter.underflow),
		.almostfull (inter.almostfull),
		.almostempty(inter.almostempty)
		);
	
	bind FIFO FIFO_SVA SVA (
		.clk        (clk),
		.rd_en      (inter.rd_en),
		.wr_en      (inter.wr_en),
		.rst_n      (inter.rst_n),
		.data_in    (inter.data_in),
		.full       (inter.full),
		.empty      (inter.empty),
		.wr_ack     (inter.wr_ack),
		.data_out   (inter.data_out),
		.overflow   (inter.overflow),
		.underflow  (inter.underflow),
		.almostfull (inter.almostfull),
		.almostempty(inter.almostempty)
		);

	initial begin
		uvm_config_db#(virtual FIFO_inter)::set(null,"uvm_test_top","FIFO_IF",inter);
		run_test("FIFO_test");
	end

endmodule : FIFO_top