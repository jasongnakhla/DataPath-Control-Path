----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 08:36:20 PM
-- Design Name: 
-- Module Name: a - Behavioral
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

entity a is
  Port (clk_a,rst_a,ld_a: in STD_LOGIC;
        a_in: in STD_LOGIC_VECTOR (7 downto 0);
        a_out: out STD_LOGIC_VECTOR (7 downto 0));
end a;

architecture Behavioral of a is

signal a_temp: STD_LOGIC_VECTOR (7 downto 0):=(others => '0');

begin


--if a_clr = 1
--make it all 0
--else if ld = 1
--temp <= input;
--else
--output <= output


process(clk_a,rst_a,ld_a)
    begin
        if (rising_edge(clk_a)) then
            if(rst_a = '1') then
                a_out <= (others => '0');
                a_temp <= (others => '0');
            else
                if(ld_a = '0') then
                    a_temp <= a_temp;
                else
                    a_temp <= a_in;
                    end if;
            end if;
            a_out <= a_temp;
        end if;
end process;



end Behavioral;
