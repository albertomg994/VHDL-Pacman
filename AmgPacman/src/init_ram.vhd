-- ========== Copyright Header Begin =============================================
-- AmgPacman File: init_ram.vhd
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

entity init_ram is
    Port ( clk_50MHz : in  STD_LOGIC;
           rst			: in  STD_LOGIC;
           ini 		: in  STD_LOGIC;
			  ram_addr	: out std_logic_vector(5 downto 0);
			  ram_data	: out std_logic_vector(2 downto 0);
			  ram_we		: out std_logic;
           fin			: out STD_LOGIC
			 );
end init_ram;

architecture arq of init_ram is

	type t_st is (s0, s1, s2, s3);
	signal current_state, next_state : t_st; -- Estados actual y siguiente.
	signal rom_out: std_logic_vector(2 downto 0);
	
	-- Contador:
	signal cntr: std_logic_vector(7 downto 0);
	signal cntr_add1: std_logic_vector(7 downto 0);
	signal cntr_ld: std_logic;
	
	COMPONENT tablero_rom
	PORT(
		clk	: IN  std_logic;
		x		: IN  std_logic_vector(2 downto 0);
		y		: IN  std_logic_vector(2 downto 0);          
		rgb	: OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT incrCuenta8bits_conFin
	PORT(
		num_in : IN std_logic_vector(7 downto 0);          
		num_out : OUT std_logic_vector(7 downto 0);
		fin : OUT std_logic
		);
	END COMPONENT;
	
begin

	Inst_tablero_rom: tablero_rom PORT MAP(
		clk => clk_50MHz,
		x => cntr(2 downto 0),
		y => cntr(5 downto 3),
		rgb => rom_out
	);
	
	Inst_incrCuenta8bits_conFin: incrCuenta8bits_conFin PORT MAP(
		num_in => cntr,
		num_out => cntr_add1,
		fin => open
	);
	---------------------------------------------------
	-- Proceso de calculo del estado siguiente y salidas mealy
	---------------------------------------------------
	p_next_state : process (current_state, ini, cntr, cntr_add1) is
	begin
    case current_state is
      when s0 =>
			if ini = '1' then
            next_state <= s1;
			else
				next_state <= s0;
			end if;
      when s1 =>
			if cntr = "01000000" then	-- Si ya hemos escrito todas las posiciones
				next_state <= s3;
			else
				next_state <= s2;
			end if;
      when s2 =>
			next_state <= s1;
		when s3 =>
			next_state <= s3;
    end case;
  end process p_next_state;	
  
   ---------------------------------------------------
	-- Proceso de asignación de valores a las salidas
	---------------------------------------------------
	p_outputs : process (current_state, cntr, rom_out)
		begin
			case current_state is
				when s0 =>
					ram_addr <= (others => '0');
					ram_data <= (others => '0');
					ram_we <= '0';
					fin <= '0';
					cntr_ld <= '0';
				when s1 =>
					ram_addr <= cntr(5 downto 0);
					ram_data <= rom_out;
					ram_we <= '0';
					fin <= '0';
					cntr_ld <= '0';
				when s2 =>
					ram_addr <= cntr(5 downto 0);
					ram_data <= rom_out;
					ram_we <= '1';
					fin <= '0';
					cntr_ld <= '1';
				when s3 =>
					ram_addr <= (others => '0');
					ram_data <= (others => '0');
					ram_we <= '0';
					fin <= '1';
					cntr_ld <= '0';
			end case;
	end process p_outputs;
	---------------------------------------------------
	-- Contador hasta 64
	---------------------------------------------------
	p_cntr: process (rst, clk_50MHz, ini, cntr_ld, cntr)
		begin
			if rst = '1' then
				cntr <= (others => '0');
			elsif rising_edge(clk_50MHz) then
				-- Si load = 1 y cntr != 64
				--if cntr = "00111111" then -- Queremos que en 64 vuelva a 0 (solo llega a 63)
				if cntr = "01000000" then
					cntr <= (others => '0');
				elsif cntr_ld = '1' then --and cntr /= "0111111" then
					cntr <= cntr_add1;
				else
					cntr <= cntr;
				end if;
			end if;
	end process p_cntr;
	---------------------------------------------------
	-- Proceso de actualizacion del estado
	---------------------------------------------------
	p_update_state: process (clk_50MHz, rst) is
		begin
			if rst = '1' then
				current_state <= s0;
			elsif rising_edge(clk_50MHz) then
				current_state <= next_state;
			end if;
	end process p_update_state;
	
end arq;

