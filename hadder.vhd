----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 08:35:32 PM
-- Design Name: 
-- Module Name: hadder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity hadder is
    Port ( a : in STD_LOGIC_VECTOR(7 downto 0);
           b : in STD_LOGIC_VECTOR(8 downto 0);
           sum : out STD_LOGIC_VECTOR(8 downto 0);
           cout : out STD_LOGIC);
end hadder;

architecture Behavioral of hadder is

signal temp_sum: STD_LOGIC_VECTOR(8 downto 0):=(others=>'0');

begin
process(a,b)
    begin
    temp_sum <= STD_LOGIC_VECTOR(('0' & unsigned(a)) + (unsigned(b)));
end process;

cout <= temp_sum(8);
sum <= temp_sum(8 downto 0);

end Behavioral;
