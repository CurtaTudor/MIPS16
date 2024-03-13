----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/19/2023 07:03:34 PM
-- Design Name: 
-- Module Name: EX - Behavioral
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

entity EX is
    port(RD1:in STD_LOGIC_VECTOR(15 downto 0);
        RD2:in STD_LOGIC_VECTOR(15 downto 0);
        ALUSrc:in STD_LOGIC;
        Ext_Imm:in STD_LOGIC_VECTOR(15 downto 0);
        sa:in STD_LOGIC;
        func:in STD_LOGIC_VECTOR(2 downto 0);
        ALUOp:in STD_LOGIC_VECTOR(1 downto 0);
        PCplus:in STD_LOGIC_VECTOR(15 downto 0);
        GT:out STD_LOGIC;
        Zero:out STD_LOGIC;
        ALURes:out STD_LOGIC_VECTOR(15 downto 0);
        BranchAddress:out STD_LOGIC_VECTOR(15 downto 0));
end EX;

architecture Behavioral of EX is

signal ALUCtrl:STD_LOGIC_VECTOR(2 downto 0):=(others => '0');
signal B:STD_LOGIC_VECTOR(15 downto 0):=(others => '0');
signal C:STD_LOGIC_VECTOR(15 downto 0):=(others => '0');

begin

ALUControl: process(ALUOp,func)
    begin
        case ALUOp is
            when "00" =>
                case func is
                    when "000" => ALUCtrl <= "000"; -- (+)
                    when "001" => ALUCtrl <= "001"; -- (-)
                    when "010" => ALUCtrl <= "010"; -- (<<)
                    when "011" => ALUCtrl <= "011"; -- (>>l)
                    when "100" => ALUCtrl <= "100"; -- (&)
                    when "101" => ALUCtrl <= "101"; -- (|)
                    when "110" => ALUCtrl <= "110"; -- (xor)
                    when "111" => ALUCtrl <= "111"; -- (>>a)
                    when others => ALUCtrl <= (others => 'X');
                end case;
           when "01" => ALUCtrl <= "000"; -- (+)
           when "10" => ALUCtrl <= "001"; -- (-)
           when "11" => ALUCtrl <= "100"; -- (&)
           when others => ALUCtrl <= (others => 'X');
       end case;
    end process ALUControl;
    
getB: process(RD2,Ext_Imm,ALUSrc)
begin
    if(ALUSrc='0') then
        B <= RD2;
    else
        B <= Ext_Imm;
    end if;
end process getB;

ALU: process(RD1,B,sa,ALUCtrl)
begin
    case ALUCtrl is
        when "000" => C <= RD1 + B;
        when "001" => C <= RD1 - B;
        when "010" => 
            if(sa='0') then
                C <= B;
            else
                C <= B(14 downto 0)&'0';
            end if;
        when "011" =>
            if(sa='0') then
                C <= B;
            else
                C <= '0'&B(15 downto 1);
            end if;
        when "100" => C <= RD1 and B;
        when "101" => C <= RD1 or B;
        when "110" => C <= RD1 xor B;
        when "111" =>
            if(sa='0') then
                C <= B;
            else
                if(B(15)='0') then
                    C <= '0'&B(15 downto 1);
                else
                    C <= '1'&B(15 downto 1);
                end if;
            end if;
       when others => C <= (others => 'X');
    end case;
end process ALU;
            
BranchAddress <= Ext_Imm + PCplus;            
ALURes <= C;    

Branch: process(RD1)
begin
    if(RD1=x"0000") then
        Zero <= '1';
        GT <= '0';
    else
        if(RD1(15)='0') then
            Zero <= '0';
            GT <= '1';
        else
            Zero <= '0';
            GT <= '0';
        end if;
    end if;
end process Branch;

end Behavioral;
