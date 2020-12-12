----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/10/2020 10:33:17 PM
-- Design Name: 
-- Module Name: Master_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Master_tb is
--  Port ( );
end Master_tb;

architecture Behavioral of Master_tb is

component Master is
--    --speed the i2c bus (scl) will run at in Hz
  Port (clk: in STD_LOGIC;          
        -- system clock 400 kHz
        rst: in STD_LOGIC;      
        -- Asynchronous active low reset.
        ena: in STD_LOGIC;          
        --0: no transaction is initiated. 1: latches in addr, rw, and data_wr to initiate a transaction.  If ena is high at the conclusion of a transaction (i.e. when busy goes low) then a new address, read/write command, and data are latched in to continue the transaction.
        addr: in STD_LOGIC_VECTOR(6 downto 0); 
        --Address of target slave.
        rw: in STD_LOGIC;           
        --0: write command. 1: read command.
        data_wr: in STD_LOGIC_VECTOR(7 downto 0); 
        --Data to transmit if rw = 0 (write).
        data_rd: out STD_LOGIC_VECTOR(7 downto 0); 
        --Data received if rw = 1 (read).
        busy: out STD_LOGIC;           
        --0: I2C master is idle and last read data is available on data_rd. 1: command has been latched in and transaction is in progress.
        ack_error: BUFFER STD_LOGIC;     
        --0: no acknowledge errors. 1: at least one acknowledge error occurred during the transaction.  ack_error clears itself at the beginning of each transaction.
        sda: inout STD_LOGIC;         
        --Serial data line of I2C bus.
        scl: inout STD_LOGIC);       
        --Serial clock line of I2C bus. 50 MHz
end component Master;

signal clk, rst, ena, rw, busy, ack_error, sda, scl: std_logic;
signal addr: std_logic_vector(6 downto 0);
signal data_rd, data_wr: std_logic_vector(7 downto 0);
constant cp: time:=20ns;

begin

uut: Master port map(clk => clk, rst => rst, ena => ena, addr => addr, rw => rw, data_wr => data_wr, data_rd => data_rd, busy => busy, ack_error => ack_error, sda => sda, scl => scl);

--clk
process
begin
clk <= '1';
wait for cp/2;
clk <= '0';
wait for cp/2;
end process;

--rst
process
begin
rst <= '1';
wait for 2*cp;
rst <= '0';
wait;
end process;

--ena
process
begin
ena <= '1';
wait for 48000ns;
ena <= '0';
wait;
end process;

--addr
process
begin
addr <= "1010101";
wait;
end process;

--write
process
begin
rw <= '0';
wait;
end process;

--data_in
process
begin
data_wr <= "10011001";
wait;
end process;

end Behavioral;
