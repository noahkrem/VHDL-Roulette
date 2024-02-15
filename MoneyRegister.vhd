LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
 
LIBRARY WORK;
USE WORK.ALL;

ENTITY MoneyRegister IS PORT(
    d   : IN unsigned(11 DOWNTO 0);
    clr : IN STD_LOGIC; -- async. clear.
    clk : IN STD_LOGIC; -- clock.
    q   : OUT unsigned(11 DOWNTO 0) -- output
);
END MoneyRegister;

ARCHITECTURE behavior OF MoneyRegister IS

BEGIN
    process(clk, clr)
    begin
        if clr = '0' then
            q <= "000000100000";
        elsif rising_edge(clk) then
            q <= d;
        end if;
    end process;
END behavior;