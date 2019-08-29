library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ULA is
port
(
ULA_Ain : in std_logic_vector(15 downto 0 );
ULA_Bin : in std_logic_vector(15 downto 0 );
ULA_Cout : buffer std_logic_vector(15 downto 0 );
Sel : in std_logic_vector(1 downto 0);
Z : out std_logic;
n : out std_logic
);

end entity ULA;

architecture behavior of ULA is
begin

with Sel select
ULA_Cout <= ULA_Ain + ULA_Bin when "00",
            ULA_Ain and ULA_Bin when "01",
            ULA_Ain when "10",
            not ULA_Ain when others;
				
with ULA_Cout select
z <= '1' when "0000000000000000",
     '0' when others;
	  
with ULA_Cout(15) select
n <= '1' when '1',
     '0' when others;

end behavior;