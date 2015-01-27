-- ========== Copyright Header Begin =============================================
-- AmgPacman File: top.vhd
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
entity top is
    Port ( clk_50MHz : in  STD_LOGIC;
           rst : in  STD_LOGIC;
			  init_ini: in std_logic;
			  bt_db: in std_logic;
			  init_fin_led: out std_logic;
           hsync : out  STD_LOGIC;
           vsync : out  STD_LOGIC;
           vga_red : out  STD_LOGIC_VECTOR (2 downto 0);
           vga_green : out  STD_LOGIC_VECTOR (2 downto 0);
           vga_blue : out  STD_LOGIC_VECTOR (1 downto 0);
			  disp7seg_sel: out std_logic_vector(3 downto 0);
			  disp7seg_data: out std_logic_vector(6 downto 0);
			  ram_data_leds: out std_logic_vector(2 downto 0);
			  sw_debug: in std_logic_vector(1 downto 0)
		);
end top;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture arq of top is

------------------------------------------------------------------------------------
-- Componentes
------------------------------------------------------------------------------------
	COMPONENT sincronismo
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;          
		hsync : OUT std_logic;
		vsync : OUT std_logic;
		pos_h : OUT std_logic_vector(9 downto 0);
		pos_v : OUT std_logic_vector(9 downto 0)
		);
	END COMPONENT;

	COMPONENT ram_dp_sr_sw
	PORT(
		rst : IN std_logic;
		clk : IN std_logic;
		address_0 : IN std_logic_vector(5 downto 0);
		data_0 : IN std_logic_vector(2 downto 0);
		wr_0 : IN std_logic;
		address_1 : IN std_logic_vector(5 downto 0);
		address_2 : IN std_logic_vector(5 downto 0);
		bt_ld : IN std_logic;          
		data_1 : OUT std_logic_vector(2 downto 0);
		data_2 : OUT std_logic_vector(2 downto 0);
		addr_db : OUT std_logic_vector(5 downto 0);
		data_db : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;
	
	COMPONENT init_ram
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;
		ini : IN std_logic;          
		ram_addr : OUT std_logic_vector(5 downto 0);
		ram_data : OUT std_logic_vector(2 downto 0);
		ram_we : OUT std_logic;
		fin : OUT std_logic
		);
	END COMPONENT;

	COMPONENT rgb_conv
	PORT(
		r : IN std_logic;
		g : IN std_logic;
		b : IN std_logic;
		pos_h : in std_logic_vector(9 downto 0);
		pos_v : in std_logic_vector(9 downto 0);
		r_out : OUT std_logic_vector(2 downto 0);
		g_out : OUT std_logic_vector(2 downto 0);
		b_out : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT freqDividerV3
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;          
		clk_1KHz : OUT std_logic;
		pulso_2Hz : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT debouncer
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		x : IN std_logic;
		pulso2Hz : IN std_logic;          
		xDeb : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT control7seg
	PORT(
		clk_1KHz : IN std_logic;
		rst : IN std_logic;
		data_in : IN std_logic_vector(15 downto 0);          
		data_out : OUT std_logic_vector(6 downto 0);
		sel : OUT std_logic_vector(3 downto 0)
		);
	END COMPONENT;
	
	COMPONENT fantasma_v0
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;
		p2Hz : IN std_logic;
		ini : IN std_logic;
		ram_data_rd : IN std_logic_vector(2 downto 0);          
		fin : OUT std_logic;
		ram_addr_rd : OUT std_logic_vector(5 downto 0);
		ram_addr_wr : OUT std_logic_vector(5 downto 0);
		ram_data_wr : OUT std_logic_vector(2 downto 0);
		ram_we		: OUT std_logic;
		sw_debug	  : in std_logic_vector(1 downto 0);
		data_db	  : out std_logic_vector(2 downto 0);
		bt_rand	  : in std_logic_vector(1 downto 0)
		);
	END COMPONENT;
	
	COMPONENT fantasma2
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;
		p2Hz : IN std_logic;
		ini : IN std_logic;
		ram_data_rd : IN std_logic_vector(2 downto 0);
		bt_rand : IN std_logic_vector(1 downto 0);          
		fin : OUT std_logic;
		ram_addr_rd : OUT std_logic_vector(5 downto 0);
		ram_addr_wr : OUT std_logic_vector(5 downto 0);
		ram_data_wr : OUT std_logic_vector(2 downto 0);
		ram_we : OUT std_logic
		);
	END COMPONENT;
	
	COMPONENT fantasma3
	PORT(
		clk_50MHz : IN std_logic;
		rst : IN std_logic;
		p2Hz : IN std_logic;
		ini : IN std_logic;
		ram_data_rd : IN std_logic_vector(2 downto 0);
		bt_rand : IN std_logic_vector(1 downto 0);          
		fin : OUT std_logic;
		ram_addr_rd : OUT std_logic_vector(5 downto 0);
		ram_addr_wr : OUT std_logic_vector(5 downto 0);
		ram_data_wr : OUT std_logic_vector(2 downto 0);
		ram_we : OUT std_logic
		);
	END COMPONENT;
	
