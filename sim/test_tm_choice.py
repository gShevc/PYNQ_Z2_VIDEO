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
    """First cocotb test?"""
    dut.data_in.value  = 0xFE
    dut._log.info(f"qm_out = {dut.qm_out.value}")
    await Timer(5, units="ns")

    dut.data_in.value = 0x01
    await Timer(5, units="ns")
    dut._log.info(f"qm_out = {dut.qm_out.value}")

    dut.data_in.value = 0x00
    await Timer(5, units="ns")
    dut._log.info(f"qm_out = {dut.qm_out.value}")
    





def counter_runner():
    """Simulate the counter using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [proj_path / "hdl" / "tm_choice.sv"] #grow/modify this as needed.
    build_test_args = ["-Wall"]#,"COCOTB_RESOLVE_X=ZEROS"]
    parameters = {}
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="tm_choice",
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel="tm_choice",
        test_module="test_tm_choice",
        test_args=run_test_args,
        waves=True
    )
 
if __name__ == "__main__":
    counter_runner()