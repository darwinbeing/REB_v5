------------------------------------------------------------------------------
--   ____  ____ 
--  /   /\/   /
-- /___/  \  /    Vendor: Xilinx
-- \   \   \/     Version : 3.4
--  \   \         Application : 7 Series FPGAs Transceivers Wizard
--  /   /         Filename : gtwizard_0_gtrxreset_seq.vhd
-- /___/   /\     
-- \   \  /  \ 
--  \___\/\___\
--
--
-- Module gtwizard_0_gtrxreset_seq
-- Generated by Xilinx 7 Series FPGAs Transceivers Wizard
-- 
-- 
-- (c) Copyright 2010-2012 Xilinx, Inc. All rights reserved.
-- 
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
-- 
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
-- 
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
-- 
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES. 


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Gth7RxRstSeq is
   generic(
      TPD_G : time := 1 ns);  
   port (
      RST_IN         : in  std_logic; 
      GTRXRESET_IN   : in  std_logic;    
      RXPMARESETDONE : in  std_logic;
      GTRXRESET_OUT  : out std_logic;

      DRPCLK      : in  std_logic;
      DRPADDR     : out std_logic_vector(8 downto 0);
      DRPDO       : in  std_logic_vector(15 downto 0);
      DRPDI       : out std_logic_vector(15 downto 0);
      DRPRDY      : in  std_logic;
      DRPEN       : out std_logic;
      DRPWE       : out std_logic;
      DRP_OP_DONE : out std_logic
      );
end Gth7RxRstSeq;

architecture Behavioral of Gth7RxRstSeq is

   type state_type is (
      idle,
      drp_rd,
      wait_rd_data,
      wr_16,
      wait_wr_done1,
      wait_pmareset,
      wr_20,
      wait_wr_done2);

   signal state                : state_type := idle;
   signal next_state           : state_type := idle;
   signal gtrxreset_s          : std_logic;
   signal gtrxreset_ss         : std_logic;
   signal rxpmaresetdone_ss    : std_logic;
   signal rxpmaresetdone_sss   : std_logic;
   signal rd_data              : std_logic_vector(15 downto 0);
   signal next_rd_data         : std_logic_vector(15 downto 0);
   signal original_rd_data     : std_logic_vector(15 downto 0);
   signal pmarstdone_fall_edge : std_logic;
   signal gtrxreset_i          : std_logic;
   signal flag                 : std_logic  := '0';
   signal gtrxreset_o          : std_logic;
   signal drpen_o              : std_logic;
   signal drpwe_o              : std_logic;
   signal drpaddr_o            : std_logic_vector(8 downto 0);
   signal drpdi_o              : std_logic_vector(15 downto 0);
   signal drp_op_done_o        : std_logic;
   signal RST                  : std_logic;
   signal GTRXRESET            : std_logic;

begin

   sync_RXPMARESETDONE : entity work.Synchronizer
      generic map (
         TPD_G => TPD_G)
      port map (
         clk     => DRPCLK,
         dataIn  => RXPMARESETDONE,
         dataOut => rxpmaresetdone_ss);

   sync_RST : entity work.RstSync
      generic map (
         TPD_G => TPD_G)
      port map (
         clk      => DRPCLK,
         asyncRst => RST_IN,
         syncRst  => RST);         

   sync_GTRXRESET : entity work.RstSync
      generic map (
         TPD_G => TPD_G)
      port map (
         clk      => DRPCLK,
         asyncRst => GTRXRESET_IN,
         syncRst  => GTRXRESET);         

   -- Output assignment     
   GTRXRESET_OUT <= gtrxreset_o;
   DRPEN         <= drpen_o;
   DRPWE         <= drpwe_o;
   DRPADDR       <= drpaddr_o;
   DRPDI         <= drpdi_o;
   DRP_OP_DONE   <= drp_op_done_o;

   process (DRPCLK)
   begin
      if rising_edge(DRPCLK) then
         if (RST = '1') then
            state              <= idle    after TPD_G;
            gtrxreset_s        <= '0'     after TPD_G;
            gtrxreset_ss       <= '0'     after TPD_G;
            rxpmaresetdone_sss <= '0'     after TPD_G;
            rd_data            <= x"0000" after TPD_G;
            gtrxreset_o        <= '0'     after TPD_G;
         else
            state              <= next_state        after TPD_G;
            gtrxreset_s        <= GTRXRESET         after TPD_G;
            gtrxreset_ss       <= gtrxreset_s       after TPD_G;
            rxpmaresetdone_sss <= rxpmaresetdone_ss after TPD_G;
            rd_data            <= next_rd_data      after TPD_G;
            gtrxreset_o        <= gtrxreset_i       after TPD_G;
         end if;
      end if;
   end process;

   process (DRPCLK)
   begin
      if rising_edge(DRPCLK) then
         if (GTRXRESET = '1') then
            drp_op_done_o <= '0' after TPD_G;
         else
            if (state = wait_wr_done2 and DRPRDY = '1') then
               drp_op_done_o <= '1' after TPD_G;
            else
               drp_op_done_o <= drp_op_done_o after TPD_G;
            end if;
         end if;
      end if;
   end process;

   pmarstdone_fall_edge <= (not rxpmaresetdone_ss) and (rxpmaresetdone_sss);

   process (DRPRDY, gtrxreset_ss, pmarstdone_fall_edge, state)
   begin
      case state is

         when idle =>
            if (gtrxreset_ss = '1') then
               next_state <= drp_rd;
            else
               next_state <= idle;
            end if;

         when drp_rd =>
            next_state <= wait_rd_data;

         when wait_rd_data =>
            if (DRPRDY = '1')then
               next_state <= wr_16;
            else
               next_state <= wait_rd_data;
            end if;

         when wr_16 =>
            next_state <= wait_wr_done1;

         when wait_wr_done1 =>
            if (DRPRDY = '1') then
               next_state <= wait_pmareset;
            else
               next_state <= wait_wr_done1;
            end if;

         when wait_pmareset =>
            if (pmarstdone_fall_edge = '1') then
               next_state <= wr_20;
            else
               next_state <= wait_pmareset;
            end if;

         when wr_20 =>
            next_state <= wait_wr_done2;

         when wait_wr_done2 =>
            if (DRPRDY = '1') then
               next_state <= idle;
            else
               next_state <= wait_wr_done2;
            end if;

         when others=>
            next_state <= idle;
            
      end case;
   end process;

