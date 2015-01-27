-- ========== Copyright Header Begin =============================================
-- AmgPacman File: sincronismo.vhd
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
entity sincronismo is
	port(
		clk_50MHz: in std_logic;
		rst: in std_logic;
		hsync: out std_logic;
		vsync: out std_logic;
		pos_h: out std_logic_vector(9 downto 0);
		pos_v: out std_logic_vector(9 downto 0)
	);
end sincronismo;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture arq of sincronismo is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	
	-- Contadores
	signal v_cntr		: std_logic_vector(9 downto 0);
	signal v_cntr_add1: std_logic_vector(9 downto 0);
	
	signal h_cntr		: std_logic_vector(9 downto 0);
	signal h_cntr_add1: std_logic_vector(9 downto 0);

	-- Senales de sincronismo:
	signal ff_hsync: std_logic;
	signal ff_vsync: std_logic;
	
	signal hsync_in: std_logic;
	signal vsync_in: std_logic;
	
	-- Pulso 25MHz:
	signal p25MHz: std_logic;

-----------------------------------------------------------------------------
-- Declaracion de componentes
-----------------------------------------------------------------------------
	COMPONENT dsor_vga
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;          
		pulso_25MHz : OUT std_logic
		);
	END COMPONENT;

	COMPONENT incrementadorCuenta10bits
	PORT(
		num_in : IN std_logic_vector(9 downto 0);          
		num_out : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;
	
begin
-----------------------------------------------------------------------------
-- Conexion de componentes
-----------------------------------------------------------------------------
	dsor_vga_0: dsor_vga PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		pulso_25MHz => p25MHz
	);
	incr_cont_h: incrementadorCuenta10bits PORT MAP(
		num_in => h_cntr,
		num_out => h_cntr_add1
	);
	incr_cont_v: incrementadorCuenta10bits PORT MAP(
		num_in => v_cntr,
		num_out => v_cntr_add1
	);
-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	-- Senales de sincronismo:
	hsync_in <= '1'  when h_cntr >= "1010010000" and h_cntr <= "1011101111" else -- Entre 656 y 751
					'0';
	vsync_in <= '1'  when v_cntr >= "0111101010" and v_cntr <= "0111101011" else -- Enre 490 y 491
					'0';
	
	-- Conexion a la salida:
	hsync <= ff_hsync;
	vsync <= ff_vsync;
	
	pos_h <= h_cntr;
	pos_v <= v_cntr;
	
-----------------------------------------------------------------------------
-- Procesos
-----------------------------------------------------------------------------

	-- Registros de las senales de sincronismo:
	-------------------------------------------------------------
	p_ff_sync: process(clk_50MHz, rst)
		begin
			if rst = '1' then
				ff_hsync <= '0';
				ff_vsync <= '0';
			elsif rising_edge(clk_50MHz) then
				ff_hsync <= hsync_in;
				ff_vsync <= vsync_in;
			end if;
	end process p_ff_sync;
		
	-- Contador hasta 800
	-------------------------------------------------------------
	p_h_cntr: process (h_cntr, p25MHz, clk_50MHz, rst)
	begin
		if rst = '1' then
			h_cntr <= (others => '0');
		elsif rising_edge(clk_50MHz) then
			if p25MHz = '1' then
				if h_cntr = "1100011111" then -- Si ha llegado a 799
					h_cntr <= (others => '0');
				else
					h_cntr <= h_cntr_add1;
				end if;
			end if;
		end if;
	end process p_h_cntr;
	
	-- Contador hasta 525
	-------------------------------------------------------------
	p_v_cntr: process (v_cntr, h_cntr, p25MHz, clk_50MHz, rst)
	begin
		if rst = '1' then
			v_cntr <= (others => '0');
		elsif rising_edge(clk_50MHz) then
			if p25MHz = '1' and h_cntr = "1100011111" then -- h_cntr = 799
				if v_cntr = "1000001100" then -- Si ha llegado a 524
					v_cntr <= (others => '0');
				else
					v_cntr <= v_cntr_add1;
				end if;
			end if;
		end if;
	end process p_v_cntr;

end arq;

