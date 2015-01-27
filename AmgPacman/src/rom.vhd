-- ========== Copyright Header Begin =============================================
-- AmgPacman File: rom.vhd
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
library ieee;
use ieee.std_logic_1164.all; 
use ieee.numeric_std.all; 
 
 entity tablero_rom is
    port (                  
			 clk: in  std_logic;
			 x  : in  std_logic_vector(2 downto 0);
			 y  : in  std_logic_vector(2 downto 0);
			 rgb: out std_logic_vector(2 downto 0)
	 ); 
end tablero_rom;
 
architecture arq of tablero_rom is  
 
	type memory_slv is array (0 to 7) of std_logic_vector(2 downto 0); 
	type memory_img is array (0 to 7) of memory_slv;	 
	
constant rom_img : memory_img := (
("001","001","001","001","001","001","001","001"),
("001","000","000","000","000","000","000","001"),
("001","000","001","000","000","001","000","001"),
("001","000","000","000","000","000","000","001"),
("001","000","000","000","001","000","000","001"),
("001","000","001","000","000","001","000","001"),
("001","000","000","000","000","000","000","001"),
("001","001","001","001","001","001","001","001")
);
	
begin   

	process(clk,x,y )
		begin	
			 if clk'event and clk='1' then
				rgb(2 downto 0) <=  rom_img(to_integer(unsigned(y)))(to_integer(unsigned(x)))(2 downto 0); 
			end if;
	end process; 

end arq;