-- drives DRP interface and GTRXRESET_OUT
   process(DRPDO, DRPRDY, flag, gtrxreset_ss, original_rd_data, rd_data, state)
   begin
-- assert gtrxreset_out until wr to 16-bit is complete
-- RX_DATA_WIDTH is located at addr x"0011", [13 downto 11]
-- encoding is this : /16 = x "2", /20 = x"3", /32 = x"4", /40 = x"5"
      gtrxreset_i  <= '0';
      drpaddr_o    <= '0'& x"11";       -- 000010001
      drpen_o      <= '0';
      drpwe_o      <= '0';
      drpdi_o      <= x"0000";
      next_rd_data <= rd_data;

      case state is

         --do nothing to DRP or reset
         when idle =>
            null;

         --assert reset and issue rd
         when drp_rd =>
            gtrxreset_i <= '1';
            drpen_o     <= '1';
            drpwe_o     <= '0';

         --assert reset and wait to load rd data
         when wait_rd_data =>
            gtrxreset_i <= '1';
            if (DRPRDY = '1' and flag = '0') then
               next_rd_data <= DRPDO;
            elsif (DRPRDY = '1' and flag = '1') then
               next_rd_data <= original_rd_data;
            else
               next_rd_data <= rd_data;
            end if;

         --assert reset and write to 16-bit mode
         when wr_16=>
            gtrxreset_i <= '1';
            drpen_o     <= '1';
            drpwe_o     <= '1';
            -- Addr "00001001" [11] = '0' puts width mode in /16 or /32
            drpdi_o     <= rd_data(15 downto 12) & '0' & rd_data(10 downto 0);

         --keep asserting reset until write to 16-bit mode is complete
         when wait_wr_done1 =>
            gtrxreset_i <= '1';

         --deassert reset and no DRP access until 2nd pmareset
         when wait_pmareset =>
            if (gtrxreset_ss = '1') then
               gtrxreset_i <= '1';
            else
               gtrxreset_i <= '0';
            end if;

         --write to 20-bit mode
         when wr_20 =>
            drpen_o <= '1';
            drpwe_o <= '1';
            drpdi_o <= rd_data(15 downto 0);  --restore user setting per prev read

         --wait to complete write to 20-bit mode
         when wait_wr_done2 =>
            null;

         when others =>
            null;

      end case;
   end process;

   process (DRPCLK)
   begin
      if rising_edge(DRPCLK) then
         if(state = wr_16 or state = wait_pmareset or state = wr_20 or state = wait_wr_done1) then
            flag <= '1' after TPD_G;
         elsif(state = wait_wr_done2) then
            flag <= '0' after TPD_G;
         end if;
         if(state = wait_rd_data and DRPRDY = '1' and flag = '0') then
            original_rd_data <= DRPDO after TPD_G;
         end if;
      end if;
   end process;

end Behavioral;
