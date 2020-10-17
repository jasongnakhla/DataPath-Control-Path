----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 11:02:46 PM
-- Design Name: 
-- Module Name: FSM - Behavioral
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

entity FSM is
  Port (clk_FSM, rst_FSM: in STD_LOGIC;
        i_lt32: in STD_LOGIC_VECTOR (7 downto 0);
        avg_clr, i_clr, sum_clr, a_clr: out STD_Logic;
         avg_ld, i_ld, sum_ld, a_ld: out STD_Logic);
end FSM;

architecture Behavioral of FSM is

signal count: INTEGER;
type statetype is (s1,s2);--,s3);
signal currentstate, nextstate: statetype;
signal zero: INTEGER:=0;

begin

count <= to_integer(unsigned(i_lt32));

process(clk_FSM)
begin
    if rising_edge(clk_FSM) then
        if (rst_FSM = '1') then
            nextstate <= s1;
                -- Clear Controls --
                a_clr <= '1';
                sum_clr <= '1';
                i_clr <= '1';
                avg_clr <= '1';
                -- Load Controls --
                a_ld <= '0';
                sum_ld <= '0';
                i_ld <= '0';
                avg_ld <= '0';
        else
        case nextstate is
            when s1 =>
                if count < 32 then
                    nextstate <= s1;
                        -- Clear Controls --
                        a_clr <= '0';
                        sum_clr <= '0';
                        i_clr <= '0';
                        avg_clr <= '1';
                        -- Load Controls --
                        i_ld <= '1';
                        a_ld  <= '1';
                        sum_ld <= '1';
                        avg_ld <= '0';
                else
                    nextstate <= s2;
                        -- Clear Controls --
                        a_clr <= '1';
                        sum_clr <= '1';
                        i_clr <= '1';
                        avg_clr <= '0';
                        -- Load Controls --
                        i_ld <= '0';
                        a_ld  <= '0';
                        sum_ld <= '0';
                        avg_ld <= '1';
                end if;
            when s2 =>
                nextstate <= s1;
                    -- Clear Controls --
                    a_clr <= '0';
                    sum_clr <= '0';
                    i_clr <= '0';
                    avg_clr <= '1';
                    -- Load Controls --
                    i_ld <= '1';
                    a_ld  <= '1';
                    sum_ld <= '1';
                    avg_ld <= '0';
            end case;
        end if;
    end if;
end process;






















----next state & output logic
--next_state: process (currentstate,nextstate)
--    begin
--        case currentstate is
--            when st0 =>
----                if (count = 0) then
--                    nextstate <= st1;
----                    avg_clr <= '1';
----                    avg_ld <= '0';
----                    i_clr <= '0';
----                    i_ld <= '1';
----                    sum_clr <= '0';
----                    sum_ld <= '1';
----                    a_clr <= '0';
----                    a_ld <= '1';
----                else
----                    nextstate <= st1;
----                end if;
--            when st1 =>
----                if (count /= 0 or count /=32) then
--                    nextstate <= st2;
----                    avg_clr <= '0';
----                    avg_ld <= '1';
----                    i_clr <= '0';
----                    i_ld <= '1';
----                    sum_clr <= '0';
----                    sum_ld <= '1';
----                    a_clr <= '0';
----                    a_ld <= '1';
----                else
----                    nextstate <= st0;
----                end if;
--            when st2 =>
----                if (count = 32) then
--                    nextstate <= st0;
----                    avg_clr <= '0';
----                    avg_ld <= '0';
----                    i_clr <= '1';
----                    i_ld <= '0';
----                    sum_clr <= '1';
----                    sum_ld <= '0';
----                    a_clr <= '1';
----                    a_ld <= '0';
----                else
----                    nextstate <= st2;
----                end if;
--            when others =>
--                nextstate <= st0;
--        end case;
--end process;

----current state logic
--current_state: process (clk_FSM, rst_FSM, nextstate)
--    begin
--        if(rising_edge(clk_FSM)) then
--            if (rst_FSM = '1') then
--                currentstate <= st0;
--            else
--                currentstate <= nextstate;
--                if (count = 0) then
--                    avg_clr <= '1';
--                    avg_ld <= '0';
--                    i_clr <= '0';
--                    i_ld <= '1';
--                    sum_clr <= '0';
--                    sum_ld <= '0';--'1';
--                    a_clr <= '0';
--                    a_ld <= '1';
----                elsif (count /= 0 or count /= 32) then
----                    avg_clr <= '0';
----                    avg_ld <= '1';
----                    i_clr <= '0';
----                    i_ld <= '1';
----                    sum_clr <= '0';
----                    sum_ld <= '1';
----                    a_clr <= '0';
----                    a_ld <= '1';
--                elsif (count =32) then
--                    avg_clr <= '0';
--                    avg_ld <= '0';
--                    i_clr <= '1';
--                    i_ld <= '0';
--                    sum_clr <= '1';
--                    sum_ld <= '0';
--                    a_clr <= '1';
--                    a_ld <= '0';
--                elsif (count = 1) then
--                    avg_clr <= '0';
--                    avg_ld <= '1';
--                    i_clr <= '0';
--                    i_ld <= '1';
--                    sum_clr <= '0';
--                    sum_ld <= '0';
--                    a_clr <= '0';
--                    a_ld <= '1';
--                else
--                    avg_clr <= '0';
--                    avg_ld <= '1';
--                    i_clr <= '0';
--                    i_ld <= '1';
--                    sum_clr <= '0';
--                    sum_ld <= '1';
--                    a_clr <= '0';
--                    a_ld <= '1';
--                end if;
--            end if;
--        end if;
--end process;

end Behavioral;