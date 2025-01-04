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
    ------------------------------------- Components ------------------------------------
    component ProgramCounter is
      port (
        CLK, RESET : in std_logic;
        PC, PC4 : out std_logic_vector (31 downto 0)
      ) ;
    end component;

    component REG_IF_ID
      port(
        INSTRUCTION_I, PC_I, PC4_I : in std_logic_vector (31 downto 0);
        RESET, CLK                 : in std_logic;
        INSTRUCTION_O, PC_O, PC4_O : out std_logic_vector (31 downto 0)
      );
    end component;

    component CONTROL_UNIT is
      port (
        -- Input Ports   
        FUNC7, OPCODE : in std_logic_vector (6 downto 0);
        FUNC3         : in std_logic_vector (2 downto 0);
    
        -- Output Ports
        WriteEnable, MemRead, MemWrite, Jump, Branch, MUX1_I_Type, MUX2_I_Type, MUX3_RI_Typ, MUX4_I_Type, MUX5_U_Type : out std_logic;
        ALUOP : out std_logic_vector (3 downto 0)      
      ) ;
    end component;

    component Reg_File
      port(
        ReadRegister_1 : in std_logic_vector(5 downto 0);
        ReadRegister_2 : in std_logic_vector(5 downto 0);
        WriteRegister  : in std_logic_vector(5 downto 0);
        WriteData      : in std_logic_vector(31 downto 0);
        ReadData_1     : out std_logic_vector(31 downto 0);
        ReadData_2     : out std_logic_vector(31 downto 0);
        Clk, Reset     : in std_logic;
        WriteEnable    : in std_logic
      );
    end component;

    component REG_ID_EX is
      port (
        -- Signal Ports
        RESET, CLK  : in std_logic;
    
        -- Input Ports
        WriteEnable_I : in std_logic;
        FUNC3_I       : in std_logic_vector (2 downto 0);
        ALUOP_I       : in std_logic_vector (3 downto 0);
        RD_I          : in std_logic_vector (4 downto 0);
        IMM_I, PC_I, PC4_I, DATA1_I, DATA2_I : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O : out std_logic;
        FUNC3_O       : out std_logic_vector (2 downto 0);
        ALUOP_O       : out std_logic_vector (3 downto 0);
        RD_O          : out std_logic_vector (4 downto 0);
        IMM_O, PC_O, PC4_O, DATA1_O, DATA2_O : out std_logic_vector (31 downto 0)
      );
    end component;

    component ALU is
      port(
        DATA1     : in std_logic_vector (31 downto 0);
        DATA2     : in std_logic_vector (31 downto 0);
        ALUOP     : in std_logic_vector (3 downto 0);
        ALURESULT : out std_logic_vector (31 downto 0);
        ZERO      : out std_logic
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

    component REG_EX_MEM is
      port (
        -- Signal Ports
        RESET, CLK  : in std_logic;
    
        -- Input Ports
        WriteEnable_I : in std_logic;
        RD_I          : in std_logic_vector (4 downto 0);
        FUNC3_I       : in std_logic_vector (2 downto 0);
        ALURESULT_I   : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O : out std_logic;
        RD_O          : out std_logic_vector (4 downto 0);
        FUNC3_O       : out std_logic_vector (2 downto 0);
        ALURESULT_O   : out std_logic_vector (31 downto 0)
      );
    end component ;

    component REG_MEM_WB is
      port (
        -- Signal Ports
        RESET, CLK  : in std_logic;
    
        -- Input Ports
        WriteEnable_I : in std_logic;
        RD_I          : in std_logic_vector (4 downto 0);
        ALURESULT_I   : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O : out std_logic;
        RD_O          : out std_logic_vector (4 downto 0);
        ALURESULT_O   : out std_logic_vector (31 downto 0)
      );
    end component;

    ---------------------------------- Internal Signals ----------------------------------
    -- Signals in IF part
    Signal PC_IF, PC4_IF, INSTRUCTION_IF  : std_logic_vector (31 downto 0);

    -- Signals in ID part
    Signal PC_ID, PC4_ID, INSTRUCTION_ID, ReadData_1_ID, ReadData_2_ID : std_logic_vector (31 downto 0);
    Signal ALUOP_ID : std_logic_vector (3 downto 0);
    Signal WriteEnable_ID, MemRead_ID, MemWrite_ID, Jump_ID, Branch_ID, MUX1_I_Type_ID, MUX2_I_Type_ID, MUX3_RI_Type_ID, MUX4_I_Type_ID, MUX5_U_Type_ID : std_logic; -- Some of them are not connected

    -- Signals in EX part
    Signal PC_EX, PC4_EX, IMM_EX, ReadData_1_EX, ReadData_2_Ex, ALURESULT_EX : std_logic_vector (31 downto 0);
    Signal RD_EX : std_logic_vector (4 downto 0);
    Signal ALUOP_EX : std_logic_vector (3 downto 0);
    Signal FUNC3_EX : std_logic_vector (2 downto 0);
    Signal WriteEnable_EX, ZERO_EX : std_logic;

    -- Signals in MEM part
    Signal ALURESULT_MEM : std_logic_vector (31 downto 0);
    Signal RD_MEM : std_logic_vector (4 downto 0);
    Signal FUNC3_MEM : std_logic_vector (2 downto 0);
    Signal WriteEnable_MEM : std_logic;

    -- Signals in WB part
    Signal ALURESULT_WB : std_logic_vector (31 downto 0);
    Signal RD_WB : std_logic_vector (4 downto 0);
    Signal WriteEnable_WB : std_logic;

    -- Some Fileds Are Not Completed Yet.

begin
    ------------------------------- Component Mapping (Wiring) -------------------------------
  PC_Unit : ProgramCounter
  port map(
    CLK   => CLK,
    RESET => RESET,
    PC    => PC_IF,
    PC4   => PC4_IF
  );

  

end architecture;