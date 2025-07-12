import cocotb
import os
import random
import sys
import logging
from pathlib import Path
from cocotb.triggers import Timer
from cocotb.utils import get_sim_time as gst
from cocotb.runner import get_runner
 
# Clock generation tasks
async def generate_clock(clock_wire):
    while True:
        clock_wire.value = 0
        await Timer(5, units="ns")
        clock_wire.value = 1
        await Timer(5, units="ns")

async def generate_clock_pclk(clock_wire):
    while True:
        clock_wire.value = 0
        await Timer(10, units="ns")
        clock_wire.value = 1
        await Timer(10, units="ns")

@cocotb.test()
async def pixel_reconstruct_test(dut):
    """Expanded test for pixel_reconstruct."""

    # Start the system and PCLK clocks
    cocotb.start_soon(generate_clock(dut.clk_in))
    cocotb.start_soon(generate_clock_pclk(dut.camera_pclk_in))

    # Initialize all inputs
    dut.rst_in.value = 1
    dut.camera_hs_in.value = 0
    dut.camera_vs_in.value = 0
    dut.camera_data_in.value = 0

    # Hold reset for a bit
    await Timer(20, units="ns")
    dut.rst_in.value = 0

    # Simulate start of a frame and row
    dut.camera_vs_in.value = 1
    dut.camera_hs_in.value = 1

    # --- Send 3 pixels = 6 bytes ---
    pixels = [
        (0x12, 0x34),  # pixel 1
        (0x56, 0x78),  # pixel 2
        (0x9A, 0xBC),  # pixel 3
    ]

    for msb, lsb in pixels:
        # Send first byte (MSB)
        dut.camera_data_in.value = msb
        await Timer(20, units="ns")  # Wait one PCLK cycle

        # Send second byte (LSB)
        dut.camera_data_in.value = lsb
        await Timer(20, units="ns")  # Wait one PCLK cycle

        # Print output if pixel_valid_out is high
        if dut.pixel_valid_out.value.integer == 1:
            pixel = dut.pixel_data_out.value.integer
            h = dut.pixel_hcount_out.value.integer
            v = dut.pixel_vcount_out.value.integer
            dut._log.info(f"Pixel VALID: ({h}, {v}) = 0x{pixel:04X}")
        else:
            dut._log.warning("Expected pixel_valid_out but got 0")

    # Simulate end of row
    dut.camera_hs_in.value = 0
    await Timer(20, units="ns")
    dut.camera_hs_in.value = 1

    # Simulate end of frame
    dut.camera_vs_in.value = 0
    await Timer(20, units="ns")
    dut.camera_vs_in.value = 1

    # Wait a bit and finish
    await Timer(100, units="ns")



def counter_runner():
    """Simulate the counter using the Python runner."""
    hdl_toplevel_lang = os.getenv("HDL_TOPLEVEL_LANG", "verilog")
    sim = os.getenv("SIM", "icarus")
    proj_path = Path(__file__).resolve().parent.parent
    sys.path.append(str(proj_path / "sim" / "model"))
    sources = [proj_path / "hdl" / "pixel_reconstruct.sv"] #grow/modify this as needed.
    build_test_args = ["-Wall"]#,"COCOTB_RESOLVE_X=ZEROS"]
    parameters = {}
    sys.path.append(str(proj_path / "sim"))
    runner = get_runner(sim)
    runner.build(
        sources=sources,
        hdl_toplevel="pixel_reconstruct",
        always=True,
        build_args=build_test_args,
        parameters=parameters,
        timescale = ('1ns','1ps'),
        waves=True
    )
    run_test_args = []
    runner.test(
        hdl_toplevel="pixel_reconstruct",
        test_module="test_pixel_reconstruct",
        test_args=run_test_args,
        waves=True
    )
 
if __name__ == "__main__":
    counter_runner()