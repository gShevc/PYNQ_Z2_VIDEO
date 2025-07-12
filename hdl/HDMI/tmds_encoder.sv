`timescale 1ns / 1ps
`default_nettype none

module tmds_encoder(
  input  wire       clk_in,
  input  wire       rst_in,
  input  wire [7:0] data_in,
  input  wire [1:0] control_in,
  input  wire       ve_in,
  output logic [9:0] tmds_out
);

  logic [8:0] q_m;
  logic [4:0] tally;  // Running disparity (signed 5-bit)
  int num_ones_q_m;       // temp count of ones
  int num_ones_data_in;       // temp count of ones

  logic        invert;
  logic [7:0]  data_bits;

  // Instantiates first-stage encoder
  tm_choice mtm (
    .data_in(data_in),
    .qm_out(q_m)
  );

  always_ff @(posedge clk_in) begin
    if (rst_in) begin
      tally <= 5'd0;
      tmds_out <= 10'd0;

    end else if (!ve_in) begin
      // Control symbols when video disabled
      tally <= 5'd0;
      case (control_in)
        2'b00: tmds_out <= 10'b1101010100;
        2'b01: tmds_out <= 10'b0010101011;
        2'b10: tmds_out <= 10'b0101010100;
        2'b11: tmds_out <= 10'b1010101011;
        default: tmds_out <= 10'b0000000000;
      endcase

    end else begin
      // TMDS data encoding when ve_in == 1
      num_ones_q_m = $countones(q_m[7:0]);
      num_ones_data_in = $countones(data_in[7:0]); 

      // Decision to invert
      if ((tally[4] == 1 && num_ones_q_m < 4) ||
          (tally[4] == 0 && num_ones_q_m > 4)) begin
        invert = 1;
      end else begin
        invert = 0;
      end


      data_bits = invert ? ~q_m[7:0] : q_m[7:0];

      tmds_out <= {invert, q_m[8], data_bits};

      if (invert)
        tally <= tally + (8 - 2 * num_ones_q_m);
      else
        tally <= tally + (2 * num_ones_q_m - 8);
    end
  end


endmodule

`default_nettype wire
