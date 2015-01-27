-- ========== Copyright Header Begin =============================================
-- AmgPacman File: incrCuenta8bits_conFin.vhd
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
entity incrCuenta8bits_conFin is
    Port ( num_in : in  STD_LOGIC_VECTOR (7 downto 0);
           num_out : out  STD_LOGIC_VECTOR (7 downto 0);
			  fin: out std_logic
	 );
end incrCuenta8bits_conFin;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of incrCuenta8bits_conFin is
-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal aux: std_logic_vector(6 downto 0);
-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
	COMPONENT adder1bit_comb
	PORT(
		A : IN std_logic;
		B : IN std_logic;
		Cin : IN std_logic;          
		Z : OUT std_logic;
		Cout : OUT std_logic
		);
	END COMPONENT;

begin
-----------------------------------------------------------------------------
-- Conexion de componentes
-----------------------------------------------------------------------------
	adder_0: adder1bit_comb port map(
		A => num_in(0),
		B => '1',
		Cin => '0',
		Z => num_out(0),
		Cout => aux(0)
	);
	adder_1: adder1bit_comb port map(
		A => num_in(1),
		B => aux(0),
		Cin => '0',
		Z => num_out(1),
		Cout => aux(1)
	);
	adder_2: adder1bit_comb port map(
		A => num_in(2),
		B => aux(1),
		Cin => '0',
		Z => num_out(2),
		Cout => aux(2)
	);
	adder_3: adder1bit_comb port map(
		A => num_in(3),
		B => aux(2),
		Cin => '0',
		Z => num_out(3),
		Cout => aux(3)
	);
	adder_4: adder1bit_comb port map(
		A => num_in(4),
		B => aux(3),
		Cin => '0',
		Z => num_out(4),
		Cout => aux(4)
	);
	adder_5: adder1bit_comb port map(
		A => num_in(5),
		B => aux(4),
		Cin => '0',
		Z => num_out(5),
		Cout => aux(5)
	);
	adder_6: adder1bit_comb port map(
		A => num_in(6),
		B => aux(5),
		Cin => '0',
		Z => num_out(6),
		Cout => aux(6)
	);
	adder_7: adder1bit_comb PORT MAP(
		A => num_in(7),
		B => aux(6),
		Cin => '0',
		Z => num_out(7),
		Cout => fin
	);

end rtl;

