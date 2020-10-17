----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 08:36:36 PM
-- Design Name: 
-- Module Name: i - Behavioral
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

entity i is
  Port (clk_i,rst_i,ld_i: in STD_LOGIC;
        i_in: in STD_LOGIC_VECTOR (7 downto 0):= (others => '0');
        i_out: out STD_LOGIC_VECTOR (7 downto 0);
        i_adder: out STD_LOGIC_VECTOR (7 downto 0));
end i;

architecture Behavioral of i is

signal i_temp, i_temp2, iadd: integer:=0;
signal twenty_five: integer := 25;

begin

        

process(clk_i,rst_i,ld_i)
    begin
        if (rising_edge(clk_i)) then
            if(rst_i = '1') then
                i_out <= (others => '0');
--                i_temp <= to_integer(unsigned(i_in));
                i_temp <= 0;
            else --rst = 0
            
                if(ld_i = '0') then
                    i_temp <= i_temp;
--                    i_temp2 <= i_temp2;
                else --ld = 1
                    if(i_temp = 32) then
                        i_temp <= 0;
                    else
                        i_temp <= i_temp + 1;
                    end if;
                end if;
            end if;
            i_out <= std_logic_vector(to_unsigned(i_temp,8));
        end if;
        
end process;


iadd <= i_temp + twenty_five;
i_adder <= std_logic_vector(to_unsigned(iadd,8));

end Behavioral;