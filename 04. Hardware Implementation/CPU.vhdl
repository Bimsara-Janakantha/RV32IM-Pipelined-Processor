-- Create by BG
-- Created on Wed, 01 Jan 2025 at 11:37 PM
-- Last modified on Thu, 02 Jan 2025 at 09:37 PM
-- This is the central processing unit for RMV-32IM Pipelined processor

-------------------------------------
--   RV-32IM Pipelined Processor   --
--     Central Processing Unit     --
-------------------------------------
-- Containing Modules:             --
-- 1. ALU                          --                   
-- 2. Register Files               --
-- 3. PC                           -- 
-- 4. Controll Unit                --
-------------------------------------

-- Note: 1 time unit = 1ns/100ps = 10ns

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity 
entity CPU is
  port(
    INSTRUCTION : in std_logic_vector (31 downto 0);
    CLK, RESET  : in std_logic;
    PC          : out std_logic_vector (31 downto 0)
  );
end CPU; 

-- Architecture of the CPU
architecture CPU_Architecture of CPU is
    -- Components
    component ALU is
      port(
        DATA1     : in std_logic_vector (31 downto 0);
        DATA2     : in std_logic_vector (31 downto 0);
        ALUOP     : in std_logic_vector (3 downto 0);
        ALURESULT : out std_logic_vector (31 downto 0);
        ZERO      : out std_logic
      );
    end component;

    component Reg_File
      port(
        ReadRegister_1 : in std_logic_vector(31 downto 0);
        ReadRegister_2 : in std_logic_vector(31 downto 0);
        WriteRegister  : in std_logic_vector(31 downto 0);
        WriteData      : in std_logic_vector(31 downto 0);
        ReadData_1     : out std_logic_vector(31 downto 0);
        ReadData_2     : out std_logic_vector(31 downto 0);
        Clk, Reset     : in std_logic;
        WriteEnable    : in std_logic
      );
    end component;

    component mux2_1 is
      port(
          input_1  : in std_logic_vector (31 downto 0);
          input_2  : in std_logic_vector (31 downto 0);
          selector : in std_logic;
          output_1 : out std_logic_vector (31 downto 0) -- No ; here
      );
    end component;

    -- Internal Signals
    Signal REGOUT1, REGOUT2, ALURESULT, COMPLEMENT_DATA : std_logic_vector (31 downto 0);
    Signal ALUOP : std_logic_vector (3 downto 0);
    Signal ZERO, WriteEnable : std_logic;

    -- Instruction Decording Formats
    Signal FUNC7, OPCODE : std_logic_vector (6 downto 0);
    Signal RS1, RS2, RD  : std_logic_vector (4 downto 0);
    Signal FUNC3         : std_logic_vector (2 downto 0);

    -- Clock period
    constant clk_period : time := 40 ns;    
begin
    ------------------- Component Mapping -------------------
    ALU_Component : ALU 
      port map(
          DATA1     => REGOUT1,
          DATA2     => SubMuxOut,
          ALUOP     => ALUOP,
          ALURESULT => ALURESULT,
          ZERO      => ZERO
      );

    ALU_Component : Reg_File 
      port map(
        ReadRegister_1 => -- This come from instruction decording,
        ReadRegister_2 => -- This come from instruction decording,
        WriteRegister  => -- This come from instruction decording,
        WriteData      => -- This come from instruction decording,
        ReadData_1     => REGOUT1,
        ReadData_2     => REGOUT2,
        Clk            => CLK,
        Reset          => RESET,
        WriteEnable    => WriteEnable
      );

    SubMux : mux2_1
      port map(
        input_1  => REGOUT2,
        input_2  => COMPLEMENT_DATA,
        selector => SubMuxSelect,
        output_1 => SubMuxOut
      );

    ComplementUnit : Complementer2s
      port(
        input_data  => REGOUT2,
        output_data => COMPLEMENT_DATA
      );

  -- Program Counter Function
  process (PC)
    variable nextPC : unsigned(31 downto 0) := 0;
  begin
    nextPC := Integer(Unsigned(PC)) + 4;
    report "PC UPDATED!";
  end process;

end architecture;