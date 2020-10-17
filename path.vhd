----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/13/2020 08:22:55 PM
-- Design Name: 
-- Module Name: Path - Behavioral
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

entity Path is
  Port (clk, rst: IN STD_LOGIC);
end Path;

architecture Behavioral of Path is

COMPONENT blk_mem_gen_0
  PORT (
    clka : IN STD_LOGIC;
--    ena : IN STD_LOGIC;
    addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

component hadder is
    Port ( a : in STD_LOGIC_VECTOR(7 downto 0);
           b : in STD_LOGIC_VECTOR(8 downto 0);
           sum : out STD_LOGIC_VECTOR(8 downto 0);
           cout : out STD_LOGIC);
end component hadder;

component sum is
  Port (clk_sum,rst_sum,ld_sum: in STD_LOGIC;
        sum_in: in STD_LOGIC_VECTOR (8 downto 0);
        sum_out: out STD_LOGIC_VECTOR (8 downto 0));
end component sum;

component average is
    Port ( clk_avg, rst_avg, ld_avg : in STD_LOGIC;
           avg_in : in STD_LOGIC_VECTOR (8 downto 0);
           avg_out : out STD_LOGIC_VECTOR (8 downto 0));
end component average;

component i is
  Port (clk_i,rst_i,ld_i: in STD_LOGIC;
        i_in: in STD_LOGIC_VECTOR (7 downto 0);
        i_out: out STD_LOGIC_VECTOR (7 downto 0);
        i_adder: out STD_LOGIC_VECTOR (7 downto 0));
end component i;

component a is
  Port (clk_a,rst_a,ld_a: in STD_LOGIC;
        a_in: in STD_LOGIC_VECTOR (7 downto 0);
        a_out: out STD_LOGIC_VECTOR (7 downto 0));
end component a;


component FSM is
  Port (clk_FSM, rst_FSM: in STD_LOGIC;
        i_lt32: in STD_LOGIC_VECTOR (7 downto 0);
        avg_clr, avg_ld: out STD_Logic;
        i_clr, i_ld: out STD_Logic;
        sum_clr, sum_ld: out STD_Logic;
        a_clr, a_ld: out STD_Logic);
end component FSM;

--i output for FSM and hadder
signal iout_temp: STD_LOGIC_VECTOR (7 downto 0);
signal twenty_five: STD_LOGIC_VECTOR (7 downto 0):= "00011001";
signal i_carry: STD_Logic;
signal i_sum: STD_LOGIC_VECTOR(7 downto 0);
--FSM output
signal avgclr_temp, avgld_temp, iclr_temp, ild_temp, sumclr_temp, sumld_temp, aclr_temp, ald_temp: STD_Logic;
-- a
signal ain_temp: STD_LOGIC_VECTOR (7 downto 0);
signal aout_temp: STD_LOGIC_VECTOR (7 downto 0);

--sum 
signal sumhadder, sumout: STD_LOGIC_VECTOR (8 downto 0);
signal sum_carry: STD_Logic;

--average
signal avgout: STD_LOGIC_VECTOR (8 downto 0);

begin

i_block: i port map(clk_i => clk, rst_i => iclr_temp, ld_i => ild_temp, i_in => iout_temp, i_out => iout_temp, i_adder => i_sum);

FSM_Block: FSM port map(clk_FSM => clk, rst_FSM => rst, i_lt32 => iout_temp, avg_clr => avgclr_temp, avg_ld => avgld_temp, i_clr => iclr_temp, i_ld => ild_temp, sum_clr => sumclr_temp, sum_ld =>  sumld_temp, a_clr => aclr_temp, a_ld => ald_temp);

BROM: blk_mem_gen_0 port map(clka => clk, addra => i_sum, douta => ain_temp);

a_block: a port map(clk_a => clk,rst_a => aclr_temp, ld_a => ald_temp, a_in => ain_temp, a_out => aout_temp);

sum_block: sum port map(clk_sum => clk, rst_sum => sumclr_temp, ld_sum => sumld_temp, sum_in => sumhadder, sum_out => sumout);

sum_hadder: hadder port map(a => aout_temp, b => sumout, sum => sumhadder, cout => sum_carry);

avg_block: average port map(clk_avg => clk, rst_avg => avgclr_temp, ld_avg => avgld_temp, avg_in => sumout, avg_out => avgout);


end Behavioral;