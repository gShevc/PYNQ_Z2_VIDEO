module video_sig_generator (
    input logic pixel_clk_in,              // 74.5 MHz clock
    input logic rst_in,            // Asynchronous reset

    output logic hs_out,          // Horizontal sync pulse
    output logic vs_out,          // Vertical sync pulse
    output logic [11:0] x,         // H count output
    output logic [9:0] y,         // V count output
    output logic blank,           // High when in visible region
    output logic sync,
    output logic ad_out,
    output logic nf_out, //single cycle enable signal
    output logic [5:0] fc_out //Counter keeps track of the frame, 60
);

 
 



    parameter H_VISIBLE = 1280;
    parameter H_FRONT   = 110;
    parameter H_SYNC    = 40;
    parameter H_BACK    = 220;
    parameter H_TOTAL   = H_VISIBLE + H_FRONT + H_SYNC + H_BACK;

    parameter V_VISIBLE = 720;
    parameter V_FRONT   = 5;
    parameter V_SYNC    = 5;
    parameter V_BACK    = 20;
    parameter V_TOTAL   = V_VISIBLE + V_FRONT + V_SYNC + V_BACK;

    // Counters
    logic [11:0] h_count;
    logic [9:0] v_count;

    // Sync signals
    logic h_sync, v_sync;

    logic nf_reg;

    // Position output
   // assign x = (h_count < H_VISIBLE) ? h_count : 10'd0;
  //  assign y = (v_count < V_VISIBLE) ? v_count : 10'd0;

   assign x = h_count;
   assign y = v_count;

    assign blank = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);


    assign hs_out = ~h_sync;
    assign vs_out = ~v_sync;

    // Fixed for VGA: no composite sync
    assign sync = 1'b0;
    assign nf_out = nf_reg;

    // Sync & display logic
    always_ff @(posedge pixel_clk_in) begin
        if (rst_in) begin
            h_count <= 0;
            v_count <= 0;
            h_sync  <= 1'b1;
            v_sync  <= 1'b1;
            fc_out<= 0;
            nf_reg <= 0;
        end else begin
             nf_reg <= (h_count == 0 && v_count == 0);

            if (nf_out) begin
    if (fc_out == 6'd59)
        fc_out <= 0;
    else
        fc_out <= fc_out + 1;
            end 
             
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;

                if (v_count == V_TOTAL - 1)begin
                    v_count <= 0;
                    end
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
             
             if (h_count >= H_VISIBLE + H_FRONT &&
                h_count <  H_VISIBLE + H_FRONT + H_SYNC)
                h_sync <= 1'b1;
            else
                h_sync <= 1'b0;

             if (v_count >= V_VISIBLE + V_FRONT &&
                v_count <  V_VISIBLE + V_FRONT + V_SYNC)
                v_sync <= 1'b1;
            else
                v_sync <= 1'b0;

            // RGB output logic (only in visible area)
            if ((h_count < H_VISIBLE) && (v_count < V_VISIBLE)) begin
                
                ad_out <= 1'b1;
            end else begin
                ad_out <= 0;

            end
        end
    end
endmodule
