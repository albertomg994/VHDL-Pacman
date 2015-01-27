-- ========== Copyright Header Begin =============================================
-- AmgPacman File: fantasma3.vhd
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

entity pos_circundantes is
    Port ( my_x : in  STD_LOGIC_VECTOR (2 downto 0);
           my_y : in  STD_LOGIC_VECTOR (2 downto 0);
           addr_up : out  STD_LOGIC_VECTOR (5 downto 0);
           addr_dw : out  STD_LOGIC_VECTOR (5 downto 0);
           addr_rg : out  STD_LOGIC_VECTOR (5 downto 0);
           addr_lf : out  STD_LOGIC_VECTOR (5 downto 0));
end pos_circundantes;

architecture arq of pos_circundantes is

	COMPONENT incrCuenta3bits
	PORT(
		num_in : IN std_logic_vector(2 downto 0);          
		num_out : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT decrCuenta3bits
	PORT(
		num_in : IN std_logic_vector(2 downto 0);          
		num_out : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	signal my_y_add1: std_logic_vector(2 downto 0);
	signal my_x_add1: std_logic_vector(2 downto 0);
	signal my_y_sub1: std_logic_vector(2 downto 0);
	signal my_x_sub1: std_logic_vector(2 downto 0);
	
begin

	Inst_incrCuenta3bits_x: incrCuenta3bits PORT MAP(
		num_in => my_x,
		num_out => my_x_add1
	);
	Inst_incrCuenta3bits_y: incrCuenta3bits PORT MAP(
		num_in => my_y,
		num_out => my_y_add1
	);
	Inst_decrCuenta3bits_x: decrCuenta3bits PORT MAP(
		num_in => my_x,
		num_out => my_x_sub1
	);
	Inst_decrCuenta3bits_y: decrCuenta3bits PORT MAP(
		num_in => my_y,
		num_out => my_y_sub1
	);
	
	addr_up <= my_y_add1 & my_x;
	addr_dw <= my_y_sub1 & my_x;
	addr_rg <= my_y & my_x_add1;
	addr_lf <= my_y & my_x_sub1;

end arq;