module cocotb_iverilog_dump();
initial begin
    $dumpfile("/home/ghermann/6.205/cocotb/sim/sim_build/image_sprite_2.fst");
    $dumpvars(0, image_sprite_2);
end
endmodule
