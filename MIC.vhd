library ieee;
use ieee.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity MIC is

generic(
zero : std_logic_vector(15 downto 0) := "0000000000000000";
um : std_logic_vector(15 downto 0) := "0000000000000001";
menosum : std_logic_vector(15 downto 0) := "1111111111111111";
mascara_a : std_logic_vector(15 downto 0) := "0000111111111111";
mascara_b : std_logic_vector(15 downto 0) := "0000000011111111");

port
(
-- clock e reset 

clk : in std_logic;
reset : in std_logic;

--sinais de controle (barramentos A e B)

sinal_a : in std_logic_vector(3 downto 0);
sinal_b : in std_logic_vector(3 downto 0);

--sinais Z e N

sinal_z : out std_logic;
sinal_n : out std_logic;

--sinais de controle (MAR,MBR)

sinal_mbr : in std_logic;
sinal_mar : in std_logic;
sinal_mbr_out : out std_logic_vector(15 downto 0);
sinal_mar_out : out std_logic_vector(11 downto 0);
 

--sinais de controle (multiplexador,ula,deslocador)

sinal_amux : in std_logic;
sinal_ula : in std_logic_vector(1 downto 0);
sinal_sh : in std_logic_vector(1 downto 0); 

--sinais de controle dos registradores

sinal_enc : in std_logic;
sinal_c : in std_logic_vector(3 downto 0);

--sinais de escrita e leitura de memoria 

rd_in : in std_logic;
wr_in : in std_logic;
rd_out : out std_logic;
wr_out : out std_logic;

mem_to_mbr : in std_logic;
data_in : in std_logic_vector(15 downto 0);
sinal_c_out : out std_logic_vector(15 downto 0)
);

end entity MIC;

architecture behavior of MIC is

component ULA is 
port(
ULA_Ain : in std_logic_vector(15 downto 0);
ULA_Bin : in std_logic_vector(15 downto 0);
ULA_Cout : buffer std_logic_vector(15 downto 0);
Sel : in std_logic_vector(1 downto 0);
Z : out std_logic;
N : out std_logic
);
end component;

component SHIFTER is
port(
shifter_in : in std_logic_vector(15 downto 0);
shifter_out : out std_logic_vector(15 downto 0);
sh : in std_logic_vector(1 downto 0)
);
end component;


type regbank is array (0 to 15) of std_logic_vector(15 downto 0);--typo banco de registradores


--banco de registradores

signal registradores : regbank;

--barramentos

signal barramento_A : std_logic_vector(15 downto 0);
signal barramento_B : std_logic_vector(15 downto 0);
signal barramento_c : std_logic_vector(15 downto 0);

--fio entre componentes

signal ula_to_shifter : std_logic_vector(15 downto 0);

--Registradores de read e write

signal reg_rd : std_logic;
signal reg_wr : std_logic;

--saida multplexador 

signal mult_out : std_logic_vector(15 downto 0);

--MAR E MBR

signal MAR : std_logic_vector(11 downto 0);
signal MBR : std_logic_vector(15 downto 0);



begin

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--COMPONENTES-------------------------------------------------------------------------------------------------------------------------------------------------------	

deslocador : SHIFTER port map(ula_to_shifter,barramento_c,sinal_sh);

alu : ULA port map(mult_out,barramento_B,ula_to_shifter,sinal_ula,sinal_z,sinal_n);

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--MAR E MBR---------------------------------------------------------------------------------------------------------------------------------------------------------

sinal_mbr_out <= MBR;
sinal_mar_out <= MAR;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--RD E WR-----------------------------------------------------------------------------------------------------------------------------------------------------------

rd_out <= reg_rd;
wr_out <= reg_wr;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
-- BARRAMENTOS A e B------------------------------------------------------------------------------------------------------------------------------------------------

barramento_A <= registradores(conv_integer(sinal_a(3 downto 0)));
barramento_B <= registradores(conv_integer(sinal_b(3 downto 0)));

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--MULTIPLEXADOR-----------------------------------------------------------------------------------------------------------------------------------------------------

with sinal_amux select
mult_out <= barramento_A when'0',
            MBR when '1',
			   mult_out when others;
			
--------------------------------------------------------------------------------------------------------------------------------------------------------------------			
--MBR---------------------------------------------------------------------------------------------------------------------------------------------------------------	

process(clk,sinal_mbr,mem_to_mbr)

begin

if(clk'event and clk = '1'and sinal_mbr = '1') then

if(mem_to_mbr='1') then

MBR <= data_in;

else 

MBR <= barramento_C;

end if;

else 

MBR <= MBR;

end if;

end process;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------			
--MAR---------------------------------------------------------------------------------------------------------------------------------------------------------------			

process(clk,sinal_mar)

begin

if(clk'event and clk = '1'and sinal_mar = '1') then

MAR <= barramento_b(11 downto 0);

else 

MAR <= MAR;

end if;

end process;
			
--------------------------------------------------------------------------------------------------------------------------------------------------------------------			
--ESCRITA NOS REGISTRADORES------------------------------------------------------------------------------------------------------------------------------------------------------			
			
process(clk,sinal_enc)

begin 

if(clk'event and clk ='1'and sinal_enc = '1') then

if(reset = '1') then

registradores(0) <= zero;--  PC
registradores(1) <= zero;--  AC
registradores(2) <= zero;--  SP
registradores(3) <= zero;--  IR
registradores(4) <= zero;--  TIR
registradores(5) <= zero;--  0
registradores(6) <= um;--  1
registradores(7) <= menosum;-- -1
registradores(8) <= mascara_a;--  AMASK
registradores(9) <= mascara_b;--  BMASK
registradores(10) <= zero;-- A
registradores(11) <= zero;-- B
registradores(12) <= zero;-- C
registradores(13) <= zero;-- D
registradores(14) <= zero;-- E
registradores(15) <= zero;-- F

end if;

registradores(conv_integer(sinal_c(3 downto 0))) <= barramento_c;

end if;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------	
--CONSTANTES--------------------------------------------------------------------------------------------------------------------------------------------------------

registradores(5) <= zero;--  0
registradores(6) <= um;--  1
registradores(7) <= menosum;-- -1
registradores(8) <= mascara_a;--  AMASK
registradores(9) <= mascara_b;--  BMASK

end process;			
			
--------------------------------------------------------------------------------------------------------------------------------------------------------------------			
--READ AND WRITE----------------------------------------------------------------------------------------------------------------------------------------------------

process(clk)

begin

if(clk'event and clk = '1') then

reg_rd <= rd_in;
reg_wr <= wr_in;

else 

reg_rd <= reg_rd;
reg_wr <= reg_wr;

end if;

end process;
----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
end behavior;