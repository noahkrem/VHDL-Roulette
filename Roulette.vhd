LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

-- TOP LEVEL ENTITY

ENTITY Roulette IS
	PORT(   CLOCK_50 : IN STD_LOGIC; -- the fast clock for spinning wheel
		KEY : IN STD_LOGIC_VECTOR(3 downto 0);  -- includes slow_clock and reset
		SW : IN STD_LOGIC_VECTOR(17 downto 0);
		LEDG : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);  -- ledg
		HEX7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 7
		HEX6 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 6
		HEX5 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 5
		HEX4 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 4
		HEX3 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 3
		HEX2 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 2
		HEX1 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0);  -- digit 1
		HEX0 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0)   -- digit 0
	);
END Roulette;


ARCHITECTURE structural OF Roulette IS

   COMPONENT WinDetector IS
	  PORT(spin_result_latched : in unsigned(5 downto 0);
             bet1_value : in unsigned(5 downto 0);
             bet2_colour : in std_logic;
             bet3_dozen : in unsigned(1 downto 0);
             bet1_wins : out std_logic;
             bet2_wins : out std_logic;
             bet3_wins : out std_logic);
   END COMPONENT;
	
	COMPONENT New_Balance IS
		PORT(money : in unsigned(11 downto 0);  -- Current balance before this spin
				 value1 : in unsigned(2 downto 0);  -- Value of bet 1
				 value2 : in unsigned(2 downto 0);  -- Value of bet 2
				 value3 : in unsigned(2 downto 0);  -- Value of bet 3
				 bet1_wins : in std_logic;  -- True if bet 1 is a winner
				 bet2_wins : in std_logic;  -- True if bet 2 is a winner
				 bet3_wins : in std_logic;  -- True if bet 3 is a winner
				 new_money : out unsigned(11 downto 0));  -- balance after adding winning
																		-- bets and subtracting losing bets
	END COMPONENT;
	
	COMPONENT Digit7Seg IS
		PORT(digit : IN  UNSIGNED(3 DOWNTO 0);  -- number 0 to 0xF
				seg7 : OUT STD_LOGIC_VECTOR(6 DOWNTO 0) ); -- one per segment 										
	END COMPONENT;
	
	COMPONENT SpinWheel IS
		PORT(fast_clock : IN  STD_LOGIC;  -- This will be a 27 Mhz Clock
				resetb : IN  STD_LOGIC;      -- asynchronous reset
				spin_result  : OUT UNSIGNED(5 downto 0));  -- current value of the wheel
	END COMPONENT;
	
	COMPONENT Debouncer IS
		PORT(clk     	: IN  STD_LOGIC;  --input clock
				button  	: IN  STD_LOGIC;  --input signal to be debounced
				result  	: OUT STD_LOGIC); --debounced signal
	END COMPONENT;
	
	
	
	------ LOCAL SIGNALS ------
		
	signal slow_clock					: std_logic;
	signal resetb						: std_logic;
	signal spin_result_latched		: unsigned(5 downto 0)	:= "000000";
	signal spin_result_extended	: unsigned(7 downto 0)	:= "00000000" or spin_result_latched;
	signal bet1_value					: unsigned(5 downto 0)	:= "000000";
	signal bet2_colour				: std_logic					:= '0';
	signal bet3_dozen					: unsigned(1 downto 0)	:= "00";
	signal bet1_wins					: std_logic					:= '0';
	signal bet2_wins					: std_logic					:= '0';
	signal bet3_wins					: std_logic					:= '0';
	signal money						: unsigned(11 downto 0) := "000000100000";
	signal bet1_amount				: unsigned(2 downto 0)	:= "000";
	signal bet2_amount				: unsigned(2 downto 0)	:= "000";
	signal bet3_amount				: unsigned(2 downto 0)	:= "000";
	signal new_money					: unsigned(11 downto 0)	:= "000000000000";
	signal spin_result				: unsigned(5 downto 0)	:= "000000";
	
	
	------ BINARY TO DECIMAL ------
	
	signal money_dig0	: unsigned(3 downto 0)	:= "0000";
	signal money_dig1	: unsigned(3 downto 0)	:= "0000";
	signal money_dig2	: unsigned(3 downto 0)	:= "0000";
	signal money_dig3	: unsigned(3 downto 0)	:= "0000";
	
	signal spin_dig0	: unsigned(3 downto 0)	:= "0000";
	signal spin_dig1	: unsigned(3 downto 0)	:= "0000";
	signal spin_dig2	: unsigned(3 downto 0)	:= "0000";
	signal spin_dig3	: unsigned(3 downto 0)	:= "0000";
	
	

