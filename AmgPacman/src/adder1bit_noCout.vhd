-- ========== Copyright Header Begin =============================================
-- AmgPacman File: adder1bit_noCout.vhd
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
entity adder1bit_noCout is
    port ( A : in  std_logic;
           B : in  std_logic;
           Cin : in  std_logic;
           Z : out  std_logic
	 );
end adder1bit_noCout;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of adder1bit_noCout is

begin
	Z <= (A xor B) xor Cin;

end rtl;

