module packet_decoder (
    input  logic         clk,               //input clock
    input  logic         rst_n,             // asynchronus active low reset

    input  logic         fifo_out_valid,    //valid is there if fifo has valid data
  input  logic [511:0] fifo_out_data,      //fifo 512 bit data

    input  logic         tx_valid,        //valid from transmitter
    input  logic         rx_ready, //indicates receiver is ready to take data

    output logic         flit_en,     //output for packet decoder
    output logic         flit_valid,   //output indicated flit is valid
  output logic [255:0] flit_data,      //flit output data 

    output logic         dp,     //data parity
    output logic         cp,     //clock parity
  output logic [204:0] rsvd,   //reseved 
  output logic [1:0]   cxsmaxpktperflit, //max no.of packets per flit
  output logic [1:0]   cxsdataflitwidth, // width of packet
    output logic         cxs_last, //last data
  output logic [43:0]  cxs_cntl, //control information

    output logic         segment_valid,  //input to segment counter
    output logic         segment_start,  //start of segment
    output logic         segment_last,  // last segment

    output logic         decoder_error, //error in data of decoder
    output logic         packet_drop    //error occurs iinterface violation
);

    typedef enum logic [1:0] { IDLE, FLIT0, FLIT1 } state_t;
    state_t state;

    logic [511:0] fifo_reg;

    /* ---------------- FSM + FIFO capture ---------------- */
    always_ff @(posedge clk or negedge rst_n)
        if (!rst_n)    fifo_reg <= 1'b0;
        else if (state == IDLE & fifo_out_valid & tx_valid & rx_ready) 
           fifo_reg <= fifo_out_data;
    always_ff @(posedge clk or negedge rst_n)
      if (!rst_n) state <= 1'b0
       else if (state == IDLE & fifo_out_valid & tx_valid & rx_ready) 
          state <= FLIT0; 
       else if (state == FLIT0 & rx_ready) state <= FLIT1;
       else if (state == FLIT1 & rx_ready) state <= IDLE;
    /* ---------------- Flit outputs ---------------- */
    always_ff @(posedge clk or negedge rst_n)
      if (!rst_n)  flit_en <= 1'b0; 
      else if (rx_ready & state == FLIT0)  flit_en <= 1'b1;
   always_ff @(posedge clk or negedge rst_n)
     if (!rst_n)  flit_valid <= 1'b0; 
      else if (rx_ready & state == FLIT0)  flit_valid <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  flit_data <= 1'b0; 
     else if (rx_ready & state == FLIT0)   flit_data <= fifo_reg[255:0];
   always_ff @(posedge clk or negedge rst_n)
     if (!rst_n)  segment_valid <= 1'b0; 
  else if (rx_ready & state == FLIT0)   segment_valid <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  segment_start <= 1'b0; 
  else if (rx_ready & state == FLIT0)   segment_start <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
      if (!rst_n)  flit_en <= 1'b0; 
      else if (rx_ready & state == FLIT1)  flit_en <= 1'b1;
   always_ff @(posedge clk or negedge rst_n)
     if (!rst_n)  flit_valid <= 1'b0; 
     else if (rx_ready & state == FLIT1)   flit_valid <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  flit_data <= 1'b0; 
  else if (rx_ready & state == FLIT1)   flit_data <= fifo_reg[511:256];
   always_ff @(posedge clk or negedge rst_n)
     if (!rst_n)  segment_valid <= 1'b0; 
  else if (rx_ready & state == FLIT1)   segment_valid <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  segment_start <= 1'b0; 
  else if (rx_ready & state == FLIT1)   segment_start <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  segment_last <= 1'b0; 
  else if (rx_ready & state == FLIT1)   segment_last <= 1'b1;
  always_ff @(posedge clk or negedge rst_n)
    if (!rst_n)  cxs_last <= 1'b0; 
  else if (rx_ready & state == FLIT1)   cxs_last <= 1'b1;    

    /* ---------------- Header fields ---------------- */
    assign { dp, cp, rsvd,
             cxsmaxpktperflit,
             cxsdataflitwidth,
             cxs_cntl } = fifo_reg[255:0];

    /* ---------------- Status ---------------- */
    assign decoder_error = 1'b0;
    assign packet_drop   = 1'b0;

endmodule