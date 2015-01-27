-- ========== Copyright Header Begin =============================================
-- AmgPacman File: modulo1KHz.vhd
-- Copyright (c) 2015 Alberto Miedes Garcés
-- DO NOT ALTER OR REMOVE COPYRIGHT NOTICES.
--
-- The above named program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.
--
-- The above named program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with Foobar.  If not, see <http://www.gnu.org/licenses/>.
-- ========== Copyright Header End ===============================================
----------------------------------------------------------------------------------
-- Engineer: Alberto Miedes Garcés
-- Correo: albertomg994@gmail.com
-- Create Date: January 2015
-- Target Devices: Spartan3E - XC3S500E - Nexys 2 (Digilent)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

-- =================================================================================
--           ENTITY
-- =================================================================================
entity modulo1KHz is
    Port ( clk_50MHz : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk_1KHz : out  STD_LOGIC;
           pulso_1KHz : out  STD_LOGIC);
end modulo1KHz;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of modulo1KHz is
-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal ena_aux: std_logic_vector(1 downto 0);
	signal pulso_aux: std_logic;
	signal force_rst: std_logic;
	signal ff_startV3: std_logic;
-----------------------------------------------------------------------------
-- Declaracion de componentes
-----------------------------------------------------------------------------
	COMPONENT cont255_V2
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		ena: in std_logic;       
		fin : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT cont255_V3
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		ena : IN std_logic;         
		fin : OUT std_logic
		);
	END COMPONENT;

	COMPONENT cont255_V4
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		set_zero: in std_logic;
		start : IN std_logic;          
		fin : OUT std_logic
		);
	END COMPONENT;

begin

-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	pulso_1KHz <= pulso_aux;
	force_rst <= rst or pulso_aux;
	
	clk_1KHz <= pulso_aux;
-----------------------------------------------------------------------------
-- Instancia de componentes
-----------------------------------------------------------------------------
	cont255_0: cont255_V2 port map(
			clk => clk_50MHz,
			rst => force_rst,
			ena => '1',
			fin => ena_aux(0)
	);
	cont255_153: cont255_V3 PORT MAP(
		clk => clk_50MHz,
		rst => force_rst,
		ena => ena_aux(0),
		fin => ena_aux(1)
	);
	cont255_2: cont255_V4 PORT MAP(
		clk => clk_50MHz,
		rst => rst,
		set_zero => force_rst,
		start => ff_startV3,
		fin => pulso_aux
	);
-----------------------------------------------------------------------------
-- Procesos
-----------------------------------------------------------------------------
	p_ff_startV3: process(clk_50MHz, force_rst)
		begin
			if force_rst = '1' then
				ff_startV3 <= '0';
			elsif rising_edge(clk_50MHz) then
				if ena_aux(1) = '1' then
					ff_startV3 <= '1';
				else
					ff_startV3 <= ff_startV3;
				end if;
			end if;
	end process p_ff_startV3;
end rtl;

