`default_nettype none
module pong (
    input  wire        pixel_clk_in,
    input  wire        rst_in,
    input  wire [1:0]  control_in,
    input  wire [3:0]  puck_speed_in,
    input  wire [3:0]  paddle_speed_in,
    input  wire        nf_in,
    input  wire [10:0] hcount_in,
    input  wire [9:0]  vcount_in,
    output logic [7:0] red_out,
    output logic [7:0] green_out,
    output logic [7:0] blue_out
);

  localparam PADDLE_WIDTH  = 16;
  localparam PADDLE_HEIGHT = 128;
  localparam PUCK_WIDTH    = 128;
  localparam PUCK_HEIGHT   = 128;
  localparam GAME_WIDTH    = 1280;
  localparam GAME_HEIGHT   = 720;

  // State registers
  logic [10:0] puck_x, paddle_x;
  logic [9:0]  puck_y, paddle_y;
  logic        dir_x, dir_y;
  logic        game_over;

  // Next-state wires
  logic [10:0] puck_x_next;
  logic [9:0]  puck_y_next;
  logic        dir_x_next, dir_y_next;

  // Sprite outputs
  logic [7:0] puck_r, puck_g, puck_b;
  logic [7:0] paddle_r, paddle_g, paddle_b;

  // Control inputs
  wire up   = control_in[1];
  wire down = control_in[0];

  // Paddle and puck sprites
  block_sprite #(.WIDTH(PADDLE_WIDTH), .HEIGHT(PADDLE_HEIGHT)) paddle (
      .hcount_in(hcount_in),
      .vcount_in(vcount_in),
      .x_in(paddle_x),
      .y_in(paddle_y),
      .red_out(paddle_r),
      .green_out(paddle_g),
      .blue_out(paddle_b)
  );

  block_sprite #(.WIDTH(PUCK_WIDTH), .HEIGHT(PUCK_HEIGHT)) puck (
      .hcount_in(hcount_in),
      .vcount_in(vcount_in),
      .x_in(puck_x),
      .y_in(puck_y),
      .red_out(puck_r),
      .green_out(puck_g),
      .blue_out(puck_b)
  );

  assign red_out   = puck_r   | paddle_r;
  assign green_out = puck_g   | paddle_g;
  assign blue_out  = puck_b   | paddle_b;

  // Combinational next state logic
  always_comb begin
    puck_x_next = puck_x;
    puck_y_next = puck_y;
    dir_x_next = dir_x;
    dir_y_next = dir_y;

    if (~game_over && nf_in) begin
      // Wall collisions
      if (puck_x + PUCK_WIDTH >= GAME_WIDTH || puck_x <= 0)
        dir_x_next = ~dir_x_next;
      if (puck_y + PUCK_HEIGHT >= GAME_HEIGHT || puck_y <= 0)
        dir_y_next = ~dir_y_next;

      // Move puck
      puck_x_next = dir_x_next ? puck_x + puck_speed_in : puck_x - puck_speed_in;
      dir_y_next = dir_y_next ? puck_y + puck_speed_in : puck_y - puck_speed_in;
    end
  end

  // Synchronous logic
  always_ff @(posedge pixel_clk_in) begin
    if (rst_in) begin
      puck_x    <= GAME_WIDTH / 2 - PUCK_WIDTH / 2;
      puck_y    <= GAME_HEIGHT / 2 - PUCK_HEIGHT / 2;
      dir_x     <= hcount_in[0];
      dir_y     <= hcount_in[1];
      paddle_x  <= 0;
      paddle_y  <= GAME_HEIGHT / 2 - PADDLE_HEIGHT / 2;
      game_over <= 0;
    end else begin
      puck_x  <= puck_x_next;
      puck_y  <= puck_y_next;
      dir_x   <= dir_x_next;
      dir_y   <= dir_y_next;

      // Paddle movement
      if (up && paddle_y > 0)
        paddle_y <= paddle_y - paddle_speed_in;
      else if (down && (paddle_y + PADDLE_HEIGHT < GAME_HEIGHT))
        paddle_y <= paddle_y + paddle_speed_in;
    end
  end

endmodule
`default_nettype wire
