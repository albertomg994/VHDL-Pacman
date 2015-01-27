-- ========== Copyright Header Begin =============================================
-- AmgPacman File: adder4bits_comb_noCout.vhd
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
entity adder4bits_comb_noCout is
    port ( A : in  std_logic_vector (3 downto 0);
           B : in  std_logic_vector (3 downto 0);
           Cin : in  std_logic;
           Z : out  std_logic_vector (3 downto 0)
	 );
end adder4bits_comb_noCout;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of adder4bits_comb_noCout is

	signal c_aux: std_logic_vector(3 downto 0);
-----------------------------------------------------------------------------
-- Componentes auxiliares
-----------------------------------------------------------------------------
	component adder1bit_comb
	port(
		A : in std_logic;
		B : in std_logic;
		Cin : in std_logic;          
		Z : out std_logic;
		Cout : out std_logic
		);
	end component;
	
	COMPONENT adder1bit_noCout
	PORT(
		A : IN std_logic;
		B : IN std_logic;
		Cin : IN std_logic;          
		Z : OUT std_logic
		);
	END COMPONENT;

begin

-----------------------------------------------------------------------------
-- Instacia de componentes
-----------------------------------------------------------------------------
	adder_0: adder1bit_comb port map(
		A => A(0),
		B => B(0),
		Cin => c_aux(0),
		Z => Z(0),
		Cout => c_aux(1)
	);
	adder_1: adder1bit_comb port map(
		A => A(1),
		B => B(1),
		Cin => c_aux(1),
		Z => Z(1),
		Cout => c_aux(2)
	);
	adder_2: adder1bit_comb port map(
		A => A(2),
		B => B(2),
		Cin => c_aux(2),
		Z => Z(2),
		Cout => c_aux(3)
	);
	adder_3: adder1bit_noCout PORT MAP(
		A => A(3),
		B => B(3),
		Cin => c_aux(3),
		Z => Z(3)
	);
-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	c_aux(0) <= Cin;

end rtl;

