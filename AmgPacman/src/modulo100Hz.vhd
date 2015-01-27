-- ========== Copyright Header Begin =============================================
-- AmgPacman File: modulo100Hz.vhd
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

-- =================================================================================
--           ENTITY
-- =================================================================================
entity modulo100Hz is
    Port ( clk_50MHz : in  STD_LOGIC;
           ena : in  STD_LOGIC;
			  rst: in std_logic;
           pulso_100Hz : out  STD_LOGIC
	);
end modulo100Hz;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of modulo100Hz is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal pulso_100Hz_aux: std_logic;
-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
	COMPONENT cont10
	PORT(
		clk : IN std_logic;
		ena : IN std_logic;
		rst : IN std_logic;          
		fin : OUT std_logic
		);
	END COMPONENT;

	COMPONENT corr_pulso100Hz
	PORT(
		pulso_in : IN std_logic;
		clk_50MHz : IN std_logic;          
		pulso_out : OUT std_logic
		);
	END COMPONENT;

begin
-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	pulso_100Hz <= pulso_100Hz_aux;
-----------------------------------------------------------------------------
-- Conexion de componentes
-----------------------------------------------------------------------------
	Inst_cont10: cont10 PORT MAP(
		clk => clk_50MHz,
		ena => ena,
		rst => rst,
		fin => pulso_100Hz_aux
	);

end rtl;

