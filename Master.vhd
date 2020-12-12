----------------------------------------------------------------------------------
-- Company: ECE 524
-- Engineer: Jason Nakhla & Jonathan Roa
-- 
-- Create Date: 12/03/2020 10:06:25 PM
-- Design Name: 
-- Module Name: Master - Behavioral
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
USE ieee.std_logic_unsigned.all;

entity Master is
--  GENERIC(
--    input_clk : INTEGER := 50000000; 
--    --input clock speed Hz
--    bus_clk   : INTEGER := 400000);   
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
end Master;

architecture Behavioral of Master is

TYPE i2c_states IS (ready, start, command, slv_ack1, wr, rd, slv_ack2, mstr_ack, stop);
signal state: i2c_states;
signal counter: integer range 0 to 7;
signal scl_clk: std_logic;                                --scl clock. Starts at low before sda
signal scl_en: std_logic:= '0';                           --scl cloock enable
signal sda_int: std_logic:= '1';                          --sda line which is always high first before the scl goes high
signal sda_en: std_logic;                                 --sda line anble
signal addr_bit: std_logic_vector(7 downto 0);            --address frame
signal r_w: std_logic;                                    --read or write bit
signal data_w: std_logic_vector(7 downto 0);              --data to be sent
signal data_r: std_logic_vector(7 downto 0);              --data to be received

constant input_clk : INTEGER := 50000000;                 --input clock speed Hz
constant bus_clk   : INTEGER := 400000;                   --speed the i2c bus (scl) will run at in Hz
constant div: integer:= (input_clk/bus_clk)/4;            -- num of clks in 1/4 cycle of the scl 

signal stretch: STD_LOGIC := '0';                         --identifies if slave is stretching scl
signal data_clk, data_clk_prev: std_logic;                -- sda data clock

begin

SDA_SCL: process (clk,rst)                                  --clock generator
    variable count: integer range 0 to div*4;               --timing for generator
begin
    if (rst = '1') then
        stretch <= '0';
        count:= 0;
    elsif (rising_edge(clk)) then
        data_clk_prev <= data_clk;                           --store previous clock value
        if(count = div*4-1) then                             --cycle ended
            count:=0;                                        --reset  
        elsif (stretch = '0') then
            count:= count + 1;
        end if;
    case count is
        when 0 to div-1 =>                                   --first 1/4 clocking cycle
            scl_clk <= '0';
            data_clk <= '0';
        when div to div*2-1 =>                               --second 1/4 clocking cycle
            scl_clk <= '0';
            data_clk <= '1';
        when div*2 to div*3-1 =>                             --third 1/4 clocking cycle
            scl_clk <= '1';                                  --scl put to low
            if (scl = '0') then
                stretch <= '1';
            else
                stretch <= '0';
            end if;
            data_clk <= '1';
        when others =>                                       --final 1/4 clocking cycle           
           scl_clk <= '1';
           data_clk <= '0';
        end case;
    end if;
end process;

