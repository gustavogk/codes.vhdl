library ieee;
use ieee.std_logic_1164.all;

entity ULA is
  port (
      ULA_Ain : in std_logic_vector(15 downto 0 );
      ULA_Bin : in std_logic_vector(15 downto 0 );
      ULA_Cout : out std_logic_vector(15 downto 0 );
      Sel : in std_logic_vector(1 downto 0);
      Z : out bit;
      n : out bit
  ) ;
end ULA;

architecture behavior of ULA is

    signal

begin

    ULA_Cout <= ULA_Ain + ULA_Bin when (Sel = "00") else
                ULA_Ain and UlA_bin when (Sel = "01")else
                ULA_Ain when (Sel = "10")else
                not ULA_Ain when (Sel = "11");

end behavior ;