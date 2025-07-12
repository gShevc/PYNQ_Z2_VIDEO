`timescale 1ns / 1ps
`default_nettype none

module pixel_reconstruct
#(
    parameter HCOUNT_WIDTH = 11,
    parameter VCOUNT_WIDTH = 10
)
(
    input wire clk_in,
    input wire rst_in,
    input wire camera_pclk_in,
    input wire camera_hs_in,
    input wire camera_vs_in,
    input wire [7:0] camera_data_in,
    output logic pixel_valid_out,
    output logic [HCOUNT_WIDTH-1:0] pixel_hcount_out,
    output logic [VCOUNT_WIDTH-1:0] pixel_vcount_out,
    output logic [15:0] pixel_data_out
);

// FSM state definition
typedef enum logic [1:0] {
    IDLE = 2'b00,
    MSB = 2'b01,
    LSB = 2'b10,
    OUTPUT_PIXEL = 2'b11
} State;

State state, next_state;

// Internal signals
logic pclk_prev;
logic pclk_rising;
logic camera_sample_valid;
logic [7:0] last_sampled_data;
logic vs_prev;
logic vs_falling;
logic hs_prev;
logic hs_falling;

// Edge detection
assign pclk_rising = (pclk_prev == 1'b0 && camera_pclk_in == 1'b1);
assign camera_sample_valid = (pclk_rising && camera_hs_in && camera_vs_in);
assign vs_falling = (vs_prev == 1'b1 && camera_vs_in == 1'b0);
assign hs_falling = (hs_prev == 1'b1 && camera_hs_in == 1'b0);

// Next-state logic (FSM control)
always_comb begin
    next_state = state; // default
    case (state)
        IDLE: begin
            if (camera_sample_valid)
                next_state = MSB;
        end
        MSB: begin
            if (camera_sample_valid)
                next_state = LSB;
        end
        LSB: begin
            if (camera_sample_valid)
                next_state = OUTPUT_PIXEL;
        end
        OUTPUT_PIXEL: begin
            next_state = MSB; // Continue processing next pixel
        end
    endcase
end

// Sequential logic
always_ff @(posedge clk_in) begin
    // Edge detection registers
    pclk_prev <= camera_pclk_in;
    vs_prev <= camera_vs_in;
    hs_prev <= camera_hs_in;
    
    if (rst_in) begin
        pixel_valid_out <= 1'b0;
        pixel_hcount_out <= '0;
        pixel_vcount_out <= '0;
        pixel_data_out <= '0;
        state <= IDLE;
        last_sampled_data <= '0;
    end else begin
        state <= next_state;
        pixel_valid_out <= 1'b0; // default
        
        if (vs_falling) begin
            pixel_vcount_out <= '0;
            pixel_hcount_out <= '0;
        end else if (hs_falling) begin
            pixel_hcount_out <= '0;
            if (pixel_vcount_out < (1 << VCOUNT_WIDTH) - 1)
                pixel_vcount_out <= pixel_vcount_out + 1;
        end
        
        case (state)
            IDLE: begin
            end
            MSB: begin
                if (camera_sample_valid) begin
                    last_sampled_data <= camera_data_in;
                end
            end
            LSB: begin
                if (camera_sample_valid) begin
                    pixel_data_out <= {last_sampled_data, camera_data_in};
                end
            end
            OUTPUT_PIXEL: begin
                pixel_valid_out <= 1'b1;
                if (pixel_hcount_out < (1 << HCOUNT_WIDTH) - 1)
                    pixel_hcount_out <= pixel_hcount_out + 1;
            end
        endcase
    end
end

endmodule

`default_nettype wire