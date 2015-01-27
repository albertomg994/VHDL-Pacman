-- ========== Copyright Header Begin =============================================
-- AmgPacman File: cont50.vhd
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
entity cont50 is
    Port ( clk : in  STD_LOGIC;
           ena : in  STD_LOGIC;
			  rst: in std_logic;
           fin : out  STD_LOGIC
	);
end cont50;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of cont50 is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal reg_cuenta: std_logic_vector(7 downto 0);
	signal reg_cuenta_in: std_logic_vector(7 downto 0);
	signal fin_aux: std_logic;

-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
	COMPONENT incrementadorCuenta8bits
	PORT(
		num_in : IN std_logic_vector(7 downto 0);          
		num_out : OUT std_logic_vector(7 downto 0)
	);
	END COMPONENT;

begin

-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	fin <= fin_aux;

-----------------------------------------------------------------------------
-- Conexion de componentes
-----------------------------------------------------------------------------
	incr_0: incrementadorCuenta8bits PORT MAP(
		num_in => reg_cuenta,
		num_out => reg_cuenta_in
	);
-----------------------------------------------------------------------------
-- Procesos
-----------------------------------------------------------------------------
	p_cuenta: process(clk, ena, rst)
		begin
		if rst = '1' then
			reg_cuenta <= (others => '0');
			fin_aux <= '0';
		elsif rising_edge(clk) then
			if fin_aux = '1' then
				fin_aux <= '0';
				reg_cuenta <= (others => '0');
			elsif reg_cuenta = "00110010" then
				fin_aux <= '1';
				reg_cuenta <= (others => '0');
			elsif ena = '1' then
				reg_cuenta <= reg_cuenta_in;
				fin_aux <= '0';
			end if;
		end if;
	end process p_cuenta;
	
end rtl;

