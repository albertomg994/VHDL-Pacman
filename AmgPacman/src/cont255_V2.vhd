-- ========== Copyright Header Begin =============================================
-- AmgPacman File: cont255_V2.vhd
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
entity cont255_V2 is
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  ena: in STD_LOGIC;
           fin : out  STD_LOGIC
	);
end cont255_V2;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of cont255_V2 is

-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
	COMPONENT incrCuenta8bits_conFin
	PORT(
		num_in : IN std_logic_vector(7 downto 0);          
		num_out : OUT std_logic_vector(7 downto 0);
		fin : OUT std_logic
		);
	END COMPONENT;

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal reg_cuenta: std_logic_vector(7 downto 0);
	signal reg_cuenta_in: std_logic_vector(7 downto 0);
	signal fin_aux: std_logic;
	signal ff_fin: std_logic;
begin

-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	fin <= ff_fin;
	
	incr_0: incrCuenta8bits_conFin PORT MAP(
		num_in => reg_cuenta,
		num_out => reg_cuenta_in,
		fin => fin_aux
	);

-----------------------------------------------------------------------------
-- Procesos
-----------------------------------------------------------------------------

	-- Biestable de cuenta
	p_cuenta: process(rst, clk, ff_fin)
		begin
			if rst = '1' then
				reg_cuenta <= (others => '0');
			elsif rising_edge(clk) then
				if ff_fin = '0' and ena = '1' then	-- Si no ha terminado y esta habilitado
					reg_cuenta <= reg_cuenta_in; -- cuenta++
				elsif ff_fin = '1' then
					reg_cuenta <= (others => '0');
				else
					reg_cuenta <= reg_cuenta;
				end if;
			end if;
	end process p_cuenta;
	
	-- Biestable ff_fin
	p_ff_fin: process(rst, clk, fin_aux)
		begin
			if rst = '1' then
				ff_fin <= '0';
			elsif rising_edge(clk) then
				if fin_aux = '1' then
					ff_fin <= '1';
				else
					ff_fin <= '0';
				end if;
			end if;
	end process p_ff_fin;
end rtl;

