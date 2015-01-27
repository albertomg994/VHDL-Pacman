-- ========== Copyright Header Begin =============================================
-- AmgPacman File: nueva_pos_rand_async.vhd
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

entity nueva_pos_rand_async is
    Port ( up_pos : in  STD_LOGIC_VECTOR (2 downto 0);
           dw_pos : in  STD_LOGIC_VECTOR (2 downto 0);
           rg_pos : in  STD_LOGIC_VECTOR (2 downto 0);
           lf_pos : in  STD_LOGIC_VECTOR (2 downto 0);
           my_x : in  STD_LOGIC_VECTOR (2 downto 0);
           my_y : in  STD_LOGIC_VECTOR (2 downto 0);
           new_x : out  STD_LOGIC_VECTOR (2 downto 0);
           new_y : out  STD_LOGIC_VECTOR (2 downto 0);
			  bt_rand: in std_logic_vector(1 downto 0)
			 );
end nueva_pos_rand_async;

architecture arq of nueva_pos_rand_async is

	signal rand_num: std_logic_vector(1 downto 0);
	signal new_pos_in: std_logic_vector(5 downto 0);
	signal pos_valida: std_logic;
	
	signal my_y_add1: std_logic_vector(2 downto 0);
	signal my_x_add1: std_logic_vector(2 downto 0);
	signal my_y_sub1: std_logic_vector(2 downto 0);
	signal my_x_sub1: std_logic_vector(2 downto 0);
	
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
	
	-- Conexión de señales
	---------------------------------------------------------
	rand_num <= bt_rand;	
	new_x <= new_pos_in(2 downto 0);
	new_y <= new_pos_in(5 downto 3);
	
	-- Equivalencias entre los números aleatorios y la dirección de desplazamiento:
	-- 00 -> Mueve hacia arriba
	-- 01 -> Mueve hacia abajo
	-- 10 -> Mueve hacia la derecha
	-- 11 -> Mueve hacia la izquierda
	
	-- ¿Es válida la dirección de desplazamiento aleatoria generada?
	--------------------------------------------------------
	p_pos_valida: process(rand_num, up_pos, dw_pos, rg_pos, lf_pos)
		begin
			-- Si me muevo hacia arriba y no hay pared:
			if rand_num = "00" and up_pos = "000" then
				pos_valida <= '1';
			-- Si me muevo hacia abajo y no hay pared:
			elsif rand_num = "01" and dw_pos = "000" then
				pos_valida <= '1';
			-- Si me muevo hacia la derecha y no hay pared:
			elsif rand_num = "10" and rg_pos = "000" then
				pos_valida <= '1';
			-- Si me muevo hacia la izquierda y no hay pared:
			elsif rand_num = "11" and lf_pos = "000" then
				pos_valida <= '1';
			-- En cualquier otro caso la dirección de desplazamiento no es válida:
			else 
				pos_valida <= '0';
			end if;
	end process p_pos_valida;
	
	-- Traducimos el número aleatorio en la posicion equivalente dentro del mapa:
	---------------------------------------------------------
	p_traduce: process(rand_num, my_x, my_y, pos_valida, my_y_add1, my_y_sub1, my_x_add1, my_x_sub1)
		begin
			if pos_valida = '1' then
				if rand_num = "00" then --arriba
					new_pos_in <= my_y_add1 & my_x;
				elsif rand_num = "01" then --abajo
					new_pos_in <= my_y_sub1 & my_x;
				elsif rand_num = "10" then --der
					new_pos_in <= my_y & my_x_add1;
				else --izq
					new_pos_in <= my_y & my_x_sub1;
				end if;
			else
				new_pos_in <= my_y & my_x; -- Si no es valida nos mantenemos donde estamos.
			end if;
	end process p_traduce;
end arq;



