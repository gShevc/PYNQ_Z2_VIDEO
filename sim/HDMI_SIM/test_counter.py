import cocotb
import os
import random
import sys
import logging
from pathlib import Path
from cocotb.triggers import Timer
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner
 
async def generate_clock(clock_wire):
	while True: # repeat forever
		clock_wire.value = 0
		await Timer(5,units="ns")
		clock_wire.value = 1
		await Timer(5,units="ns")
 
@cocotb.test()
async def first_test(dut):
    """First cocotb test?"""
    await cocotb.start( generate_clock( dut.clk_in ) ) #launches clock
    dut.rst_in.value = 1;
    dut.period_in.value = 3;
    await Timer(5, "ns")
    await Timer(5, "ns")
    dut.rst_in.value = 0; #rst is off...let it run
    count = dut.count_out.value
    dut._log.info(f"Checking count_out @ {gst('ns')} ns: count_out: {count}")
    await Timer(5, "ns")
    await Timer(5, "ns")
    count = dut.count_out.value
    dut._log.info(f"Checking count_out @ {gst('ns')} ns: count_out: {count}")
    await Timer(5, "ns")
    await Timer(5, "ns")
    count = dut.count_out.value
    dut._log.info(f"Checking count_out @ {gst('ns')} ns: count_out: {count}")

    
def counter_runner():
    """Simulate the counter using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [proj_path / "hdl" / "counter.sv"] #grow/modify this as needed.
    build_test_args = ["-Wall"]#,"COCOTB_RESOLVE_X=ZEROS"]
    parameters = {}
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="counter",
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel="counter",
        test_module="test_counter",
        test_args=run_test_args,
        waves=True
    )
 
if __name__ == "__main__":
    counter_runner()