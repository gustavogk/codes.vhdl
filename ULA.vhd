library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity ULA is
port
(
ULA_Ain : in std_logic_vector(15 downto 0 );
ULA_Bin : in std_logic_vector(15 downto 0 );
ULA_Cout : out std_logic_vector(15 downto 0 );
Sel : in std_logic_vector(1 downto 0);
Z : out bit;
n : out bit
);

architecture behavior of ULA is
begin

ULA_Cout <= ULA_Ain + ULA_Bin when (Sel = "00") else
            ULA_Ain and UlA_bin when (Sel = "01")else
            ULA_Ain when (Sel = "10")else
            not ULA_Ain when (Sel = "11"); 
				
				if(ULA_Cout(15)='1') then n <= '1'else n <= '0'
				if(ULA_Cout = "0000000000000000" then z <= '1'else z <= '0'
				
end behavior;