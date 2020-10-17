----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 08:36:06 PM
-- Design Name: 
-- Module Name: sum - Behavioral
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

entity sum is
  Port (clk_sum,rst_sum,ld_sum: in STD_LOGIC;
        sum_in: in STD_LOGIC_VECTOR (8 downto 0);--:=(others => '0');
--        i_sum: in STD_LOGIC_VECTOR (8 downto 0);
        sum_out: out STD_LOGIC_VECTOR (8 downto 0));
end sum;

architecture Behavioral of sum is

signal sum_temp: STD_LOGIC_VECTOR (8 downto 0);

begin

process(clk_sum,rst_sum,ld_sum)
    begin
        if (rising_edge(clk_sum)) then
            if(rst_sum = '1') then
                sum_out <= (others => '0');
                sum_temp <= (others => '0');
            else
                if(ld_sum = '0') then
                    sum_temp <= sum_temp;
                else
                    sum_temp <= sum_in;
                    sum_out <= sum_temp;
                    end if;
            end if;
--            sum_out <= sum_temp;
        end if;
end process;

--process(clk_sum,rst_sum,ld_sum)
--    begin
--        if (rising_edge(clk_sum)) then
--            if(rst_sum = '1') then
--                sum_out <= (others => '0');
--                sum_temp <= (others => '0');
--            else
--                if(ld_sum = '0') then
--                    sum_temp <= sum_temp;
--                else
--                    sum_temp <= sum_in;
--                    end if;
--            end if;
--            sum_out <= sum_temp;
--        end if;
--end process;
                   


end Behavioral;