------------------------------------------------------------------------------------
-- Declaración de señales
------------------------------------------------------------------------------------

	-- Senales auxiliares (pos. pantalla VGA)
	signal pos_h_aux: std_logic_vector(9 downto 0);
	signal pos_v_aux: std_logic_vector(9 downto 0);
	
	----------------------------------------------------------
	-- Puerto 0 de solo escritura (inicializacion y fanstasma)
	----------------------------------------------------------
	-- Conexiones directas a los puertos de la RAM
	signal ram_addr_0: std_logic_vector(5 downto 0);
	signal ram_data_0: std_logic_vector(2 downto 0);
	signal ram_wr_0  : std_logic;
	-- Conexiones procedentes del módulo de inicialización:
	signal ram_addr_0_init: std_logic_vector(5 downto 0);
	signal ram_data_0_init: std_logic_vector(2 downto 0);
	signal ram_wr_0_init  : std_logic;
	-- Conexiones procedentes del primer fantasma:
	signal ram_addr_0_f1: std_logic_vector(5 downto 0);
	signal ram_data_0_f1: std_logic_vector(2 downto 0);
	signal ram_wr_0_f1  : std_logic;
	-- Conexiones procedentes del segundo fantasma:
	signal ram_addr_0_f2: std_logic_vector(5 downto 0);
	signal ram_data_0_f2: std_logic_vector(2 downto 0);
	signal ram_wr_0_f2  : std_logic;
	-- Conexiones procedentes del tercer fantasma:
	signal ram_addr_0_f3: std_logic_vector(5 downto 0);
	signal ram_data_0_f3: std_logic_vector(2 downto 0);
	signal ram_wr_0_f3  : std_logic;
	
	----------------------------------------------------------
	-- Puerto 1 de solo lectura: lectura VGA
	----------------------------------------------------------
	signal ram_addr_1: std_logic_vector(5 downto 0);
	signal ram_data_1: std_logic_vector(2 downto 0);
	
	----------------------------------------------------------
	-- Puerto 2 de solo lectura: lectura fantasmas
	----------------------------------------------------------
	-- Conexiones directas a los puertos de la RAM:
	signal ram_addr_2: std_logic_vector(5 downto 0);
	signal ram_data_2: std_logic_vector(2 downto 0);
	-- Conexiones procedentes del primer fantasma:
	signal ram_addr_2_f1: std_logic_vector(5 downto 0);
	signal ram_data_2_f1: std_logic_vector(2 downto 0);
	-- Conexiones procedentes del segundo fantasma:
	signal ram_addr_2_f2: std_logic_vector(5 downto 0);
	signal ram_data_2_f2: std_logic_vector(2 downto 0);
	-- Conexiones procedentes del tercer fantasma:
	signal ram_addr_2_f3: std_logic_vector(5 downto 0);
	signal ram_data_2_f3: std_logic_vector(2 downto 0);

	----------------------------------------------------------
	-- Señales de la FSM principal:
	----------------------------------------------------------
	type t_st is (s0, s1, fantasma1_st, fantasma2_st, fantasma3_st);
	signal current_state, next_state : t_st; -- Estados actual y siguiente
	signal init_fin: std_logic;
	signal start_fantasma1 : std_logic;
	signal fin_fantasma1   : std_logic;
	signal start_fantasma2 : std_logic;
	signal fin_fantasma2   : std_logic;
	signal start_fantasma3 : std_logic;
	signal fin_fantasma3   : std_logic;
	
	----------------------------------------------------------
	-- Señales Auxiliares:
	----------------------------------------------------------
	-- Señales de reloj auxiliares:
	signal clk_1KHz_aux: std_logic;
	signal pulso_2Hz_aux: std_logic;
	-- Señales de depuración:
	signal ram_addr_debug: std_logic_vector(5 downto 0);
	signal ram_addr_debug_ext: std_logic_vector(15 downto 0);
	signal fantasma_debug_data: std_logic_vector(2 downto 0);
	signal bt_db_deb: std_logic;
	-- Otros
	signal rand_aux: std_logic_vector(1 downto 0);
	