BEGIN

	------ INITIALIZATION ------
	
	HEX5 <= "1111111";
	HEX4 <= "1111111";
	
	LEDG(0) <= bet1_wins;
	LEDG(1) <= bet2_wins;
	LEDG(2) <= bet3_wins;



	------ PORT MAPS ------
	
	wd		: WinDetector port map (
		spin_result_latched	=>	spin_result_latched,
		bet1_value				=>	bet1_value,
		bet2_colour				=>	bet2_colour,
		bet3_dozen 				=>	bet3_dozen,
		bet1_wins 				=> bet1_wins,
		bet2_wins				=>	bet2_wins,
		bet3_wins 				=> bet3_wins );
		
	
	nb		: New_Balance port map (
		money 		=> money,
		value1 		=>	bet1_amount,
		value2		=>	bet2_amount,
		value3 		=>	bet3_amount,
		bet1_wins 	=>	bet1_wins,
		bet2_wins 	=>	bet2_wins,
		bet3_wins 	=> bet3_wins,
		new_money	=> new_money );
		
	ds0 	: Digit7Seg port map (
		digit	=> money_dig0,
		seg7  => HEX0 );
	
	ds1	: Digit7Seg port map (
		digit =>	money_dig1,
		seg7	=> HEX1 );
		
	ds2	: Digit7Seg port map (
		digit => money_dig2,
		seg7	=> HEX2 );
		
	ds3	: Digit7Seg port map (
		digit => money_dig3,
		seg7	=> HEX3 );
		
	ds6	: Digit7Seg port map (
		digit => spin_dig0,
		seg7	=> HEX6 );
		
	ds7	: Digit7Seg port map (
		digit => spin_dig1,
		seg7	=> HEX7 );
		
	sp 	: SpinWheel port map (
		fast_clock		=> CLOCK_50,
		resetb			=> KEY(1),
		spin_result		=> spin_result );
		
	db	: Debouncer port map (
		clk			=> CLOCK_50,
		button		=> KEY(0),
		result		=> slow_clock );
		
	Reg2	: Register12Bit port map (
		d(5 downto 0) 	=> spin_result,
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(5 downto 0)	=> spin_result_latched );
		
	Reg3	: Register12Bit port map (
		d(5 downto 0)	=> unsigned(SW(8 downto 3)),
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(5 downto 0)	=> bet1_value );
		
	Reg4	: Register12Bit port map (
		d(0)	=> SW(12),
		clr	=> KEY(1),
		clk	=> slow_clock,
		q(0)	=> bet2_colour );
		
	Reg5	: Register12Bit port map (
		d(1 downto 0)	=> unsigned(SW(17 downto 16)),
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(1 downto 0)	=> bet3_dozen );
	
	Reg7	: Register12Bit port map (
		d(2 downto 0) 	=> unsigned(SW(2 downto 0)),
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(2 downto 0)	=> bet1_amount );
	
	Reg8	: Register12Bit port map (
		d(2 downto 0) 	=> unsigned(SW(11 downto 9)),
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(2 downto 0)	=> bet2_amount );

	Reg9	: Register12Bit port map (
		d(2 downto 0) 	=> unsigned(SW(15 downto 13)),
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(2 downto 0)	=> bet3_amount );
		
	Reg10	: MoneyRegister port map (
		d(11 downto 0)	=> new_money,
		clr				=> KEY(1),
		clk				=> slow_clock,
		q(11 downto 0)	=> money );
		
	b2d1	: BinaryToDecimal port map (
		bin	=> new_money,
		dig0	=> money_dig0,
		dig1  => money_dig1,
		dig2 	=> money_dig2,
		dig3	=> money_dig3 );
		
	b2d2	: BinaryToDecimal port map (
		bin	=> ("000000" & spin_result_latched),
		dig0	=> spin_dig0,
		dig1	=> spin_dig1,
		dig2	=> spin_dig2,
		dig3	=> spin_dig3 );
	
	
 
 
END;