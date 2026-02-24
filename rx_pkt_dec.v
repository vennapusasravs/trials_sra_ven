module packet_decoder (
    input  logic         clk,               // input clock
    input  logic         rst_n,             // asynchronous active-low reset
    input  logic         fifo_out_valid,    // fifo has valid data
    input  logic [511:0] fifo_out_data,     // fifo 512-bit data
    input  logic         tx_valid,           // transmitter valid
    input  logic         rx_ready,            // receiver ready
    output logic         flit_en,
    output logic         flit_valid,
    output logic [255:0] flit_data,
    output logic         dp,
    output logic         cp,
    output logic [204:0] rsvd,
    output logic [1:0]   cxsmaxpktperflit,
    output logic [1:0]   cxsdataflitwidth,
    output logic         cxs_last,
    output logic [43:0]  cxs_cntl,
    output logic         segment_valid,
    output logic         segment_start,
    output logic         segment_last,
    output logic         decoder_error,
    output logic         packet_drop
);

    /* -------- State encoding (NO enum) -------- */
    parameter logic [1:0]
        IDLE  = 2'b00,
        FLIT0 = 2'b01,
        FLIT1 = 2'b10;

    logic [1:0] state;
    logic [511:0] fifo_reg;

    /* -------- FIFO capture -------- */
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) fifo_reg <= 1'b0;
        else if (state == IDLE & fifo_out_valid & tx_valid & rx_ready)
            fifo_reg <= fifo_out_data;

    /* -------- FSM -------- */
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n) state <= IDLE;
        else if (state == IDLE  & fifo_out_valid & tx_valid & rx_ready)
            state <= FLIT0;
        else if (state == FLIT0 & rx_ready) state <= FLIT1;
        else if (state == FLIT1 & rx_ready) state <= IDLE;
    /* -------- Flit & Segment outputs (single always_ff) -------- */
    always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n)
    {flit_en,flit_valid,segment_valid,segment_start,segment_last,cxs_last, flit_data } <= 1'b0;
    else 
      begin
        { flit_en, flit_valid, segment_valid,segment_start, segment_last, cxs_last, flit_data } <= 1'b0;
        if (rx_ready & state == FLIT0)
            { flit_en, flit_valid, segment_valid,segment_start, segment_last, cxs_last,flit_data } <= {1'b1,1'b1,1'b1,1'b1,1'b0,1'b0,fifo_reg[255:0]};
        else if (rx_ready & state == FLIT1)
            { flit_en, flit_valid, segment_valid, segment_start,segment_last, cxs_last,flit_data } <= {1'b1,1'b1,1'b1,1'b0, 1'b1,1'b1,fifo_reg[511:256] };
    end
end

    /* -------- Header decode -------- */
    assign { dp, cp, rsvd,cxsmaxpktperflit,cxsdataflitwidth,
             cxs_cntl } = fifo_reg[255:0];

    /* -------- Status -------- */
    assign decoder_error = 1'b0;
    assign packet_drop   = 1'b0;

endmodule
