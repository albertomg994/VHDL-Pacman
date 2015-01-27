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

entity fantasma3 is
    Port ( -- Señales generales:
			  clk_50MHz	: in     std_logic; -- Reloj
           rst			: in     std_logic; -- Reset
           p2Hz		: in     std_logic; -- Pulso para retrasar el movimiento
			  ini			: in     std_logic; -- Fantasma tiene permiso para actualizarse.
			  fin			: out 	std_logic; -- Fantasma ha terminado de actualizarse.
			  -- Lecutra de la RAM:
			  ram_addr_rd : out std_logic_vector(5 downto 0);
			  ram_data_rd : in  std_logic_vector(2 downto 0);
			  -- Escritura en la RAM:
			  ram_addr_wr : out std_logic_vector(5 downto 0);
			  ram_data_wr : out std_logic_vector(2 downto 0);
			  ram_we      : out std_logic;
			  -- Otros:
			  bt_rand	  : in std_logic_vector(1 downto 0)
			 );
end fantasma3;

architecture arq of fantasma3 is

	-- Estados de la FSM:
	type t_st is (espera, up_1, up_2, dw_1, dw_2, rg_1, rg_2, lf_1, lf_2, new_pos, wr_pos1, wr_pos2);
	signal current_state, next_state : t_st; -- Estados actual y siguiente.
	
	-- Registros con los colores de las posiciones circundantes:
	signal ff_up_pos: std_logic_vector(2 downto 0);
	signal ff_dw_pos: std_logic_vector(2 downto 0);
	signal ff_rg_pos: std_logic_vector(2 downto 0);
	signal ff_lf_pos: std_logic_vector(2 downto 0);
	
	-- Senales con las direcciones para acceder a las posiciones circundantes:
	signal up_addr: std_logic_vector(5 downto 0);
	signal dw_addr: std_logic_vector(5 downto 0);
	signal rg_addr: std_logic_vector(5 downto 0);
	signal lf_addr: std_logic_vector(5 downto 0);
	
	-- Registros con la posicion del fantasma:
	signal my_pos_x: std_logic_vector(2 downto 0);
	signal my_pos_y: std_logic_vector(2 downto 0);
	signal my_pos_x_in: std_logic_vector(2 downto 0);
	signal my_pos_y_in: std_logic_vector(2 downto 0);
	
	-- Señales de carga de registros:
	--all_ld <= my_ld & ff_up_ld & ff_dw_ld & ff_rg_ld & ff_lf_ld;
	signal all_ld: std_logic_vector(4 downto 0); -- Todas las señales juntas
	
	COMPONENT nueva_pos_rand_async
	PORT(
		up_pos : IN std_logic_vector(2 downto 0);
		dw_pos : IN std_logic_vector(2 downto 0);
		rg_pos : IN std_logic_vector(2 downto 0);
		lf_pos : IN std_logic_vector(2 downto 0);
		my_x : IN std_logic_vector(2 downto 0);
		my_y : IN std_logic_vector(2 downto 0);          
		new_x : OUT std_logic_vector(2 downto 0);
		new_y : OUT std_logic_vector(2 downto 0);
		bt_rand: in std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT pos_circundantes
	PORT(
		my_x : IN std_logic_vector(2 downto 0);
		my_y : IN std_logic_vector(2 downto 0);          
		addr_up : OUT std_logic_vector(5 downto 0);
		addr_dw : OUT std_logic_vector(5 downto 0);
		addr_rg : OUT std_logic_vector(5 downto 0);
		addr_lf : OUT std_logic_vector(5 downto 0)
		);
	END COMPONENT;
	
begin
	
	Inst_nueva_pos_rand: nueva_pos_rand_async PORT MAP(
		up_pos => ff_up_pos,
		dw_pos => ff_dw_pos,
		rg_pos => ff_rg_pos,
		lf_pos => ff_lf_pos,
		my_x => my_pos_x,
		my_y => my_pos_y,
		new_x => my_pos_x_in,
		new_y => my_pos_y_in,
		bt_rand => bt_rand
	);
	
	Inst_pos_circundantes: pos_circundantes PORT MAP(
		my_x => my_pos_x,
		my_y => my_pos_y,
		addr_up => up_addr,
		addr_dw => dw_addr,
		addr_rg => rg_addr,
		addr_lf => lf_addr 
	);	
	
	---------------------------------------------------
	-- Proceso de calculo del estado siguiente y salidas mealy
	---------------------------------------------------
	p_next_state : process (current_state, ini, p2Hz) is
	begin
    case current_state is
      when espera =>
			if ini = '1' then
				next_state <= up_1;
			else
				next_state <= espera;
			end if;
      when up_1 =>
			next_state <= up_2;
      when up_2 =>
			next_state <= dw_1;
		when dw_1 =>
			next_state <= dw_2;
		when dw_2 =>
			next_state <= rg_1;
		when rg_1 =>
			next_state <= rg_2;
		when rg_2 =>
			next_state <= lf_1;
		when lf_1 =>
			next_state <= lf_2;
		when lf_2 =>
			-- Comentar para realizar simulaciones.
			if p2Hz = '1' then
				next_state <= new_pos;
			else
				next_state <= current_state;
			end if;
		when new_pos =>
			next_state <= wr_pos1;
		when wr_pos1 =>
			next_state <= wr_pos2;
		when wr_pos2 =>
			next_state <= espera;
    end case;
  end process p_next_state;
	---------------------------------------------------
	-- Proceso de asignación de valores a las salidas
	---------------------------------------------------
	p_outputs : process (current_state, up_addr, dw_addr, rg_addr, lf_addr, my_pos_y, my_pos_x)
		begin
			case current_state is
				-- Standby
				when espera =>
					ram_addr_rd <= (others => '0');
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '1';
					all_ld <= "00000";
				-- Leer arriba (1)
				when up_1 =>
					ram_addr_rd <= up_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00000";
				-- Leer arriba (2)
				when up_2 =>
					ram_addr_rd <= up_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "01000";
				-- Leer abajo (1)
				when dw_1 =>
					ram_addr_rd <= dw_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00000";
				-- Leer abajo (2)
				when dw_2 =>
					ram_addr_rd <= dw_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00100";
				-- Leer derecha (1)
				when rg_1 =>
					ram_addr_rd <= rg_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00000";
				-- Leer derecha (2)
				when rg_2 =>
					ram_addr_rd <= rg_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00010";
				-- Leer izquierda (1)
				when lf_1 =>
					ram_addr_rd <= lf_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00000";
				-- Leer izquierda (2)
				when lf_2 =>
					ram_addr_rd <= lf_addr;
					ram_addr_wr <= (others => '0');
					ram_data_wr <= (others => '0');
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00001";
				-- Calcular nueva posicion
				when new_pos =>
					ram_addr_rd <= (others => '0');
					ram_addr_wr <= my_pos_y & my_pos_x;
					ram_data_wr <= "000"; -- COLOR NEGRO
					ram_we 		<= '1';
					fin <= '0';
					all_ld <= "10000"; -- Aqui tengo que escribirla ya
				-- Escribir nueva posicion (1)
				when wr_pos1 =>
					ram_addr_rd <= (others => '0');
					ram_addr_wr <= my_pos_y & my_pos_x;
					ram_data_wr <= "110"; -- COLOR AMARILLO
					ram_we 		<= '0';
					fin <= '0';
					all_ld <= "00000";
				-- Escribir nueva posicion (2)
				when wr_pos2 =>
					ram_addr_rd <= (others => '0');
					ram_addr_wr <= my_pos_y & my_pos_x;
					ram_data_wr <= "110"; -- COLOR AMARILLO
					ram_we 		<= '1';
					fin <= '0';
					all_ld <= "00000";
			end case;
	end process p_outputs;
	
	---------------------------------------------------
	-- Proceso de actualizacion del estado
	---------------------------------------------------
	p_update_state: process (clk_50MHz, rst) is
		begin
			if rst = '1' then
				current_state <= espera;
			elsif rising_edge(clk_50MHz) then
				current_state <= next_state;
			end if;
	end process p_update_state;
	
	--------------------------------------------------
	-- Procesos de carga y reset de registros
	--------------------------------------------------
	p_regs: process(clk_50MHz, rst, all_ld)
		begin
			if rst = '1' then
				ff_up_pos <= (others => '0');
				ff_dw_pos <= (others => '0');
				ff_rg_pos <= (others => '0');
				ff_lf_pos <= (others => '0');
				my_pos_x <= "110";
				my_pos_y <= "110";
			elsif rising_edge(clk_50MHz) then
				-- Carga la posicion de arriba
				if all_ld = "01000" then
					ff_up_pos <= ram_data_rd;
					ff_dw_pos <= ff_dw_pos;
					ff_rg_pos <= ff_rg_pos;
					ff_lf_pos <= ff_lf_pos;
					my_pos_x <= my_pos_x;
					my_pos_y <= my_pos_y;
				-- Carga la posicion de abajo
				elsif all_ld = "00100" then
					ff_up_pos <= ff_up_pos;
					ff_dw_pos <= ram_data_rd;
					ff_rg_pos <= ff_rg_pos;
					ff_lf_pos <= ff_lf_pos;
					my_pos_x <= my_pos_x;
					my_pos_y <= my_pos_y;
				-- Carga la posicion derecha:
				elsif all_ld = "00010" then
					ff_up_pos <= ff_up_pos;
					ff_dw_pos <= ff_dw_pos;
					ff_rg_pos <= ram_data_rd;
					ff_lf_pos <= ff_lf_pos;
					my_pos_x <= my_pos_x;
					my_pos_y <= my_pos_y;
				-- Carga la posicion izquierda:
				elsif all_ld = "00001" then
					ff_up_pos <= ff_up_pos;
					ff_dw_pos <= ff_dw_pos;
					ff_rg_pos <= ff_rg_pos;
					ff_lf_pos <= ram_data_rd;
					my_pos_x <= my_pos_x;
					my_pos_y <= my_pos_y;
				-- Carga mi propia posicion:
				elsif all_ld = "10000" then
					ff_up_pos <= ff_up_pos;
					ff_dw_pos <= ff_dw_pos;
					ff_rg_pos <= ff_rg_pos;
					ff_lf_pos <= ff_lf_pos;
					my_pos_x <= my_pos_x_in;
					my_pos_y <= my_pos_y_in;
				-- No carga ninguno
				else
					ff_up_pos <= ff_up_pos;
					ff_dw_pos <= ff_dw_pos;
					ff_rg_pos <= ff_rg_pos;
					ff_lf_pos <= ff_lf_pos;
					my_pos_x <= my_pos_x;
					my_pos_y <= my_pos_y;
				end if;
			end if;
	end process p_regs;
end arq;





