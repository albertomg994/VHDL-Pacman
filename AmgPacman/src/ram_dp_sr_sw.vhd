-- ========== Copyright Header Begin =============================================
-- AmgPacman File: ram_dp_sr_sw.vhd
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
library ieee;
    use ieee.std_logic_1164.all;
    use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
entity ram_dp_sr_sw is
    generic (
        DATA_WIDTH :integer := 3;
        ADDR_WIDTH :integer := 6
    );
    port (
		  -- Señales comunes:
        rst       : in    std_logic;                                 -- Reset
        clk       : in    std_logic;                                 -- Clock Input
		  -- Puerto 0 (solo escritura)
        address_0 : in std_logic_vector (ADDR_WIDTH-1 downto 0);  -- Dir. escritura (port 0)
        data_0    : in std_logic_vector (DATA_WIDTH-1 downto 0);  -- Dato escribir (port 0)
        wr_0      : in std_logic;                                 -- Write Enable (port 0)
		  -- Puerto 1 (solo lectura)
        address_1 : in  std_logic_vector (ADDR_WIDTH-1 downto 0);  -- Dir. lectura (port 1)
        data_1    : out std_logic_vector (DATA_WIDTH-1 downto 0);  -- Dato leído (port 1)
		  -- Puerto 2 (solo lectura)
		  address_2 : in  std_logic_vector (ADDR_WIDTH-1 downto 0); -- Dir. lectura (port 2)
		  data_2		: out std_logic_vector (DATA_WIDTH-1 downto 0); -- Dato leído (port 2)
		  -- NOTA: metemos la direccion y da el dato en el siguiente ciclo(?)
		  -- Senales de depuracion:
		  bt_ld: in std_logic;
		  addr_db: out std_logic_vector(5 downto 0);
		  data_db: out std_logic_vector(2 downto 0)
 
    );
end entity;

architecture rtl of ram_dp_sr_sw is

		 constant RAM_DEPTH :integer := 2**ADDR_WIDTH;
		 
		 signal data_1_out : std_logic_vector (DATA_WIDTH-1 downto 0);
		 signal data_2_out : std_logic_vector (DATA_WIDTH-1 downto 0);
		 
		 type RAM is array (integer range <>)of std_logic_vector (DATA_WIDTH-1 downto 0); -- ORIGINAL
		 signal mem : RAM (0 to RAM_DEPTH-1); -- original
		 
		 --Senales debug
		 signal cntr_db: std_logic_vector( 5 downto 0);
begin
		-- Conexion de senales de depuracion
		----------------------------------------------------------
		addr_db <= cntr_db;
		data_db <= mem(conv_integer(cntr_db));


		 -- Puerto_0: solo escritura
		 -------------------------------------------------------
		 MEM_WRITE_0: process (rst,clk) begin
			if rst = '1' then
				mem(0) <= "100";
				mem(7) <= "010";
				mem(63) <= "001";
			elsif rising_edge(clk) then
				if wr_0 = '1' then
					mem(conv_integer(address_0)) <= data_0; 
				end if;
			end if;
		 end process;

		 -- Puerto_1: solo lectura
		 -------------------------------------------------------
		 data_1 <= data_1_out;
		 MEM_READ_1: process (rst,clk) begin
			if rising_edge(clk) then 
				data_1_out <= mem(conv_integer(address_1)); 
			end if;
		 end process;
		 
		 -- Puerto_2: solo lectura
		 -------------------------------------------------------
		 data_2 <= data_2_out;
		 MEM_READ_2: process (rst,clk) begin
			if rising_edge(clk) then 
				data_2_out <= mem(conv_integer(address_2)); 
			end if;
		 end process;
		 
		 -- Contador de depuración
		 ---------------------------------------------------------------
		 p_cntr_db: process(clk, rst, bt_ld)
			begin
				if rst = '1' then
					cntr_db <= (others => '0');
				elsif rising_edge(clk) then
					if bt_ld = '1' then
						cntr_db <= std_logic_vector(unsigned(cntr_db) + 1);
					else
						cntr_db <= cntr_db;
					end if;
				end if;
		end process p_cntr_db;
		-----------------------------------------------------------------
end architecture;
 