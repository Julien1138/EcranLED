--------------------------------------------------------------------------------
--     (c) Copyright 1995 - 2010 Xilinx, Inc. All rights reserved.            --
--                                                                            --
--     This file contains confidential and proprietary information            --
--     of Xilinx, Inc. and is protected under U.S. and                        --
--     international copyright and other intellectual property                --
--     laws.                                                                  --
--                                                                            --
--     DISCLAIMER                                                             --
--     This disclaimer is not a license and does not grant any                --
--     rights to the materials distributed herewith. Except as                --
--     otherwise provided in a valid license issued to you by                 --
--     Xilinx, and to the maximum extent permitted by applicable              --
--     law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND                --
--     WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES            --
--     AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING              --
--     BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-                 --
--     INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and               --
--     (2) Xilinx shall not be liable (whether in contract or tort,           --
--     including negligence, or under any other theory of                     --
--     liability) for any loss or damage of any kind or nature                --
--     related to, arising under or in connection with these                  --
--     materials, including for any direct, or any indirect,                  --
--     special, incidental, or consequential loss or damage                   --
--     (including loss of data, profits, goodwill, or any type of             --
--     loss or damage suffered as a result of any action brought              --
--     by a third party) even if such damage or loss was                      --
--     reasonably foreseeable or Xilinx had been advised of the               --
--     possibility of the same.                                               --
--                                                                            --
--     CRITICAL APPLICATIONS                                                  --
--     Xilinx products are not designed or intended to be fail-               --
--     safe, or for use in any application requiring fail-safe                --
--     performance, such as life-support or safety devices or                 --
--     systems, Class III medical devices, nuclear facilities,                --
--     applications related to the deployment of airbags, or any              --
--     other applications that could lead to death, personal                  --
--     injury, or severe property or environmental damage                     --
--     (individually and collectively, "Critical                              --
--     Applications"). Customer assumes the sole risk and                     --
--     liability of any use of Xilinx products in Critical                    --
--     Applications, subject only to applicable laws and                      --
--     regulations governing limitations on product liability.                --
--                                                                            --
--     THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS               --
--     PART OF THIS FILE AT ALL TIMES.                                        --
--------------------------------------------------------------------------------
-- You must compile the wrapper file affichage_traitements_balance_couleurs_mult.vhd when simulating
-- the core, affichage_traitements_balance_couleurs_mult. When compiling the wrapper file, be sure to
-- reference the XilinxCoreLib VHDL simulation library. For detailed
-- instructions, please refer to the "CORE Generator Help".

-- The synthesis directives "translate_off/translate_on" specified
-- below are supported by Xilinx, Mentor Graphics and Synplicity
-- synthesis tools. Ensure they are correct for your synthesis tool(s).

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
-- synthesis translate_off
Library XilinxCoreLib;
-- synthesis translate_on
ENTITY affichage_traitements_balance_couleurs_mult IS
	port (
	a: in std_logic_vector(7 downto 0);
	b: in std_logic_vector(15 downto 0);
	p: out std_logic_vector(23 downto 0));
END affichage_traitements_balance_couleurs_mult;

ARCHITECTURE affichage_traitements_balance_couleurs_mult_a OF affichage_traitements_balance_couleurs_mult IS
-- synthesis translate_off
component wrapped_affichage_traitements_balance_couleurs_mult
	port (
	a: in std_logic_vector(7 downto 0);
	b: in std_logic_vector(15 downto 0);
	p: out std_logic_vector(23 downto 0));
end component;

-- Configuration specification 
	for all : wrapped_affichage_traitements_balance_couleurs_mult use entity XilinxCoreLib.mult_gen_v11_2(behavioral)
		generic map(
			c_a_width => 8,
			c_b_type => 1,
			c_ce_overrides_sclr => 0,
			c_has_sclr => 0,
			c_round_pt => 0,
			c_model_type => 0,
			c_out_high => 23,
			c_verbosity => 0,
			c_mult_type => 1,
			c_ccm_imp => 0,
			c_latency => 0,
			c_has_ce => 0,
			c_has_zero_detect => 0,
			c_round_output => 0,
			c_optimize_goal => 1,
			c_xdevicefamily => "spartan3e",
			c_a_type => 1,
			c_out_low => 0,
			c_b_width => 16,
			c_b_value => "10000001");
-- synthesis translate_on
BEGIN
-- synthesis translate_off
U0 : wrapped_affichage_traitements_balance_couleurs_mult
		port map (
			a => a,
			b => b,
			p => p);
-- synthesis translate_on

END affichage_traitements_balance_couleurs_mult_a;

