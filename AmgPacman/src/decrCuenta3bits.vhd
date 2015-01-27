-- ========== Copyright Header Begin =============================================
-- AmgPacman File: decrCuenta3bits.vhd
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

entity decrCuenta3bits is
    Port ( num_in : in  STD_LOGIC_VECTOR (2 downto 0);
           num_out : out  STD_LOGIC_VECTOR (2 downto 0));
end decrCuenta3bits;

architecture arq of decrCuenta3bits is

begin
	p_outputs: process(num_in)
		begin
			if num_in = "111" then
				num_out <= "110";
			elsif num_in = "110" then
				num_out <= "101";
			elsif num_in = "101" then
				num_out <= "100";
			elsif num_in = "100" then
				num_out <= "011";
			elsif num_in = "011" then
				num_out <= "010";
			elsif num_in = "010" then
				num_out <= "001";
			elsif num_in = "001" then
				num_out <= "000";
			else
				num_out <= "111";
			end if;
	end process p_outputs;
end arq;

