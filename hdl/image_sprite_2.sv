`timescale 1ns / 1ps
`default_nettype none

`ifdef SYNTHESIS
`define FPATH(X) `"X`"
`else /* ! SYNTHESIS */
`define FPATH(X) `"../../data/X`"
`endif  /* ! SYNTHESIS */

module image_sprite_2 #(
  parameter WIDTH=256, HEIGHT=256) (
  input wire pixel_clk_in,
  input wire rst_in,
  input wire [10:0] x_in, hcount_in,
  input wire [9:0]  y_in, vcount_in,
  input wire pop_in,
  output logic [7:0] red_out,
  output logic [7:0] green_out,
  output logic [7:0] blue_out
  );



                       // Output register enable
  logic [7:0] palette_address;          // RAM output data
  
  logic [23:0] palette_data_out;
  
  // calculate rom address
  //Add another bit to image_addr
  //Make the msb the select signal to choose between both sprites
  logic [$clog2(WIDTH*HEIGHT):0] image_addr;

  logic in_sprite;
  assign in_sprite = ((hcount_in >= x_in && hcount_in < (x_in + WIDTH)) &&
                      (vcount_in >= y_in && vcount_in < (y_in + HEIGHT)));

  // Modify the module below to use your BRAMs!
  assign red_out =    in_sprite ?  palette_data_out[23:16]: 0;
  assign green_out =  in_sprite ?  palette_data_out[15:8] : 0;
  assign blue_out =   in_sprite ?  palette_data_out[7:0]: 0;



//If pop in is high, we give an offset to the image ram of
//Half of the Depth of the ram
    always_comb begin
        if(in_sprite)begin
       image_addr = {pop_in,(hcount_in - x_in) + ((vcount_in - y_in) * WIDTH)};

        end
        else
        image_addr = {pop_in,(hcount_in - x_in) + ((vcount_in - y_in) * WIDTH)};


    end
 
 
  //  Xilinx Single Port Read First RAM
    xilinx_single_port_ram_read_first #(
    .RAM_WIDTH(8),                       // Specify RAM data width
    .RAM_DEPTH(131072),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE(`FPATH(image.mem))          // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) Image_Ram (
    .addra(image_addr),     // Address bus, width determined from RAM_DEPTH
    .dina(0),       // RAM input data, width determined from RAM_WIDTH
    .clka(pixel_clk_in),       // Clock
    .wea(0),         // Write enable
    .ena(1),         // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rst_in),       // Output reset (does not affect memory contents)
    .regcea(1),   // Output register enable
    .douta(palette_address)      // RAM output data, width determined from RAM_WIDTH
  );
 

// The following is an instantiation template for xilinx_single_port_ram_read_first

  //  Xilinx Single Port Read First RAM
  xilinx_single_port_ram_read_first #(
    .RAM_WIDTH(24),                       // Specify RAM data width
    .RAM_DEPTH(256),                     // Specify RAM depth (number of entries)
    .RAM_PERFORMANCE("HIGH_PERFORMANCE"), // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
    .INIT_FILE(`FPATH(palette.mem))          // Specify name/location of RAM initialization file if using one (leave blank if not)
  ) Palettte_Ram (
    .addra(palette_address),     // Address bus, width determined from RAM_DEPTH
    .dina(0),       // RAM input data, width determined from RAM_WIDTH
    .clka(pixel_clk_in),       // Clock
    .wea(0),         // Write enable
    .ena(1),         // RAM Enable, for additional power savings, disable port when not in use
    .rsta(rst_in),       // Output reset (does not affect memory contents)
    .regcea(1),   // Output register enable
    .douta(palette_data_out)      // RAM output data, width determined from RAM_WIDTH
  );





endmodule






`default_nettype none
