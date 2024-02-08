LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
--  This is a skeleton you can use for the win subblock.  This block determines
--  whether each of the 3 bets is a winner.  As described in the lab
--  handout, the first bet is a "straight-up" bet, the second bet is 
--  a colour bet, and the third bet is a "dozen" bet.
--
--  This should be a purely combinational block.  There is no clock.
--
---------------------------------------------------------------

ENTITY WinDetector IS
	PORT(spin_result_latched : in unsigned(5 downto 0);  -- result of the spin (the winning number)
             bet1_value : in unsigned(5 downto 0); -- value for bet 1
             bet2_colour : in std_logic;  -- colour for bet 2
             bet3_dozen : in unsigned(1 downto 0);  -- dozen for bet 3
             bet1_wins : out std_logic;  -- whether bet 1 is a winner
             bet2_wins : out std_logic;  -- whether bet 2 is a winner
             bet3_wins : out std_logic); -- whether bet 3 is a winner
END WinDetector;


ARCHITECTURE behavioural OF WinDetector IS
BEGIN

	process (spin_result_latched, bet1_value, bet2_colour, bet3_dozen)
	begin
		
		-- Check if bet1 wins
		if (spin_result_latched = bet1_value) then
			bet1_wins <= '1';
		else
			bet1_wins <= '0';
		end if;
		
		-- [1,10] or [19, 28] red = odd, black = even
		if ( ((spin_result_latched >= 1) and (spin_result_latched <= 10))  or ((spin_result_latched >= 19) and (spin_result_latched <= 28)) ) then
			-- Check if bet2 wins
			if ( ((spin_result_latched mod 2) = 0) and (bet2_colour = '0') ) then
				bet2_wins <= '1';
			elsif ( ((spin_result_latched mod 2) = 1) and (bet2_colour = '1') ) then
				bet2_wins <= '1';
			else
				bet2_wins <= '0';
			end if;
			
		-- [11, 18] or [29, 36] red = even, black = odd
		elsif ( ((spin_result_latched >= 11) and (spin_result_latched <= 18))  or ((spin_result_latched >= 29) and (spin_result_latched <= 36)) ) then
			if ( ((spin_result_latched mod 2) = 0) and (bet2_colour = '1') ) then
				bet2_wins <= '1';
			elsif ( ((spin_result_latched mod 2) = 1) and (bet2_colour = '0') ) then
				bet2_wins <= '1';
			else 
				bet2_wins <= '0';
			end if;
			
		end if;
		
		-- [1, 12]: bet3_dozen=00
		if ( (spin_result_latched >= 1) and (spin_result_latched <= 12) ) then
			-- Check if bet3 wins
			if (bet3_dozen = "00") then
				bet3_wins <= '1';
			else
				bet3_wins <= '0';
			end if;
			
		-- [13, 24]: bet3_dozen=01
		elsif ( (spin_result_latched >= 13) and (spin_result_latched <= 24) ) then
			-- Check if bet3 wins
			if (bet3_dozen = "01") then 
				bet3_wins <= '1';
			else 
				bet3_wins <= '0';
			end if;
		
		-- [13, 24]: bet3_dozen=10
		elsif ( (spin_result_latched >= 25) and (spin_result_latched <= 36) ) then
			-- Check if bet3 wins
			if (bet3_dozen = "10") then 
				bet3_wins <= '1';
			else 
				bet3_wins <= '0';
			end if;
			
		-- [0]: bet2 and bet3 both lose
		else 
			bet3_wins <= '0';
			bet2_wins <= '0';
		end if;
		
	end process;

END;