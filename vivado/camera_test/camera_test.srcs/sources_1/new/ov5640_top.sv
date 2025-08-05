module camera_test_top (
    // Clock and reset
    input wire clk_125mhz,          // Main system clock from PYNQ-Z2
    input wire rst_n,               // Active low reset (matches XDC)
    
    // User inputs
    input wire [1:0] sw,            // Switches
    input wire [2:0] btn,           // Buttons (only 0-2 defined in XDC)
    
    // OV5640 Camera Interface
    input wire cam_pclk,            // Pixel clock from camera
    input wire cam_href,            // Horizontal reference
    input wire cam_vsync,           // Vertical sync
    input wire [7:0] cam_data,      // 8-bit pixel data
    
    // Camera I2C interface
    inout wire cam_sioc,            // I2C clock
    inout wire cam_siod,            // I2C data
    
    // Camera control
    output wire cam_xclk,           // External clock to camera
    
    // HDMI outputs (defined in XDC)
    output wire hdmi_tx_cec,
    output wire hdmi_clk_n,
    output wire hdmi_clk_p,
    output wire [2:0] hdmi_tx_n,
    output wire [2:0] hdmi_tx_p,
    output wire hdmi_tx_hpdn,
    
    // Status LEDs on PYNQ-Z2
    output wire [3:0] led
);

    // Use rst_n directly (matches XDC naming)
    wire reset_n = rst_n;
    
    // Generate camera external clock (24MHz from 125MHz system clock)
    reg [2:0] clk_div_counter;
    reg cam_xclk_reg;
    
    always @(posedge clk_125mhz or negedge reset_n) begin
        if (!reset_n) begin
            clk_div_counter <= 3'b000;
            cam_xclk_reg <= 1'b0;
        end else begin
            if (clk_div_counter == 3'b010) begin  // Divide by ~5 for ~25MHz
                clk_div_counter <= 3'b000;
                cam_xclk_reg <= ~cam_xclk_reg;
            end else begin
                clk_div_counter <= clk_div_counter + 1'b1;
            end
        end
    end
    
    assign cam_xclk = cam_xclk_reg;
    
    // Pixel and line counters for debugging
    reg [15:0] pixel_count;
    reg [15:0] line_count;
    reg prev_href, prev_vsync;
    reg frame_valid;
    
    // Clock domain crossing registers for the camera signals
    reg cam_pclk_sync1, cam_pclk_sync2;
    reg cam_href_sync, cam_vsync_sync;
    reg [7:0] cam_data_sync;
    
    // Synchronize camera signals to system clock domain
    always @(posedge clk_125mhz or negedge reset_n) begin
        if (!reset_n) begin
            cam_pclk_sync1 <= 1'b0;
            cam_pclk_sync2 <= 1'b0;
            cam_href_sync <= 1'b0;
            cam_vsync_sync <= 1'b0;
            cam_data_sync <= 8'h00;
        end else begin
            cam_pclk_sync1 <= cam_pclk;
            cam_pclk_sync2 <= cam_pclk_sync1;
            cam_href_sync <= cam_href;
            cam_vsync_sync <= cam_vsync;
            cam_data_sync <= cam_data;
        end
    end
    
    // Detect positive edge of pixel clock for pixel counting
    wire pclk_rising_edge = cam_pclk_sync1 & ~cam_pclk_sync2;
    
    // Frame and pixel counting logic
    always @(posedge clk_125mhz or negedge reset_n) begin
        if (!reset_n) begin
            pixel_count <= 16'h0000;
            line_count <= 16'h0000;
            prev_href <= 1'b0;
            prev_vsync <= 1'b0;
            frame_valid <= 1'b0;
        end else begin
            prev_href <= cam_href_sync;
            prev_vsync <= cam_vsync_sync;
            
            // Detect start of new frame (vsync rising edge)
            if (cam_vsync_sync && !prev_vsync) begin
                line_count <= 16'h0000;
                frame_valid <= 1'b1;
            end
            
            // Detect start of new line (href rising edge)
            if (cam_href_sync && !prev_href) begin
                pixel_count <= 16'h0000;
                if (frame_valid) begin
                    line_count <= line_count + 1'b1;
                end
            end
            
            // Count pixels during href active period
            if (cam_href_sync && pclk_rising_edge) begin
                pixel_count <= pixel_count + 1'b1;
            end
            
            // End frame on vsync falling edge
            if (!cam_vsync_sync && prev_vsync) begin
                frame_valid <= 1'b0;
            end
        end
    end
    
    // LED indicators for visual feedback
    assign led[0] = frame_valid;                    // LED0: Frame in progress
    assign led[1] = cam_href_sync;                  // LED1: Line active
    assign led[2] = |cam_data_sync;                 // LED2: Non-zero pixel data
    assign led[3] = |line_count[15:8];              // LED3: High line count (many lines processed)

    // Simple I2C tri-state control (for basic operation)
    assign cam_sioc = 1'bz;  // Let external pullups handle I2C
    assign cam_siod = 1'bz;  // Let external pullups handle I2C
    
    // HDMI outputs - tie off for now (not used in camera test)
    assign hdmi_tx_cec = 1'b0;
    assign hdmi_clk_n = 1'b0;
    assign hdmi_clk_p = 1'b0;
    assign hdmi_tx_n = 3'b000;
    assign hdmi_tx_p = 3'b000;
    assign hdmi_tx_hpdn = 1'b0;

    // ILA for debugging - only probe the essential camera signals
    ila_0 ila_inst (
        .clk(clk_125mhz),
        .probe0(cam_data_sync),         // 8 bits - pixel data
        .probe1(cam_href_sync),         // 1 bit - horizontal reference
        .probe2(cam_vsync_sync),        // 1 bit - vertical sync
        .probe3(cam_pclk),              // 1 bit - pixel clock
        .probe4(frame_valid),           // 1 bit - frame valid flag
        .probe5(pixel_count[0])      // 8 bits - lower pixel count
    );

endmodule