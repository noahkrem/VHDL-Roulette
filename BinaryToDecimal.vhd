LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

LIBRARY WORK;
USE WORK.ALL;


ENTITY BinaryToDecimal IS
	PORT(	bin	: IN 	UNSIGNED(11 downto 0);
			dig0	: OUT UNSIGNED(3 downto 0);
			dig1  : OUT UNSIGNED(3 downto 0);
			dig2 	: OUT UNSIGNED(3 downto 0);
			dig3	: OUT UNSIGNED(3 downto 0) );
END BinaryToDecimal;


ARCHITECTURE structural OF BinaryToDecimal IS
	
	

BEGIN

	PROCESS (bin)

	VARIABLE temp		: unsigned(11 downto 0);
	VARIABLE tempInt	: integer range 0 to 4095;
	VARIABLE tempOp	: unsigned(11 downto 0);
	VARIABLE op0		: unsigned(3 downto 0);
	VARIABLE op1		: unsigned(3 downto 0);
	VARIABLE op2		: unsigned(3 downto 0);
	VARIABLE op3		: unsigned(3 downto 0);
	
	BEGIN

	------ LOGIC ------
	
		temp		:= bin;
		tempOp	:= temp;
		tempInt 	:= to_integer(bin);

		tempOp := (temp mod 10);
		op0 := tempOp(3 downto 0);
		tempInt := tempInt - to_integer(op0);
		tempInt := tempInt / 10;
		temp := to_unsigned(tempInt, temp'length);
		
		tempOp := (temp mod 10);
		op1 := tempOp(3 downto 0);
		tempInt := tempInt - to_integer(op1);
		tempInt := tempInt / 10;
		temp := to_unsigned(tempInt, temp'length);
		
		tempOp := (temp mod 10);
		op2 := tempOp(3 downto 0);
		tempInt := tempInt - to_integer(op2);
		tempInt := tempInt / 10;
		temp := to_unsigned(tempInt, temp'length);
		
		tempOp := (temp mod 10);
		op3 := tempOp(3 downto 0);
		
		dig0 <= unsigned(op0);
		dig1 <= unsigned(op1);
		dig2 <= unsigned(op2);
		dig3 <= unsigned(op3);
		
	END PROCESS;
	
	
	------ OUTPUTS ------

	

END structural;