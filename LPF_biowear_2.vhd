--####################################################################

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.std_logic_arith.all;
--USE work.comp_somadores.all;

ENTITY SUM_GEN IS
GENERIC (N: INTEGER:=32; K : integer  :=2);
PORT ( A,B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Y   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
      );
END SUM_GEN;
ARCHITECTURE COMP OF SUM_GEN IS
BEGIN
Y<= A + B;

END COMP;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.std_logic_arith.all;
--USE work.comp_somadores.all;

ENTITY SUM_GEN_2 IS
GENERIC (N: INTEGER:=32);
PORT ( A,B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Y   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
      );
END SUM_GEN_2;
ARCHITECTURE COMP OF SUM_GEN_2 IS
BEGIN
Y<= A + B;
END COMP;

-----------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_SIGNED.ALL;

ENTITY REG_GEN IS
GENERIC (N: INTEGER);
PORT(clock,LD, CL: IN STD_LOGIC;
     A: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
     S: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
END REG_GEN;

ARCHITECTURE COMP OF REG_GEN IS
SIGNAL MS: STD_LOGIC_VECTOR(N -1 DOWNTO 0);
BEGIN
PROCESS(clock,CL)
BEGIN
IF CL = '1' THEN
MS  <= (others => '0');
ELSIF (clock'event and clock='1')then
if LD ='1' then
MS <= A;
else
MS<=MS;
end if;
end if;
S<=MS;
END PROCESS;
END COMP;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_SIGNED.ALL;
USE ieee.std_logic_arith.all;

ENTITY MULT_GEN IS
GENERIC (N: INTEGER);
PORT ( A,B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Y   : OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0)
      );
END MULT_GEN;
ARCHITECTURE COMP OF MULT_GEN IS
BEGIN
Y <= A * B;

END COMP;

LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY TRUN_GEN_C IS
GENERIC (N: INTEGER);
PORT	(A: IN STD_LOGIC_VECTOR(4*N-1 DOWNTO 0);
	 Y: OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0));
END TRUN_GEN_C;

ARCHITECTURE COMP7 OF TRUN_GEN_C IS
BEGIN
--Y <= A(4*N-1)&A(3*N-4 DOWNTO N+6);--7
--Y <= A(4*N-1)&A(3*N-2 DOWNTO N);--8 funciona 1,50,25
--Y <= A(4*N-1)&A(3*N-1 DOWNTO N+1);--9
--Y <= A(4*N-1)&A(3*N DOWNTO N+2);--10
--Y <= A(4*N-1)&A(3*N+1 DOWNTO N+3); --11
Y <= A(4*N-1)&A(3*N+2 DOWNTO N+4);--12  *
--Y <= A(4*N-1)&A(3*N+3 DOWNTO N+5);--13
--Y <= A(4*N-1)&A(3*N+4 DOWNTO N+6);--14
END COMP7;

--------------------------------------------------------------
library ieee;
USE IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_arith.all;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;

ENTITY twoscompliment is
generic (N:integer:=32);
PORT ( 
           --Inputs
           A : in std_logic_vector (N-1 downto 0);
           --Outputs
           Y : out std_logic_vector (N-1 downto 0)
);
end twoscompliment;

architecture COMP of twoscompliment is
signal A_aux: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
 begin
  A_aux<=(not A);
  Y <= A_aux + '1';
 end COMP;


 -------------------- File comp_gen.vhd: ----------------------
 LIBRARY ieee;
 USE ieee.std_logic_1164.all;

PACKAGE comp_gen IS

COMPONENT SUM_GEN IS
GENERIC (N: INTEGER:=32; K : integer  :=2);
--GENERIC (N: INTEGER);
PORT ( A,B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Y   : OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0)
      );
END COMPONENT;

COMPONENT REG_GEN IS
GENERIC (N: INTEGER);
PORT(clock,LD, CL: IN STD_LOGIC;
     A: IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
     S: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0));
END COMPONENT;

COMPONENT MULT_GEN IS
GENERIC (N: INTEGER);
PORT ( A,B : IN STD_LOGIC_VECTOR(N-1 DOWNTO 0);
       Y   : OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0)
      );
END COMPONENT;

COMPONENT TRUN_GEN_C IS
GENERIC (N: INTEGER);
PORT	(A: IN STD_LOGIC_VECTOR(4*N-1 DOWNTO 0);
	 Y: OUT STD_LOGIC_VECTOR(2*N-1 DOWNTO 0));
END COMPONENT;

COMPONENT twoscompliment is
	GENERIC (N: INTEGER:= 32);
	PORT ( 
			   --Inputs
			   A : in std_logic_vector (N-1 downto 0);
			   --Outputs
			   Y : out std_logic_vector (N-1 downto 0)
	);
END COMPONENT;

END comp_gen;

