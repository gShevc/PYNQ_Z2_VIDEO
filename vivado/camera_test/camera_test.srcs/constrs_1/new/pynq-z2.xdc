
set_property PACKAGE_PIN H16 [get_ports clk_125mhz]
set_property IOSTANDARD LVCMOS33 [get_ports clk_125mhz]
create_clock -period 8.000 -name sys_clk -waveform {0.000 4.000} [get_ports clk_125mhz]


set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]


set_property PACKAGE_PIN M13 [get_ports hdmi_clk]
set_property PACKAGE_PIN V14 [get_ports {hdmi_d[0]}]
set_property PACKAGE_PIN H14 [get_ports {hdmi_d[1]}]
set_property PACKAGE_PIN J14 [get_ports {hdmi_d[2]}]
set_property PACKAGE_PIN K13 [get_ports {hdmi_d[3]}]
set_property PACKAGE_PIN K14 [get_ports {hdmi_d[4]}]
set_property PACKAGE_PIN L13 [get_ports {hdmi_d[5]}]
set_property PACKAGE_PIN L19 [get_ports {hdmi_d[6]}]
set_property PACKAGE_PIN L20 [get_ports {hdmi_d[7]}]
set_property PACKAGE_PIN K17 [get_ports {hdmi_d[8]}]
set_property PACKAGE_PIN J17 [get_ports {hdmi_d[9]}]
set_property PACKAGE_PIN L16 [get_ports {hdmi_d[10]}]
set_property PACKAGE_PIN K16 [get_ports {hdmi_d[11]}]
set_property PACKAGE_PIN L14 [get_ports {hdmi_d[12]}]
set_property PACKAGE_PIN L15 [get_ports {hdmi_d[13]}]
set_property PACKAGE_PIN M15 [get_ports {hdmi_d[14]}]
set_property PACKAGE_PIN M16 [get_ports {hdmi_d[15]}]
set_property PACKAGE_PIN L18 [get_ports {hdmi_d[16]}]
set_property PACKAGE_PIN M18 [get_ports {hdmi_d[17]}]
set_property PACKAGE_PIN N18 [get_ports {hdmi_d[18]}]
set_property PACKAGE_PIN N19 [get_ports {hdmi_d[19]}]
set_property PACKAGE_PIN M20 [get_ports {hdmi_d[20]}]
set_property PACKAGE_PIN N20 [get_ports {hdmi_d[21]}]
set_property PACKAGE_PIN L21 [get_ports {hdmi_d[22]}]
set_property PACKAGE_PIN M21 [get_ports {hdmi_d[23]}]
set_property PACKAGE_PIN V13 [get_ports hdmi_de]
set_property PACKAGE_PIN T15 [get_ports hdmi_hs]
set_property PACKAGE_PIN J19 [get_ports hdmi_nreset]
set_property PACKAGE_PIN T14 [get_ports hdmi_vs]

set_property PACKAGE_PIN E16 [get_ports hdmi_scl]
set_property PACKAGE_PIN F16 [get_ports hdmi_sda]

set_property IOSTANDARD LVCMOS33 [get_ports hdmi_clk]
set_property IOSTANDARD LVCMOS33 [get_ports {hdmi_d[*]}]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_de]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_hs]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_nreset]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_vs]

set_property IOSTANDARD LVCMOS33 [get_ports hdmi_scl]
set_property IOSTANDARD LVCMOS33 [get_ports hdmi_sda]

set_property SLEW FAST [get_ports {hdmi_d[*]}]
set_property SLEW FAST [get_ports hdmi_de]
set_property SLEW FAST [get_ports hdmi_hs]
set_property SLEW FAST [get_ports hdmi_vs]

#create_clock -period 5.000 -name sys_clk_p -waveform {0.000 2.500} [get_ports sys_clk_p]





############## CMOS define##################
set_property PACKAGE_PIN W19 [get_ports cmos1_scl]
set_property PACKAGE_PIN Y16 [get_ports cmos1_vsync]
set_property PACKAGE_PIN W18 [get_ports cmos1_href]
set_property PACKAGE_PIN Y19 [get_ports cmos1_mclk]
set_property PACKAGE_PIN W16 [get_ports {cmos1_d[5]}]
set_property PACKAGE_PIN Y14 [get_ports {cmos1_d[4]}]
set_property PACKAGE_PIN T11 [get_ports {cmos1_d[3]}]
set_property PACKAGE_PIN V20 [get_ports {cmos1_d[2]}]

set_property PACKAGE_PIN Y17 [get_ports cmos1_sda]
set_property PACKAGE_PIN R16 [get_ports cmos1_reset] #Set to a button
#set_property PACKAGE_PIN N17 [get_ports cmos1_pwden]
set_property PACKAGE_PIN V16 [get_ports {cmos1_d[7]}]
set_property PACKAGE_PIN W14 [get_ports {cmos1_d[6]}]
set_property PACKAGE_PIN U19 [get_ports cmos1_pclk] #
set_property PACKAGE_PIN T10 [get_ports {cmos1_d[0]}]
set_property PACKAGE_PIN W13 [get_ports {cmos1_d[1]}]


set_property IOSTANDARD LVCMOS33 [get_ports cmos1_mclk]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_pwden]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_sda]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_scl]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {cmos1_d[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_pclk]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_href]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_vsync]
set_property IOSTANDARD LVCMOS33 [get_ports cmos1_reset]


set_property IOSTANDARD LVCMOS33 [get_ports sys_nrst]
set_property PACKAGE_PIN J21 [get_ports sys_nrst]

set_property CLOCK_DEDICATED_ROUTE FALSE [get_nets cmos1_pclk_IBUF]


#create_clock -period 11.905 -name cmos1_pclk -waveform {0.000 5.953} [get_ports cmos1_pclk]
