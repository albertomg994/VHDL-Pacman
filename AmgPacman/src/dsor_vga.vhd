-- ========== Copyright Header Begin =============================================
-- AmgPacman File: dsor_vga.vhd
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
entity dsor_vga is
    Port ( clk_50MHz : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           pulso_25MHz : out  STD_LOGIC);
end dsor_vga;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture arq of dsor_vga is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal ff_aux: std_logic;
	--signal ff_pulso: std_logic;
	
begin

-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	--pulso_25MHz <= '1' when clk_50MHz = '1' and ff_aux = '1' else
						--'0';
	pulso_25MHz <= ff_aux;
-----------------------------------------------------------------------------
-- Procesos
-----------------------------------------------------------------------------					
	p_aux: process(rst, clk_50MHz)
		begin
			if rst = '1' then
				ff_aux <= '0';
			elsif rising_edge(clk_50MHz) then
				ff_aux <= not ff_aux;
			end if;
	end process p_aux;

	
end arq;