begin
------------------------------------------------------------------------------------
-- Conexión de señales
------------------------------------------------------------------------------------
	-- La direccion de lectura depende de las coordenadas:
	ram_addr_1 <= pos_v_aux(6 downto 4) & pos_h_aux(6 downto 4); --Lectura VGA
	init_fin_led <= init_fin;
	ram_addr_debug_ext <= "00000" & fantasma_debug_data & "00" & ram_addr_debug;
	rand_aux <= pos_v_aux(3) & pos_v_aux(2);
	
------------------------------------------------------------------------------------
-- Conexión de componentes
------------------------------------------------------------------------------------
	Inst_sincronismo: sincronismo PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		hsync => hsync,
		vsync => vsync,
		pos_h => pos_h_aux,
		pos_v => pos_v_aux
	);
	Inst_rgb_conv: rgb_conv PORT MAP(
		r => ram_data_1(2),
		g => ram_data_1(1),
		b => ram_data_1(0),
		pos_h => pos_h_aux,
		pos_v => pos_v_aux,
		r_out => vga_red,
		g_out => vga_green,
		b_out => vga_blue
	);
	
	Inst_init_ram: init_ram PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		ini => init_ini,
		ram_addr => ram_addr_0_init,
		ram_data => ram_data_0_init,
		ram_we => ram_wr_0_init,
		fin => init_fin
	);
	
	Inst_ram_dp_sr_sw: ram_dp_sr_sw PORT MAP(
		rst => rst,
		clk => clk_50MHz,
		-- Puerto 0: solo escritura. (inicializacion y fantasma)
		address_0 => ram_addr_0,
		data_0 => ram_data_0,
		wr_0 => ram_wr_0,
		-- Puerto 1: solo lectura (VGA)
		address_1 => ram_addr_1,
		data_1 => ram_data_1,
		-- Puerto 2: solo lectura (fantasma)
		address_2 => ram_addr_2,
		data_2 => ram_data_2,
		-- Puertos de depuración
		bt_ld => bt_db_deb,
		addr_db => ram_addr_debug,
		data_db => ram_data_leds
	);
	
	Inst_freqDividerV3: freqDividerV3 PORT MAP(
		clk => clk_50MHz,
		rst => rst,
		clk_1KHz => clk_1KHz_aux,
		pulso_2Hz => pulso_2Hz_aux
	);
	Inst_debouncer: debouncer PORT MAP(
		clk => clk_50MHz,
		rst => rst,
		x => bt_db,
		pulso2Hz => pulso_2Hz_aux,
		xDeb => bt_db_deb
	);
	Inst_control7seg: control7seg PORT MAP(
		clk_1KHz => clk_1KHz_aux,
		rst => rst,
		data_in => ram_addr_debug_ext,
		data_out => disp7seg_data,
		sel => disp7seg_sel
	);

	fantasma1: fantasma_v0 PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		p2Hz => pulso_2Hz_aux,
		ini => start_fantasma1,
		fin => fin_fantasma1,
		ram_addr_rd => ram_addr_2_f1,
		ram_data_rd => ram_data_2_f1,
		ram_addr_wr => ram_addr_0_f1,
		ram_data_wr => ram_data_0_f1,
		ram_we  		=> ram_wr_0_f1,
		sw_debug	   => sw_debug,
		data_db => fantasma_debug_data,
		bt_rand => rand_aux
	);
	
	Inst_fantasma2: fantasma2 PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		p2Hz => pulso_2Hz_aux,
		ini => start_fantasma2,
		fin => fin_fantasma2,
		ram_addr_rd => ram_addr_2_f2,
		ram_data_rd => ram_data_2_f2,
		ram_addr_wr => ram_addr_0_f2,
		ram_data_wr => ram_data_0_f2,
		ram_we => ram_wr_0_f2,
		bt_rand => rand_aux
	);
	
	Inst_fantasma3: fantasma3 PORT MAP(
		clk_50MHz => clk_50MHz,
		rst => rst,
		p2Hz => pulso_2Hz_aux,
		ini => start_fantasma3,
		fin => fin_fantasma3,
		ram_addr_rd => ram_addr_2_f3,
		ram_data_rd => ram_data_2_f3,
		ram_addr_wr => ram_addr_0_f3,
		ram_data_wr => ram_data_0_f3,
		ram_we => ram_wr_0_f3,
		bt_rand => rand_aux
	);
	