states: process(clk,rst)                                     --FSM Design
begin
    if(rst = '1') then                                       --reset
        state <= ready;                                      --begin at state 'ready'
        busy <= '1';                                         --busy atm
        scl_en <= '0';                                       --resets scl to 0
        sda_int <= '1';                                      --resets sda to 1
        ack_error <= '0';                                    --acknowledge bit is 0
        counter <= 7;                                        --resets counter
        data_rd <= (others => '0');                          --resets data read signal
    elsif(rising_edge(clk)) then
        if (data_clk = '1' and data_clk_prev = '0') then     --rising edge data cock
            case state is
            
                when ready =>                                -- first state
                    if (ena = '1') then                      --enable signal goes high
                        busy <= '1';                         -- communication is busy atm
                        addr_bit <= addr & rw;               --input the slave address and the read or write bit
                        data_w <= data_wr;                   --input fata to write
                        state <= start;                      --go to start state
                    else
                        busy <= '0';                         --no longer busy
                        state <= ready;                      --stay in ready until enable is 1
                    end if;
                    
                when start =>                                -- currentstate in start
                    busy <= '1';                             -- busy atm
                    sda_int <= addr_bit(counter);            --load the address/r/w bits into thesda line
                    state <= command;                        --go to the next state 'command'
              
                when command =>
                    if (counter = 0) then                    --loops through the 8 bits for tha address and r/w bit
                        sda_int <= '1';                      --set teh sda line to a high voltage
                        counter <= 7;                        --reset the bytes
                        state <= slv_ack1;                   --move to the next state where the slave acknowledges itself and wheter it is write or read
                    else
                        counter <= counter - 1;              --count down to go througgh all the bits
                        sda_int <= addr_bit(counter-1);      --have the sda line read all the bits
                        state <= command;                    --go to the current state to see if all the bits have beem read
                    end if;
            
                when slv_ack1 =>        
                    if(addr_bit(0) = '0') then              --indicates write to slave
                        sda_int <= data_w(counter);         --write first data bit
                        state <= wr;                        --branch to write state
                    else                                    -- addr_bit(0) = '1'. indicates read from slave
                        sda_int <= '1';                     --release sda from data
                        state <= rd;                        --branch to read state
                    end if;                  
               
                when wr =>                                  --write branch
                    busy <= '1';                            --busy atm
                        if (counter = 0) THEN               --writes all 8 bits
                          sda_int <= '1';                   --release sda for slave acknowledge    
                          counter <= 7;                     --reset vit counter to "write"
                          state <= slv_ack2;                -- go to next state where slave acknowldges
                        else                                --if all bit have not been written     
                          counter <= counter - 1;           --count down by 1 bit to write     
                          sda_int <= data_w(counter-1);     --input data to the sda
                          state <= wr;                      --loop back to state 'wr' until all bits written
                        end if;
               
                when rd =>                                  --read branch
                    busy <= '1';                            --busy atm
                        if(counter = 0) then                --all 8 bits written
                          if(ena = '1' and addr_bit = addr & rw) then -- if enable line is 1 and the address and r/w bits hav ebeen read
                            sda_int <= '0';                 --byte has been recieved, acknowledge   
                          else                       
                            sda_int <= '1';                 --byte has not been recieved, no acknowledge 
                          end if;
                          counter <= 7;                     --reset bit counter to be read  
                          data_rd <= data_r;                --output received data
                          state <= mstr_ack;                --go to next atate that acknowledges the I2C communication
                        else                                --all bytes have not been read 
                          counter <= counter - 1;           --cycle throiugh all bits
                          state <= rd;                      --loop back to the same state
                      end if;           
               
                when slv_ack2 =>                            --from write branch 
                    if (ena = '1') then                     --enable line is 1             
                      busy <= '0';                          --continue is accepted           
                      addr_bit <= addr & rw;                --slave address and r/w bit sent back        
                      data_w <= data_wr;                    --data to write is sent       
                      if(addr_bit = addr & rw) then         --if correct address and r/w bit is sent
                        sda_int <= data_wr(counter);        --write first bit of data
                        state <= wr;                        --go back to write branch
                      else                                  --if wrong slave address
                        state <= start;                     --go ack to fisrt state
                      end if;
                    else                                    --enable line is 0
                      state <= stop;                        --go to final state
                    end if;
               
                when mstr_ack =>                            --from read branch
                    if(ena = '1') THEN                      --enable line is 1
                      busy <= '0';                          --continue is accepted and data is received
                      addr_bit <= addr & rw;                --slave address and r/w bit received 
                      data_w <= data_wr;                    --data to write is requested
                      if(addr_bit = addr & rw) then         --if right s;ave address  
                        sda_int <= '1';                     --release sda fromincoming data
                        state <= rd;                        --go back to read state
                      else                                  --wrong slave address
                        state <= start;                     --go back to first state
                      end if;    
                    else                                    --enable line is 0
                      state <= stop;                        --go to final state    
                    end if;
               
                when stop =>                                --at final state
                    busy <= '0';                            --not busy anymote
                    state <= ready;                         --go to first state
            end case;
       
        elsif (data_clk = '0' and data_clk_prev = '1') then --falling edge for data clock
            case state is
            
              when start =>                  
                if(scl_en = '0') then                       --scl clock enable line is 0  
                  scl_en <= '1';                            --make it high voltage   
                  ack_error <= '0';                         --reset aknowledge error output
                end if;
                
              when slv_ack1 =>                     
                if(sda /= '0' or ack_error = '1') then      --no acknowledge
                  ack_error <= '1';                         --set the error output
                end if;
                
              when rd =>                       
                data_r(counter) <= sda;                     --receive current slave data bit
                      
              when slv_ack2 =>                    
                if(sda /= '0' or ack_error = '1') then      --no acknowledge
                  ack_error <= '1';                         --sett error output
                end if;
                
              when stop =>
                scl_en <= '0';                              --disable scl clock 
              when others =>
                NULL;
        end case;
        end if;    
    end if;
end process;

with state select
    sda_en <= data_clk_prev when start,                     --generate start condition
                 not data_clk_prev when stop,               --generate stop condition
                 sda_int when others;                       --set to internal sda signal    
      
     scl <= '0' when (scl_en = '1' and scl_clk = '0') else 'Z';
     sda <= '0' when sda_en = '0' else 'Z';

end Behavioral;
