-- ========== Copyright Header Begin =============================================
-- AmgPacman File: rgb_conv.vhd
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
entity rgb_conv is
    Port ( r : in  STD_LOGIC;
           g : in  STD_LOGIC;
           b : in  STD_LOGIC;
			  pos_h : in std_logic_vector(9 downto 0);
			  pos_v : in std_logic_vector(9 downto 0);
           r_out : out  STD_LOGIC_VECTOR (2 downto 0);
           g_out : out  STD_LOGIC_VECTOR (2 downto 0);
           b_out : out  STD_LOGIC_VECTOR (1 downto 0));
end rgb_conv;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture arq of rgb_conv is

begin
	
	-- Proceso de conversion de rgb de 3 bits a rgb de 8 bits:
	-----------------------------------------------------------
	p_outputs: process(r, g, b, pos_h, pos_v)
		begin
			-- Si estamos fuera del rango del tablero pintaremos negro.
			if pos_h >= "0010000000" and pos_h < "0100000000" and pos_v >= "0010000000" and pos_v < "0100000000" then
				if r = '1' then
					r_out <= "111";
				else
					r_out <= "000";
				end if;
				if g = '1' then
					g_out <= "111";
				else
					g_out <= "000";
				end if;
				if b = '1' then
					b_out <= "11";
				else
					b_out <= "00";
				end if;
			else
				r_out <= (others => '0');
				g_out <= (others => '0');
				b_out <= (others => '0');
			end if;
	end process p_outputs;
end arq;

