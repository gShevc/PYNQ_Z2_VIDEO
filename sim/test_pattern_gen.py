import cocotb
import os
import random
import sys
import logging
from pathlib import Path
from cocotb.triggers import Timer
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner
 

 
@cocotb.test()
async def first_test(dut):
    dut.sel_in.value = 1
    dut.hcount_in.value = 640
    dut.vcount_in.value = 360
    dut._log.info(f"qm_out = {dut.red_out.value}")
    dut._log.info(f"qm_out = {dut.green_out.value}")
    dut._log.info(f"qm_out = {dut.blue_out.value}")

    await Timer(5, units="ns")
    dut.hcount_in.value = 642
    dut.vcount_in.value = 362
    dut._log.info(f"qm_out = {dut.red_out.value}")
    dut._log.info(f"qm_out = {dut.green_out.value}")
    dut._log.info(f"qm_out = {dut.blue_out.value}")

    await Timer(5, units="ns")
    dut.sel_in.value = 1

    dut.hcount_in.value = 42
    dut.vcount_in.value = 12
    dut._log.info(f"qm_out = {dut.red_out.value}")
    dut._log.info(f"qm_out = {dut.green_out.value}")
    dut._log.info(f"qm_out = {dut.blue_out.value}")
    await Timer(5, units="ns")
    dut.sel_in.value = 2
    dut.hcount_in.value = 42
    dut.vcount_in.value = 12
    dut._log.info(f"qm_out = {dut.red_out.value}")
    dut._log.info(f"qm_out = {dut.green_out.value}")
    dut._log.info(f"qm_out = {dut.blue_out.value}")



    await Timer(5, units="ns")
    



def counter_runner():
    """Simulate the counter using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [proj_path / "hdl" / "test_pattern_generator.sv"] #grow/modify this as needed.
    build_test_args = ["-Wall"]#,"COCOTB_RESOLVE_X=ZEROS"]
    parameters = {}
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="test_pattern_generator",
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel="test_pattern_generator",
        test_module="test_pattern_gen",
        test_args=run_test_args,
        waves=True
    )
 
if __name__ == "__main__":
    counter_runner()