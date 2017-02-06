

# StdLib
set_property ASYNC_REG TRUE [get_cells -hierarchical *crossDomainSyncReg_reg*]

# FPGA Port Definitions 
set_property PACKAGE_PIN A15     [get_ports Pwron_Rst_L]
set_property IOSTANDARD  LVCMOS33 [get_ports Pwron_Rst_L]

# MGT signals
set_property PACKAGE_PIN E3       [get_ports PgpRx_M]
set_property PACKAGE_PIN E4       [get_ports PgpRx_P]
set_property PACKAGE_PIN A3       [get_ports PgpTx_M]
set_property PACKAGE_PIN A4       [get_ports PgpTx_P]
set_property PACKAGE_PIN D6       [get_ports PgpRefClk_P]
set_property PACKAGE_PIN D5       [get_ports PgpRefClk_M]

# Test Points and LEDs
set_property PACKAGE_PIN G21      [get_ports Test_12]
set_property PACKAGE_PIN H21      [get_ports Test_11]
set_property PACKAGE_PIN J21      [get_ports Test_10]
set_property PACKAGE_PIN H22      [get_ports Test_9]
set_property PACKAGE_PIN K22      [get_ports Test_8]
set_property PACKAGE_PIN L22      [get_ports Test_7]
set_property PACKAGE_PIN J23      [get_ports Test_6]
set_property PACKAGE_PIN K23      [get_ports Test_5]
set_property PACKAGE_PIN L23      [get_ports Test_4]
set_property PACKAGE_PIN H23      [get_ports Test_3]
set_property PACKAGE_PIN H24      [get_ports Test_2]
set_property PACKAGE_PIN J24      [get_ports Test_1]
set_property PACKAGE_PIN J25      [get_ports Test_0]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_12]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_11]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_10]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_9]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_8]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_7]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_6]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_5]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_4]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_3]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_2]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_1]
set_property IOSTANDARD  LVCMOS33 [get_ports Test_0]

set_property PACKAGE_PIN P16      [get_ports TestLed_5]
set_property PACKAGE_PIN T19      [get_ports TestLed_4]
set_property PACKAGE_PIN T18      [get_ports TestLed_3]
set_property PACKAGE_PIN U20      [get_ports TestLed_2]
set_property PACKAGE_PIN U19      [get_ports TestLed_1]
set_property PACKAGE_PIN T23      [get_ports TestLed_0]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_5]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_4]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_3]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_2]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_1]
set_property IOSTANDARD  LVCMOS33 [get_ports TestLed_0]

set_property PACKAGE_PIN R16      [get_ports R_Addr0]
set_property PACKAGE_PIN R17      [get_ports R_Addr1]
set_property PACKAGE_PIN N18      [get_ports R_Addr2]
set_property PACKAGE_PIN M19      [get_ports R_Addr3]
set_property PACKAGE_PIN T17      [get_ports R_Addr4]
set_property PACKAGE_PIN R18      [get_ports R_Addr5]
set_property PACKAGE_PIN P18      [get_ports R_Addr6]
set_property PACKAGE_PIN U16      [get_ports R_Addr7]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr0]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr1]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr2]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr3]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr4]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr5]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr6]
set_property IOSTANDARD  LVCMOS33 [get_ports R_Addr7]
set_property PULLUP               [get_ports R_Addr7]
set_property PULLUP               [get_ports R_Addr0]
set_property PULLUP               [get_ports R_Addr1]
set_property PULLUP               [get_ports R_Addr2]
set_property PULLUP               [get_ports R_Addr3]
set_property PULLUP               [get_ports R_Addr4]
set_property PULLUP               [get_ports R_Addr5]
set_property PULLUP               [get_ports R_Addr6]
set_property PULLUP               [get_ports R_Addr7]

# Timing Constraints 
# 250 MHz RefClk
create_clock -name pgpRefClkP -period  4.000 [get_ports {PgpRefClk_P}]
create_clock -name stableClk  -period  8.000 [get_pins {U_LsstSci/U_PGPCore/IBUFDS_GTE2_Inst/ODIV2}]
create_clock -name gtClk      -period  6.400 [get_pins {U_LsstSci/U_PGPCore/BUFG_2/O}]
create_clock -name pgpClk     -period  6.400 [get_pins {U_LsstSci/U_PGPCore/BUFG_3/O}]
create_clock -name beeClk     -period 10.000 [get_pins {U_BeeClk/clkOut[0]}]

set_clock_group -asynchronous -group [get_clocks {stableClk}] \
                              -group [get_clocks {gtClk}] \
                              -group [get_clocks {pgpClk}] \
			      -group [get_clocks beeClk]

# FPGA Hardware Configuration
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]
