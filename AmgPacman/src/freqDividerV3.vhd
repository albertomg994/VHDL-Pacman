-- ========== Copyright Header Begin =============================================
-- AmgPacman File: freqDividerV3.vhd
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
-- Notas adicinales:
----------------------------------------------------------------------------------
-- IMPORTANTE: las salidas clk_1KHz, clk_100Hz y clk_2Hz mandan pulsos, no el reloj
--	completo. Tengo pendiente acabarlo. La frecuencia de entrada al modulo debe ser 50MHz,
--	que es la frecuencia de reloj de la Nexys2.
----------------------------------------------------------------------------------
-- Reporte de sintesis:
----------------------------------------------------------------------------------
-- Minimum period: 5.085ns (Maximum Frequency: 196.638MHz).
-- Codigo del divisor libre de warnings (en principio).
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =================================================================================
--           ENTITY
-- =================================================================================
entity freqDividerV3 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk_1KHz : out  STD_LOGIC;
			  pulso_2Hz: out std_logic
	  );
end freqDividerV3;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of freqDividerV3 is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal pulso_1KHz_aux: std_logic;
	signal pulso_100Hz_aux: std_logic;

-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
	COMPONENT modulo1KHz
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;          
		clk_1KHz : OUT std_logic;
		pulso_1KHz : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT modulo100Hz
	PORT(
		clk_50MHz : IN std_logic;
		ena : IN std_logic;
		rst: in std_logic;
		pulso_100Hz : OUT std_logic
	);
	END COMPONENT;

	COMPONENT modulo2Hz
	PORT(
		clk_50MHz : IN std_logic;
		ena : IN std_logic;
		rst : IN std_logic;          
		pulso_2Hz : OUT std_logic
	);
	END COMPONENT;
	
begin
-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	
-----------------------------------------------------------------------------
-- Conexion de componentes
-----------------------------------------------------------------------------
	Inst_modulo1KHz: modulo1KHz PORT MAP(
		clk_50MHz => clk,
		rst => rst,
		clk_1KHz => clk_1KHz,
		pulso_1KHz => pulso_1KHz_aux
	);
	modulo100Hz_0: modulo100Hz PORT MAP(
		clk_50MHz => clk,
		ena => pulso_1KHz_aux,
		rst => rst,
		pulso_100Hz => pulso_100Hz_aux
	);
	modulo2Hz_0: modulo2Hz PORT MAP(
		clk_50MHz => clk,
		ena => pulso_100Hz_aux,
		rst => rst,
		pulso_2Hz => pulso_2Hz
	);
	
end rtl;