--====================================== filter Pass ====================================--
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_signed.all;
--USE ieee.numeric_std.all;
USE work.comp_gen.all;
--USE work.comp_somadores.all;
-----------------------------------------------------
ENTITY LPF_biowear_2 IS
--generic (N:integer:=16; K:integer:=16);
generic (N:integer:=16);
    PORT (reset,clk,ld_l: IN STD_LOGIC;  
		X: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		--A1, A2, A3, A4: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		S_LPF: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END LPF_biowear_2;

-----------------------------------------------------
ARCHITECTURE comportamento OF LPF_biowear_2 IS

--SIGNAL X_inv, X_inv2, X_inv4: STD_LOGIC_VECTOR(13 DOWNTO 0);
SIGNAL X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12: STD_LOGIC_VECTOR(12 DOWNTO 0);
signal X_B0, X_B6_inv, Y_A2_inv : STD_LOGIC_VECTOR(N-1 downto 0);
SIGNAL X_B6, X_B12: STD_LOGIC_VECTOR(N-1 DOWNTO 0);
SIGNAL Y_A1, Y_A2: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 

SIGNAL Y0, Y, Y1, Y2: STD_LOGIC_VECtOR(N-1 DOWNTO 0);
SIGNAL Sum00, Sum01, Sum02, Sum03: STD_LOGIC_VECTOR(N-1 DOWNTO 0); 

signal tmp_ext  : std_logic_vector(16 downto 0);
signal tmp_b6   : std_logic_vector(16 downto 0);
signal tmp_b12  : std_logic_vector(16 downto 0);
signal tmp_ya1  : std_logic_vector(N downto 0); -- N = 16 → tmp_ya1(16 downto 0)


--Y[n] = 2y[n − 1] − y[n − 2] + x[n] − 2x[n − 6] + x[n − 12]
--A0=1   A1          A2         B0     B6          B12         
begin
R0_l: REG_GEN generic map(13) port map(clk,ld_l,reset, X,X0);    
R1_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X0,X1);    
R2_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X1,X2);    
R3_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X2,X3);    
R4_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X3,X4);    
R5_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X4,X5);    
R6_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X5,X6);    
R7_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X6,X7);    
R8_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X7,X8);
R9_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X8,X9);
R10_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X9,X10);    
R11_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X10,X11);    
R12_l: REG_GEN generic map(13) port map(clk,ld_l,reset,X11,X12);    

--R13_l: REG_GEN generic map(N) port map(clk,ld_l,reset, Sum01,Y0);
R13_l: REG_GEN generic map(N) port map(clk,ld_l,reset, Sum03,Y0);
R14_l: REG_GEN generic map(N) port map(clk,ld_l,reset, Y0,Y1);  
R15_l: REG_GEN generic map(N) port map(clk,ld_l,reset, Y1,Y2);     


X_B0 <= X(12) & X(12) & X(12) & X(12) & X(11 downto 0);
X_B6 <= X6(12) & X6(12) & X6(12) & X6(11 downto 0) & '0';
inv_B6: twoscompliment generic map(N) port map(X_B6,X_B6_inv);
X_B12 <= X12(12) & X12(12) & X12(12) & X12(12) & X12(11 downto 0);

SUM_0: SUM_GEN generic map(N) port map(X_B0,X_B6_inv,Sum00); --
--SUM_1: SUM_GEN generic map(N) port map(Sum00, X_B12, Sum01);

--Sum01 <="0000001000000000";

--tmp_ext  <= X(12) & X(12) & X(12) & X(12) & X(11 downto 0) & '0';
--X_B0 <= X(12) & X(12) & X(12) & X(12) & X(11 downto 0); -- desloca 3 bits para esquerda
--X_B0 <= "0000001000000000"; -- desloca 3 bits para esquerda
--tmp_b6   <= X6(12) & X6(12) & X6(12) & X6(12) & X6(11 downto 0) & '0';
--tmp_b12  <= X12(12) & X12(12) & X12(12) & X12(12) & X12(11 downto 0) & '0';
--tmp_ya1  <= Y(N-1) & Y(N-2 downto 0) & '0';


--X_B6   <= tmp_b6(15 downto 0);
--X_B12  <= tmp_b12(16) & tmp_b12(15 downto 1);
--Y_A1   <= tmp_ya1(15 downto 0); -- pega os bits 16 downto 1 também
--Y_A1 <= tmp_ya1(16) & tmp_ya1(14 downto 0);
--Y_A1 <= tmp_ya1(16 downto 1); -- 
--Y_A1 <= Y(15) & tmp_ya1(13 downto 0) & '0';
Y_A1 <= Y1(15) & Y1(13 downto 0) & '0';
--inv_B6: twoscompliment generic map(N) port map(X_B6,X_B6_inv);
--SUM_0: SUM_GEN generic map(N) port map(X_B0,X_B6_inv,Sum00); -- 

--SUM_1: SUM_GEN generic map(N) port map(Sum00, X_B12, Sum01);
Sum01 <="0000001000000000";
Y <= Sum01;
--SUM_02: SUM_GEN generic map(N) port map(Sum01, Y_A1, Sum02);
SUM_02: SUM_GEN generic map(N) port map(Y_A1, Y_A2_inv, Sum02); 
--INV_Y_A2: twoscompliment generic map(N) port map("0000100000000000",Y_A2_inv);
INV_Y_A2: twoscompliment generic map(N) port map(Y2,Y_A2_inv); -- 
--SUM_03: SUM_GEN generic map(N) port map(Sum02, Y_A2_inv, Sum03); -- 
SUM_03: SUM_GEN generic map(N) port map(Sum01, Sum02, Sum03); -- 
--Y_A2<=Y_A2_inv; -- Só para avalaiar a saída
-- Saída final:
--S_LPF <= Sum03;
--S_LPF <= Sum03;
S_LPF <= Y0;


end comportamento;
-----------------------------------------------------