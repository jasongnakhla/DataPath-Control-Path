----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/15/2020 06:02:06 PM
-- Design Name: 
-- Module Name: path_tb - Behavioral
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

entity path_tb is
--  Port ( );
end path_tb;

architecture Behavioral of path_tb is

component Path is
  Port (clk, rst: IN STD_LOGIC);
end component Path;

signal clk_tb, rst_tb: STD_LOGIC;
constant cp: time:= 10ns;

begin

uut: path port map(clk => clk_tb, rst => rst_tb);

--clk
process
begin
clk_tb <= '1';
wait for cp/2;
clk_tb <= '0';
wait for cp/2;
end process;

--reset
process
begin
--rst_tb <= '1';
--wait for cp*1.5;
rst_tb <= '0';
wait;
end process;

end Behavioral;