library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity SHIFTER is
generic (
REGSIZE : integer := 16
);

port(
c_in : in std_logic_vector(REGSIZE-1 downto 0);
c_out : out std_logic_vector(REGSIZE-1 downto 0);
sh : in std_logic_vector(1 downto 0)
);
end entity SHIFTER;

architecture behavior of SHIFTER is

begin

with sh select

c_out <= c_in(14 downto 0) & '0' when "01",
         '0'& c_in(15 downto 1) when "10" ,
			c_in when others;

end behavior;