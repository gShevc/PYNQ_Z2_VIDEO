module cocotb_iverilog_dump();
initial begin
    $dumpfile("/home/ghermann/6.205/cocotb/sim/sim_build/pixel_reconstruct.fst");
    $dumpvars(0, pixel_reconstruct);
end
endmodule
