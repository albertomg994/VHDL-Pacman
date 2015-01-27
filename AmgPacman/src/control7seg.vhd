-- ========== Copyright Header Begin =============================================
-- AmgPacman File: control7seg.vhd
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
entity control7seg is
    port ( clk_1KHz : in  STD_LOGIC;
			  rst: in std_logic;
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (6 downto 0);
           sel : out  STD_LOGIC_VECTOR (3 downto 0));
end control7seg;

-- =================================================================================
--           ARCHITECTURE
-- =================================================================================
architecture rtl of control7seg is

 -- Tipos propios:
  type t_st is (s0, s1, s2, s3);

-----------------------------------------------------------------------------
-- Declaracion de senales
-----------------------------------------------------------------------------
	signal current_state, next_state : t_st;         -- Estados actual y siguiente.
	
	signal disp0: std_logic_vector(3 downto 0);
	signal disp1: std_logic_vector(3 downto 0);
	signal disp2: std_logic_vector(3 downto 0);
	signal disp3: std_logic_vector(3 downto 0);
	
	signal dispBin_aux: std_logic_vector(3 downto 0);
-----------------------------------------------------------------------------
-- Componentes
-----------------------------------------------------------------------------
begin
-----------------------------------------------------------------------------
-- Conexion de senales
-----------------------------------------------------------------------------
	disp0 <= data_in(3 downto 0);	-- disp0 es el de mas a la derecha
	disp1 <= data_in(7 downto 4);
	disp2 <= data_in(11 downto 8);
	disp3 <= data_in(15 downto 12);
-----------------------------------------------------------------------------
-- Instancia de componentes
-----------------------------------------------------------------------------

---------------------------------------------------
-- Proceso de calculo del estado siguiente
---------------------------------------------------
	p_next_state : process (current_state) is
	begin
    case current_state is
      when s0 =>
            next_state <= s1;
      when s1 =>
				next_state <= s2;
      when s2 =>
			next_state <= s3;
		when others =>
			next_state <= s0;
    end case;
  end process p_next_state;
---------------------------------------------------
-- Proceso de asignación de valores a las salidas
---------------------------------------------------
	p_outputs : process (current_state, disp0, disp1, disp2, disp3)
		begin
			case current_state is
				when s0 =>
					dispBin_aux <= disp0;
					sel <= "1110";
				when s1 =>
					dispBin_aux <= disp1;
					sel <= "1101";
				when s2 =>
					dispBin_aux <= disp2;
					sel <= "1011";
				when s3 =>
					dispBin_aux <= disp3;
					sel <= "0111";
				when others =>
					dispBin_aux <= (others => '0');
					sel <= "1111";
			end case;
	end process p_outputs;  
---------------------------------------------------
-- Proceso de actualizacion del estado
---------------------------------------------------
  p_status_reg : process (clk_1KHz, rst) is
  begin
    if rst = '1' then
      current_state <= s0;
    elsif rising_edge(clk_1KHz) then
      current_state <= next_state;
    end if;
  end process p_status_reg;
---------------------------------------------------
-- Conversion binario - 7seg
---------------------------------------------------
	p_conv: process(dispBin_aux) is
	begin
		case dispBin_aux is
			when "0000" => --0
				data_out <= "1000000";
			when "0001" => --1
				data_out <= "1111001";
			when "0010" => --2
				data_out <= "0100100";
			when "0011" => --3
				data_out <= "0110000";
			when "0100" => --4
				data_out <= "0011001";
			when "0101" => --5
				data_out <= "0010010";
			when "0110" => --6
				data_out <= "0000010";
			when "0111" => --7
				data_out <= "1111000";
			when "1000" => --8
				data_out <= "0000000";
			when "1001" => --9
				data_out <= "0010000";
			when "1010" => --A
				data_out <= "0001000";
			when "1011" => --B
				data_out <= "0000011";
			when "1100" => --C
				data_out <= "1000110";
			when "1101" => --D
				data_out <= "0100001";
			when "1110" => --E
				data_out <= "0000110";
			when "1111" => --F
				data_out <= "0001110";
			when others => --apagado
				data_out <= "1111111";
		end case;
	end process p_conv;

end rtl;

