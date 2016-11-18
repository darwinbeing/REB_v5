-------------------------------------------------------------------------------
-- Title      : 
-------------------------------------------------------------------------------
-- File       : VcUsBuff64Tb.vhd
-- Author     : Larry Ruckman  <ruckman@slac.stanford.edu>
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2014-02-21
-- Last update: 2014-02-26
-- Platform   : Vivado 2013.3
-- Standard   : VHDL'93/02
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2014 SLAC National Accelerator Laboratory
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

use work.StdRtlPkg.all;
use work.VcPkg.all;

entity VcUsBuff64Tb is end VcUsBuff64Tb;

architecture testbed of VcUsBuff64Tb is
   constant TPD_C : time := 4 ns;

   type   StateType is (RST_S, SEND_DATA_S, WAIT_S, DONE_S);
   signal state : StateType := RST_S;

   -- Frame Transmit Interface 
   signal pgpVcTxIn  : VcTxInType  := VC_TX_IN_INIT_C;
   signal pgpVcTxOut : VcTxOutType := VC_TX_OUT_INIT_C;

   -- Frame Receive Interface
   signal pgpVcRxCommonOut : VcRxCommonOutType := VC_RX_COMMON_OUT_INIT_C;
   signal pgpVcRxOut       : VcRxOutType       := VC_RX_OUT_INIT_C;

   --Upstream VC bus
   signal UsBuff64VcIn  : VcUsBuff64InType  := VC_US_BUFF64_IN_INIT_C;
   signal UsBuff64VcOut : VcUsBuff64OutType := VC_US_BUFF64_OUT_INIT_C;

   signal clk,
      rst : sl := '0';
   signal cnt : slv(31 downto 0) := (others => '0');
begin
--*********************************************************************************--
   ClkRst_Inst : entity work.ClkRst
      generic map (
         CLK_PERIOD_G      => 10 ns,
         RST_START_DELAY_G => 1 ns,     -- Wait this long into simulation before asserting reset
         RST_HOLD_TIME_G   => 0.6 us)   -- Hold reset for this long)
      port map (
         clkP => clk,
         clkN => open,
         rst  => rst,
         rstL => open);
--*********************************************************************************--   
   VcUsBuff64_Inst : entity work.VcUsBuff64
      generic map (
         TPD_G             => TPD_C,
         TX_LANES_G        => 1,
         FIFO_ADDR_WIDTH_G => 9,
         FIFO_FULL_THRES_G => 256)      
      port map (
         -- TX VC Signals (vcTxClk domain)
         vcTxIn      => pgpVcTxIn,
         vcTxOut     => pgpVcTxOut,
         vcRxOut     => pgpVcRxOut,
         -- UP signals  (locClk domain)
         usBuff64In  => UsBuff64VcIn,
         usBuff64Out => UsBuff64VcOut,
         -- Local clock and resets
         locClk      => clk,
         locRst      => rst,
         -- VC Rx Clock And Resets
         vcTxClk     => clk,
         vcTxRst     => rst);  
--*********************************************************************************--   
   process(clk)
   begin
      if rising_edge(clk) then
         UsBuff64VcIn.valid <= '0' after TPD_C;
         UsBuff64VcIn.sof   <= '0' after TPD_C;
         UsBuff64VcIn.eof   <= '0' after TPD_C;
         UsBuff64VcIn.eofe  <= '0' after TPD_C;
         if rst = '1' then
            UsBuff64VcIn <= VC_US_BUFF64_IN_INIT_C after TPD_C;
            pgpVcTxOut   <= VC_TX_OUT_INIT_C       after TPD_C;
            cnt          <= (others => '0')        after TPD_C;
            state        <= RST_S                  after TPD_C;
         else
            case (state) is
               ----------------------------------------------------------------------
               when RST_S =>
                  --increment the counter
                  cnt <= cnt + 1 after TPD_C;
                  if cnt = 100 then
                     --reset the counter
                     cnt   <= (others => '0') after TPD_C;
                     --next state
                     state <= SEND_DATA_S     after TPD_C;
                  end if;
                  ----------------------------------------------------------------------
               when SEND_DATA_S =>
                  --increment the counter
                  cnt <= cnt + 1 after TPD_C;
                  if cnt = 0 then
                     UsBuff64VcIn.valid <= '1'                 after TPD_C;
                     UsBuff64VcIn.sof   <= '1'                 after TPD_C;
                     UsBuff64VcIn.data  <= x"0123456789ABCDEF" after TPD_C;
                  elsif cnt = 1 then
                     UsBuff64VcIn.valid <= '1'                 after TPD_C;
                     UsBuff64VcIn.data  <= x"BABECAFEBABECAFE" after TPD_C;
                  elsif cnt = 2 then
                     UsBuff64VcIn.valid <= '1'                 after TPD_C;
                     UsBuff64VcIn.data  <= x"FFFFFFFF00000000" after TPD_C;
                  else
                     UsBuff64VcIn.valid <= '1'                 after TPD_C;
                     UsBuff64VcIn.eof   <= '1'                 after TPD_C;
                     UsBuff64VcIn.data  <= x"AAAAAAAA55555555" after TPD_C;
                     --reset the counter
                     cnt                <= (others => '0')     after TPD_C;
                     --next state
                     state              <= WAIT_S              after TPD_C;
                  end if;
                  ----------------------------------------------------------------------
               when WAIT_S =>
                  --increment the counter
                  cnt <= cnt + 1 after TPD_C;
                  if cnt = 100 then
                     --reset the counter
                     cnt              <= (others => '0') after TPD_C;
                     --set the ready bit
                     pgpVcTxOut.ready <= '1'             after TPD_C;
                     --next state
                     state            <= DONE_S          after TPD_C;
                  end if;
                  ----------------------------------------------------------------------
               when DONE_S =>
                  --next state
                  state <= DONE_S after TPD_C;
                  ----------------------------------------------------------------------
            end case;
         end if;
      end if;
   end process;
   
end testbed;