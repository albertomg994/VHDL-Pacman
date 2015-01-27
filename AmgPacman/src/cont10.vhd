-- ========== Copyright Header Begin =============================================
-- AmgPacman File: cont10.vhd
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
entity cont10 is
    Port ( clk : in  STD_LOGIC;
           ena : in  STD_LOGIC;
			  rst: in std_logic;
           fin : out  STD_LOGIC);
end cont10;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of cont10 is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal reg_cuenta: std_logic_vector(3 downto 0);
	signal reg_cuenta_in: std_logic_vector(3 downto 0);
	signal fin_aux: std_logic;

-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
--	COMPONENT adder4bits_comb
--	PORT(
--		A : IN std_logic_vector(3 downto 0);
--		B : IN std_logic_vector(3 downto 0);
--		Cin : IN std_logic;          
--		Z : OUT std_logic_vector(3 downto 0);
--		Cout : OUT std_logic
--		);
--	END COMPONENT;

	COMPONENT adder4bits_comb_noCout
	PORT(
		A : IN std_logic_vector(3 downto 0);
		B : IN std_logic_vector(3 downto 0);
		Cin : IN std_logic;          
		Z : OUT std_logic_vector(3 downto 0)
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
--	Inst_adder4bits_comb: adder4bits_comb PORT MAP(
--		A => reg_cuenta,
--		B => "0001",
--		Cin => '0',
--		Z => reg_cuenta_in
--		--Cout => disconnected
--	);
	Inst_adder4bits_comb_noCout: adder4bits_comb_noCout PORT MAP(
		A => reg_cuenta,
		B => "0001",
		Cin => '0',
		Z => reg_cuenta_in
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
				reg_cuenta <= (others => '0');
				fin_aux <= '0';
			elsif ena = '1' then
				if reg_cuenta = "1001" then
					fin_aux <= '1';
					reg_cuenta <= (others => '0');
				else
					reg_cuenta <= reg_cuenta_in;
					fin_aux <= '0';
				end if;
			else
				fin_aux <= '0';
				reg_cuenta <= reg_cuenta;
			end if;
		end if;
	end process p_cuenta;
	
end rtl;

