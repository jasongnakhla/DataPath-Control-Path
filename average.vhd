----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 11:34:26 PM
-- Design Name: 
-- Module Name: average - Behavioral
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
--use IEEE.Std_logic_arith.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity average is
    Port ( clk_avg, rst_avg, ld_avg : in STD_LOGIC;
           avg_in : in STD_LOGIC_VECTOR (8 downto 0);--:=(others=>'0');
           avg_out : out STD_LOGIC_VECTOR (8 downto 0));
end average;

architecture Behavioral of average is

signal avg_temp, avg_temp2: UNSIGNED(8 downto 0):= (others => '0');
signal five: INTEGER:=5;

begin

--avg_temp <= unsigned(avg_in);

process(clk_avg,rst_avg,ld_avg)
    begin
        if (rising_edge(clk_avg)) then
            if(rst_avg = '0') then
                avg_out <= (others => '0');
                avg_temp2 <= (others => '0');
            else
                if(ld_avg = '1') then
                    avg_temp2 <= avg_temp2;
                else
--                    avg_temp <= unsigned(avg_in);--to_bitvector(avg_in);
                    avg_temp2 <= avg_temp2 + unsigned(avg_in);--;avg_temp;
                       
--                    avg_temp <= avg_temp srl five;
                    end if;
            end if;            
        end if;
end process;
avg_temp <= avg_temp2 srl five; 
       avg_out <= std_logic_vector(avg_temp);        


end Behavioral;
