-- ========== Copyright Header Begin =============================================
-- AmgPacman File: debouncer.vhd
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
-- Engineer: Alberto Miedes Garces
-- Correo: albertomg994@gmail.com
-- Create Date: January 2015
-- Target Devices: Spartan3E - XC3S500E - Nexys 2 (Digilent)
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- =================================================================================
--           ENTITY
-- =================================================================================
entity debouncer is
    port ( 
         clk : in  STD_LOGIC;
			rst : in std_logic;
			x : in  STD_LOGIC;
			pulso2Hz: in std_logic;
         xDeb : out  STD_LOGIC
	);
end debouncer;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture arq of debouncer is

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	type t_st is (s0, s1, s2, s3);
	signal current_state, next_state: t_st;

begin

-----------------------------------------------------------------------------
-- Calculo el estado siguiente
-----------------------------------------------------------------------------
	p_next_state: process(current_state, pulso2Hz, x)
	begin
		case current_state is
			when s0 =>
				if x = '1' then
					next_state <= s1;
				else
					next_state <= s0;
				end if;
			when s1 =>
					next_state <= s2;
			when s2 =>
				if pulso2Hz = '1' then
					next_state <= s3;
				else
					next_state <= s2;
				end if;
			when s3 =>
				if pulso2Hz = '1' then
					next_state <= s0;
				else
					next_state <= s3;
				end if;
			when others =>
				next_state <= s0;
		end case;
	end process p_next_state;
-----------------------------------------------------------------------------
-- Salidas de la FSM (Moore)
-----------------------------------------------------------------------------
	p_salidasMoore: process(current_state)
	begin
		case current_state is
			when s1 =>
				xDeb <= '1';
			when others =>
				xDeb <= '0';
		end case;
	end process p_salidasMoore;
-----------------------------------------------------------------------------
-- Proceso de actualizacion del estado:
-----------------------------------------------------------------------------
	p_update_state: process(clk, rst)
	begin
		if rst = '1' then
			current_state <= s0;
		elsif rising_edge(clk) then
			current_state <= next_state;
		end if;
	end process p_update_state;
	
end arq;