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
ENTITY Low_pass_flter IS
--generic (N:integer:=16; K:integer:=16);
generic (N:integer:=16);
    PORT (reset,clk,ld_l: IN STD_LOGIC;  
		X: IN STD_LOGIC_VECTOR(12 DOWNTO 0);
		--A1, A2, A3, A4: IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		S_LPF: OUT STD_LOGIC_VECTOR(N-1 DOWNTO 0));
END Low_pass_flter;

-----------------------------------------------------
ARCHITECTURE comportamento OF Low_pass_flter IS
    SIGNAL X0, X1, X2, X3, X4, X5, X6, X7, X8, X9, X10, X11, X12: STD_LOGIC_VECTOR(12 DOWNTO 0);
    SIGNAL X_B0, X_B6_inv, X_B12: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Y0, Y1, Y2: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Sum00, Sum01, FIR_part, IIR_part, Sum03: STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL Y_A1, Y_A2_inv: STD_LOGIC_VECTOR(15 DOWNTO 0);
    
    -- Sinais auxiliares para -2x[n-6]
    SIGNAL X6_ext, X6_shifted: STD_LOGIC_VECTOR(15 DOWNTO 0);
    -- Sinal para substituir FIR_part durante teste
    SIGNAL FIR_part_test : STD_LOGIC_VECTOR(15 DOWNTO 0) := (others => '0');
    SIGNAL aux_SUM00, aux_FIR_part : STD_LOGIC_VECTOR(16 DOWNTO 0);

BEGIN
    -- Pipeline de entrada
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

    -- Extensão de sinal correta para 16 bits
    X_B0 <= X0(12) & X0(12) & X0(12) & X0;
    X_B12 <= X12(12) & X12(12) & X12(12) & X12;
    
    -- Cálculo de -2x[n-6]:
    X6_ext <= X6(12) & X6(12) & X6(12) & X6;           -- 16 bits
    X6_shifted <= X6_ext(14 downto 0) & '0';            -- Multiplicação por 2
    inv_B6: twoscompliment generic map(16) port map(X6_shifted, X_B6_inv);

    -- Parte FIR: x[n] - 2x[n-6] + x[n-12] SUM_GEN_2
    SUM_0: SUM_GEN generic map(16) port map(X_B0, X_B6_inv, Sum00);
    SUM_1: SUM_GEN generic map(16) port map(Sum00, X_B12, FIR_part);

    -- Parte IIR: 2y[n-1] - y[n-2]
    Y_A1 <= Y1(14 downto 0) & '0';            -- 2*y[n-1] com sinal preservado
    INV_Y_A2: twoscompliment generic map(16) port map(Y2, Y_A2_inv);
    SUM_02: SUM_GEN generic map(16) port map(Y_A1, Y_A2_inv, IIR_part);

    -- >>> TESTE DA PARTE IIR: Substitua FIR_part por FIR_part_test <<<
    --FIR_part_test <= (others => '0');  -- Força entrada FIR para zero
    -- Teste: FIR 0.5 + IIR 0.5 = 1.0
    --FIR_part_test <= X_B0; -- 0.5
    --IIR_part <= "0000000000000000"; -- 0.5

    -- Soma final FIR + IIR
    SUM_03: SUM_GEN generic map(16) port map(FIR_part, IIR_part, Sum03);
    
    -- Registradores de saída e realimentação
    R14_l: REG_GEN generic map(16) port map(clk, ld_l, reset, Sum03, Y1);  
    R15_l: REG_GEN generic map(16) port map(clk, ld_l, reset, Y1, Y2);

    S_LPF <= Sum03;
  
END comportamento;

-----------------------------------------------------