module test_pattern_generator(
  input wire [1:0] sel_in,
  input wire [10:0] hcount_in,
  input wire [9:0] vcount_in,
  output logic [7:0] red_out,
  output logic [7:0] green_out,
  output logic [7:0] blue_out
  );





always_comb begin
  case (sel_in)
    2'b00: begin
      red_out   = 8'h99;
      green_out = 8'h33;
      blue_out  = 8'hFF;
    end

    2'b01: begin
      if (hcount_in == 640 || vcount_in == 360) begin
        red_out   = 8'hFF;
        green_out = 8'hFF;
        blue_out  = 8'hFF;
      end else begin
        red_out   = 8'h00;
        green_out = 8'h00;
        blue_out  = 8'h00;
      end
    end

    2'b10: begin
      red_out [7:0]  = hcount_in[7:0];
      green_out[7:0] = hcount_in[7:0];
      blue_out[7:0]  = hcount_in[7:0];
    end

    2'b11: begin
      red_out [7:0]  = hcount_in[7:0];
      green_out[7:0] = vcount_in[7:0];
      blue_out[7:0]  = hcount_in[7:0] + vcount_in[7:0];
    end
  endcase


    end


endmodule