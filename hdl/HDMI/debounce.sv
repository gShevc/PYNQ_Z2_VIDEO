module debounce (
  input logic clk,
  input logic reset,
  input logic dirty_in,
  output logic clean_out
);

  logic old;
  logic [19:0] count;
  localparam counts = 20'd1000000;

  always_ff @ (posedge clk or posedge reset) begin
    if (reset) begin
      old <= 0;
      count <= 0;
      clean_out <= 0;
    end else begin
      if (dirty_in == old) begin
        if (count < counts)
          count <= count + 1;
        else
          clean_out <= old; 
      end else begin
        count <= 0;        
        old <= dirty_in;   
      end
    end
  end

endmodule
