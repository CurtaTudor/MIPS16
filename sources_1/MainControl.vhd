----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2023 11:54:58 AM
-- Design Name: 
-- Module Name: MainControl - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;
use IEEE.STD_LOGIC_ARITH.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainControl is
    port(Instr:in STD_LOGIC_VECTOR(2 downto 0);
        Br_gtz:out STD_LOGIC;
        RegDst:out STD_LOGIC;
        ExtOp:out STD_LOGIC;
        AluSrc:out STD_LOGIC;
        Branch:out STD_LOGIC;
        Jump:out STD_LOGIC;
        AluOp:out STD_LOGIC_VECTOR(1 downto 0);
        MemWrite:out STD_LOGIC;
        MemtoReg:out STD_LOGIC;
        RegWrite:out STD_LOGIC);
end MainControl;

architecture Behavioral of MainControl is
begin

process(Instr)
begin
    Br_gtz <= '0'; RegDst <= '0'; ExtOp <= '0';
    AluSrc <= '0'; Branch <= '0'; AluOp <= "00";
    MemWrite <= '0'; MemtoReg <= '0'; RegWrite <= '0';
    Jump <= '0';
    case Instr is
        when "000" => -- Tip R
            RegDst <= '1';
            RegWrite <= '1';
            AluOp <= "00"; --(R)
        when "001" => -- ADDI
            ExtOp <= '1';
            AluSrc <= '1';
            RegWrite <= '1';
            AluOp <= "01";
        when "010" => -- LW
            ExtOp <= '1';
            AluSrc <= '1';
            MemtoReg <= '1';
            RegWrite <= '1';
            AluOp <= "01"; --(+)
        when "011" => -- SW
            ExtOp <= '1';
            AluSrc <= '1';
            MemWrite <= '1';
            AluOp <= "01"; -- (+)
        when "100" => -- Beq
            ExtOp <= '1';
            AluSrc <= '1';
            Branch <= '1';
            AluOp <= "10"; -- (-)
        when "101" => -- Btgz
            ExtOp <= '1';
            AluSrc <= '1';
            Br_gtz <= '1';
            AluOp <= "10"; -- (-)
        when "110" => -- ANDI
            ExtOp <= '1';
            AluSrc <= '1';
            RegWrite <= '1';
            AluOp <= "11"; -- (&)
       when others => --Jump
            Jump <= '1';
       end case;
end process;

end Behavioral;
