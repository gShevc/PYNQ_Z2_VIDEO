module cocotb_iverilog_dump();
initial begin
    $dumpfile("/home/ghermann/6.205/cocotb/sim/sim_build/video_sig_generator.fst");
    $dumpvars(0, video_sig_generator);
end
endmodule
