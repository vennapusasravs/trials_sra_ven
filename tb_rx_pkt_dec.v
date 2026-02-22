`timescale 1ns/1ps
module tb_packet_decoder;

    logic clk;
    logic rst_n;

    logic         fifo_out_valid;
    logic [511:0] fifo_out_data;
    logic         tx_valid;
    logic         rx_ready;

    logic         flit_en;
    logic         flit_valid;
    logic [255:0] flit_data;
    logic         cxs_last;

    logic segment_valid;
    logic segment_start;
    logic segment_last;

    always #5 clk = ~clk;

    packet_decoder dut (
        .clk(clk),
        .rst_n(rst_n),
        .fifo_out_valid(fifo_out_valid),
        .fifo_out_data(fifo_out_data),
        .tx_valid(tx_valid),
        .rx_ready(rx_ready),
        .flit_en(flit_en),
        .flit_valid(flit_valid),
        .flit_data(flit_data),
        .cxs_last(cxs_last),
        .segment_valid(segment_valid),
        .segment_start(segment_start),
        .segment_last(segment_last),
        .dp(),
        .cp(),
        .rsvd(),
        .cxsmaxpktperflit(),
        .cxsdataflitwidth(),
        .cxs_cntl(),
        .decoder_error(),
        .packet_drop()
    );

    initial begin
        clk = 1'b0;
        rst_n = 1'b0;
        fifo_out_valid = 1'b0;
        fifo_out_data  = 512'b0;
        tx_valid = 1'b0;
        rx_ready = 1'b0;

        // Reset
        #20 rst_n = 1'b1;
        #10 tx_valid = 1'b1;
        #10 rx_ready = 1'b1;
      fifo_out_valid = 1'b1;

        // FIFO provides 512-bit packet
        fifo_out_data = {
            256'hBBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB_BBBB, // upper
            256'h1AAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA_AAAA  // lower
        };

                // Allow both flits
        #40;

        rx_ready = 1'b0;
        tx_valid = 1'b0;
        fifo_out_valid = 1'b0;
        fifo_out_data = 512'b0;
        #30 $finish;
    end
  initial begin
    $dumpfile("dump.vcd"); $dumpvars;
  end
endmodule
