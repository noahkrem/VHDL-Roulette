LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;

-----------------------------------------------------
--
--  This block will contain a decoder to decode a 4-bit number
--  to a 7-bit vector suitable to drive a HEX dispaly
--  Many examples could be find on the web (Generic block)
--
--  It is a purely combinational block and
--  is similar to a block you designed in Lab 1.
--
--------------------------------------------------------

ENTITY Digit7Seg IS
	PORT(
          digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
          seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)  -- one per segment
	);
END;


ARCHITECTURE behavioral OF Digit7Seg IS

	signal output	: STD_LOGIC_VECTOR(6 downto 0);

BEGIN

-- Your code goes here

	--FSM combinational logic:
	process (digit)
	begin
	
		-- NOTE: Outputs might be inverted
		-- NOTE: Digits might have to be actual numbers
		case digit is
			when "0000" =>		-- 0 -> 0
				output <= "1000000";
			when "0001" =>		-- 1 -> 1
				output <= "1111001";
			when "0010" =>		-- 2 -> 2
				output <= "0100100"; 
			when "0011" =>		-- 3 -> 3
				output <= "0110000"; 
			when "0100" =>		-- 4 -> 4
				output <= "0011001";
			when "0101" =>		-- 5 -> 5
				output <= "0010010"; 
			when "0110" =>		-- 6 -> 6
				output <= "0000010"; 
			when "0111" => 	-- 7 -> 7
				output <= "1111000";
			when "1000" =>		-- 8 -> 8
				output <= "0000000";
			when "1001" =>		-- 9 -> 9
				output <= "0010000"; 
			when "1010" =>		-- 10 -> A
				output <= "0001000";
			when "1011" =>		-- 11 -> b
				output <= "0000011";
			when "1100" =>		-- 12 -> C
				output <= "0100111"; 
			when "1101" =>		-- 13 -> d
				output <= "0100001"; 
			when "1110" => 	-- 14 -> E
				output <= "0000110"; 
			when "1111" => 	-- 15 -> F
				output <= "0001110"; 
			when others =>
				output <= "1000000"; 
		end case;
		
	end process;
	
	seg7 <= output;

END;