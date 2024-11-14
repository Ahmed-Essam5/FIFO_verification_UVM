module FIFO_SVA (data_in, wr_en, rd_en, clk, rst_n, full, empty, almostfull, almostempty, wr_ack, overflow, underflow, data_out);

	parameter FIFO_WIDTH = 16;
	parameter FIFO_DEPTH = 8;

	input clk;
	input [FIFO_WIDTH-1:0] data_in;
	input rst_n, wr_en, rd_en;
	input [FIFO_WIDTH-1:0] data_out;
	input wr_ack, overflow;
	input full, empty, almostfull, almostempty, underflow;

	localparam max_fifo_addr = $clog2(FIFO_DEPTH);
	logic [max_fifo_addr-1:0] wr_ptr, rd_ptr;
	logic [max_fifo_addr:0] count;

//for write and read pointers and count only
	always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
		wr_ptr <= 0;
		rd_ptr <= 0;
	end
	else begin
		if (({wr_en, rd_en} == 2'b11)) begin 
			if (count==0) begin
				count<=count+1;
				wr_ptr<=wr_ptr+1;
			end
			else if (count==FIFO_DEPTH) begin
				count<=count-1;
				rd_ptr<=rd_ptr+1;
			end
			else begin
				wr_ptr<=wr_ptr+1;
				rd_ptr<=rd_ptr+1;
			end
		end
		else begin
			if	( (wr_en == 1) && !full)  begin
				count <= count + 1;
				wr_ptr<=wr_ptr+1;
			end
			else if ( (rd_en == 1) && !empty) begin
				count <= count - 1;
				rd_ptr<=rd_ptr+1;
			end
		end
	end
end

//Assertions
always_comb begin
	if (count==FIFO_DEPTH) begin
		assert_full: assert final (full);
		full_c: cover final (full);
	end
	if (count==(FIFO_DEPTH-1)) begin
		assert_almostfull: assert final (almostfull);
		almostfull_c: cover final (almostfull);
	end
	if (count==0) begin
		assert_empty: assert final (empty);
		empty_c: cover final (empty);
	end
	if (count==1) begin
		assert_almostempty: assert final (almostempty);
		almostempty_c: cover final (almostempty);
	end
	if (!rst_n) begin
		assert_reset: assert final (!full && empty && (count==0) && (rd_ptr==0) && (wr_ptr==0));
		reset_c: cover final (!full && empty && (count==0) && (rd_ptr==0) && (wr_ptr==0));
	end
end

property assert_overflow;
	@(posedge clk) disable iff(!rst_n) (((count==FIFO_DEPTH)&&(wr_en))|=> (overflow));	//sequential output signal
endproperty
property assert_underflow;
	@(posedge clk) disable iff(!rst_n) (((count==0)&&(rd_en))|=> (underflow));	//sequential output signal
endproperty
property assert_wr_ack;
	@(posedge clk) disable iff(!rst_n) (((count!=FIFO_DEPTH)&&(wr_en))|=> (wr_ack));	//sequential output signal
endproperty
property assert_count_not_max;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&rd_en&&!full&&!empty)|=> ($stable(count)));
endproperty
property assert_count_max;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&rd_en&&full&&!empty)|=> (count==$past(count)-1));
endproperty
property assert_count_ZERO;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&rd_en&&!full&&empty)|=> (count==$past(count)+1));
endproperty
property assert_count_write_not_max;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&!rd_en&&!full)|=> (count==$past(count)+1));
endproperty
property assert_count_write_max;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&!rd_en&&full)|=> ($stable(count)));
endproperty
property assert_count_read_not_max;
	@(posedge clk) disable iff(!rst_n) ((!wr_en&&rd_en&&!empty)|=> (count==$past(count)-1));
endproperty
property assert_count_read_max;
	@(posedge clk) disable iff(!rst_n) ((!wr_en&&rd_en&&empty)|=> ($stable(count)));
endproperty
property assert_wr_ptr_not_full;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&!full&&(wr_ptr<7))|=> (wr_ptr==$past(wr_ptr)+1));
endproperty
property assert_wr_ptr_not_full_max;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&!full&&(wr_ptr==7))|=> (wr_ptr==0));
endproperty
property assert_wr_ptr_full;
	@(posedge clk) disable iff(!rst_n) ((wr_en&&full)|=> ($stable(wr_ptr)));
endproperty
property assert_rd_ptr_not_full;
	@(posedge clk) disable iff(!rst_n) ((rd_en&&!empty&&(rd_ptr<7))|=> (rd_ptr==$past(rd_ptr)+1));
endproperty
property assert_rd_ptr_not_full_max;
	@(posedge clk) disable iff(!rst_n) ((rd_en&&!empty&&(rd_ptr==7))|=> (rd_ptr==0));
endproperty
property assert_rd_ptr_full;
	@(posedge clk) disable iff(!rst_n) ((rd_en&&empty)|=> ($stable(rd_ptr)));
endproperty

assert property (assert_overflow);
cover property (assert_overflow);

assert property (assert_underflow);
cover property (assert_underflow);

assert property (assert_wr_ack);
cover property (assert_wr_ack);

assert property (assert_count_not_max);
cover property (assert_count_not_max);

assert property (assert_count_max);
cover property (assert_count_max);

assert property (assert_count_ZERO);
cover property (assert_count_ZERO);

assert property (assert_count_write_not_max);
cover property (assert_count_write_not_max);

assert property (assert_count_write_max);
cover property (assert_count_write_max);

assert property (assert_count_read_not_max);
cover property (assert_count_read_not_max);

assert property (assert_count_read_max);
cover property (assert_count_read_max);

assert property (assert_wr_ptr_not_full);
cover property (assert_wr_ptr_not_full);

assert property (assert_wr_ptr_not_full_max);
cover property (assert_wr_ptr_not_full_max);

assert property (assert_wr_ptr_full);
cover property (assert_wr_ptr_full);

assert property (assert_rd_ptr_not_full);
cover property (assert_rd_ptr_not_full);

assert property (assert_rd_ptr_not_full_max);
cover property (assert_rd_ptr_not_full_max);

assert property (assert_rd_ptr_full);
cover property (assert_rd_ptr_full);

endmodule : FIFO_SVA