------------------------------------------------------------------------------------
-- Procesos
------------------------------------------------------------------------------------

	---------------------------------------------------
	-- Cálculo del estado siguiente y salidas Mealy
	---------------------------------------------------
	p_next_state : process (current_state, init_fin, init_ini, fin_fantasma1, fin_fantasma2, fin_fantasma3) is
	begin
    case current_state is
      when s0 =>
			start_fantasma1 <= '0';
			start_fantasma2 <= '0';
			start_fantasma3 <= '0';
			if init_ini = '1' then
            next_state <= s1;
			else
				next_state <= s0;
			end if;
      when s1 =>
			start_fantasma2 <= '0';
			start_fantasma3 <= '0';
			if init_fin = '1' then
				start_fantasma1 <= '1';
				next_state <= fantasma1_st;
			else
				start_fantasma1 <= '0';
				next_state <= s1;
			end if;
      when fantasma1_st =>
			start_fantasma1 <= '0';
			start_fantasma3 <= '0';
			if fin_fantasma1 = '1' then
				start_fantasma2 <= '1';
				next_state <= fantasma2_st;
			else
				start_fantasma2 <= '0';
				next_state <= current_state;
			end if;
		when fantasma2_st =>
			start_fantasma1 <= '0';
			start_fantasma2 <= '0';
			if fin_fantasma2 = '1' then
				start_fantasma3 <= '1';
				next_state <= fantasma3_st;
			else
				start_fantasma3 <= '0';
				next_state <= current_state;
			end if;
		when fantasma3_st =>
			start_fantasma2 <= '0';
			start_fantasma3 <= '0';
			if fin_fantasma3 = '1' then
				start_fantasma1 <= '1';
				next_state <= fantasma1_st;
			else
				start_fantasma1 <= '0';
				next_state <= current_state;
			end if;
    end case;
  end process p_next_state;

	---------------------------------------------------
	-- Multiplexor de la escritura en RAM (compartida por fantasmas e inicializacion)
	---------------------------------------------------
	p_mux_ram_wr_0: process(current_state, ram_wr_0_f1, ram_addr_0_f1, ram_data_0_f1, ram_wr_0_f2, ram_addr_0_f2, ram_data_0_f2, ram_wr_0_f3, ram_addr_0_f3, ram_data_0_f3, ram_wr_0_init, ram_addr_0_init, ram_data_0_init)
		begin
			if current_state = fantasma1_st then --Game
				ram_wr_0   <= ram_wr_0_f1;
				ram_addr_0 <= ram_addr_0_f1;
				ram_data_0 <= ram_data_0_f1;
			elsif current_state = fantasma2_st then
				ram_wr_0   <= ram_wr_0_f2;
				ram_addr_0 <= ram_addr_0_f2;
				ram_data_0 <= ram_data_0_f2;
			elsif current_state = fantasma3_st then
				ram_wr_0   <= ram_wr_0_f3;
				ram_addr_0 <= ram_addr_0_f3;
				ram_data_0 <= ram_data_0_f3;
			elsif current_state = s1 then
				ram_wr_0   <= ram_wr_0_init;
				ram_addr_0 <= ram_addr_0_init;
				ram_data_0 <= ram_data_0_init;
			else
				ram_wr_0   <= '0';
				ram_addr_0 <= (others => '0');
				ram_data_0 <= (others => '0');
			end if;
	end process p_mux_ram_wr_0;
	
	---------------------------------------------------
	-- Multiplexor de la lectura de RAM (común a todos los fantasmas)
	---------------------------------------------------
	p_mux_ram_rd_2: process(current_state, ram_addr_2_f1, ram_addr_2_f2, ram_addr_2_f3, ram_data_2)
		begin
			if current_state = fantasma1_st then
				ram_addr_2 <= ram_addr_2_f1;
				ram_data_2_f1 <= ram_data_2;
				ram_data_2_f2 <= (others => '0');
				ram_data_2_f3 <= (others => '0');
			elsif current_state = fantasma2_st then
				ram_addr_2 <= ram_addr_2_f2;
				ram_data_2_f2 <= ram_data_2;
				ram_data_2_f1 <= (others => '0');
				ram_data_2_f3 <= (others => '0');
			elsif current_state = fantasma3_st then--
				ram_addr_2 <= ram_addr_2_f3;
				ram_data_2_f3 <= ram_data_2;
				ram_data_2_f1 <= (others => '0');
				ram_data_2_f2 <= (others => '0');
			else
				ram_addr_2 <= (others => '0');
				ram_data_2_f3 <= (others => '0');
				ram_data_2_f2 <= (others => '0');
				ram_data_2_f1 <= (others => '0');
			end if;
	end process p_mux_ram_rd_2;
	
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

