LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

--------------------------------------------------------------
--
-- This block is purely
-- combinational and calculates the
-- new balance after adding winning bets and subtracting losing bets.
--
---------------------------------------------------------------


ENTITY New_Balance IS
  PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
       value1 : in unsigned(2 downto 0);  -- Value of bet 1
       value2 : in unsigned(2 downto 0);  -- Value of bet 2
       value3 : in unsigned(2 downto 0);  -- Value of bet 3
       bet1_wins : in std_logic;  -- True if bet 1 is a winner
       bet2_wins : in std_logic;  -- True if bet 2 is a winner
       bet3_wins : in std_logic;  -- True if bet 3 is a winner
       new_money : out unsigned(11 downto 0));  -- balance after adding winning
                                                -- bets and subtracting losing bets
END New_Balance;


ARCHITECTURE behavioural OF New_Balance IS

BEGIN

	process (bet1_wins, bet2_wins, bet3_wins, value1, value2, value3)
	variable balance  : unsigned(11 downto 0);
	begin
	
		balance := money;
	
		if (bet1_wins = '1') then
			-- Multiplication must use the right number of bits
			balance := balance + to_unsigned(35, (balance'length - value1'length))*value1;
		else
			balance := balance - value1;
		end if;
		
		if (bet2_wins = '1') then
			balance := balance + value2;
		else
			balance := balance - value2;
		end if;
	
		if (bet3_wins = '1') then
			-- Multiplication must use the right number of bits
			balance := balance + to_unsigned(2, (balance'length - value3'length))*value3;
		else
			balance := balance - value3;
		end if;
		
	
	new_money <= balance;
	
	end process;
  
END;