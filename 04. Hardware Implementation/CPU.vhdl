-- Create by BG
-- Created on Wed, 01 Jan 2025 at 11:37 PM
-- Last modified on Wed, 08 Jan 2025 at 01:37 AM
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
-- 5. Pipeline Registers           --
-- 6. Immidiate Decorder           --
-- 7. Data Memory                  --
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
        WriteEnable, MemRead, MemWrite, Jump, Branch, MUX1_EN, MUX2_EN, MUX3_EN, MUX4_EN, MUX5_EN : out std_logic;
        ALUOP : out std_logic_vector (3 downto 0)      
      ) ;
    end component;

    component Reg_File
      port(
        ReadRegister_1 : in std_logic_vector(4 downto 0);
        ReadRegister_2 : in std_logic_vector(4 downto 0);
        WriteRegister  : in std_logic_vector(4 downto 0);
        WriteData      : in std_logic_vector(31 downto 0);
        ReadData_1     : out std_logic_vector(31 downto 0);
        ReadData_2     : out std_logic_vector(31 downto 0);
        Clock, Reset   : in std_logic;
        WriteEnable    : in std_logic
      );
    end component;

    component IMM_DECORDER is
      port (
        INSTRUCTION : in std_logic_vector(31 downto 0);
        IMM_OUTPUT  : out std_logic_vector(31 downto 0)
      ) ;
    end component;

    component REG_ID_EX is
      port (
        -- Signal Ports
        RESET, CLK  : in std_logic;
    
        -- Input Ports
        WriteEnable_I, MUX1_I, MUX2_I, MemRead_I, MemWrite_I : in std_logic;
        FUNC3_I       : in std_logic_vector (2 downto 0);
        ALUOP_I       : in std_logic_vector (3 downto 0);
        RD_I          : in std_logic_vector (4 downto 0);
        IMM_I, PC_I, PC4_I, DATA1_I, DATA2_I : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O, MUX1_O, MUX2_O, MemRead_O, MemWrite_O : out std_logic;
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
        WriteEnable_I, MUX2_I, MemRead_I, MemWrite_I : in std_logic;
        RD_I          : in std_logic_vector (4 downto 0);
        FUNC3_I       : in std_logic_vector (2 downto 0);
        ALURESULT_I   : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O, MUX2_O, MemRead_O, MemWrite_O : out std_logic;
        RD_O          : out std_logic_vector (4 downto 0);
        FUNC3_O       : out std_logic_vector (2 downto 0);
        ALURESULT_O   : out std_logic_vector (31 downto 0)
      );
    end component ;

    component DMEM is
      port(
        MemAddress   : in std_logic_vector (31 downto 0);
        MemDataInput : in std_logic_vector (31 downto 0);
        FUNC3        : in std_logic_vector (2 downto 0);
        CLK, RESET   : in std_logic;
        MemRead      : in std_logic;
        MemWrite     : in std_logic;
        MemOut       : out std_logic_vector (31 downto 0)
      );
    end component;

    component REG_MEM_WB is
      port (
        -- Signal Ports
        RESET, CLK  : in std_logic;
    
        -- Input Ports
        WriteEnable_I, MUX2_I : in std_logic;
        RD_I          : in std_logic_vector (4 downto 0);
        ALURESULT_I, MEMOUT_I : in std_logic_vector (31 downto 0);
    
        -- Output Ports
        WriteEnable_O, MUX2_O : out std_logic;
        RD_O          : out std_logic_vector (4 downto 0);
        ALURESULT_O, MEMOUT_O : out std_logic_vector (31 downto 0)
      );
    end component;

    ---------------------------------- Internal Signals ----------------------------------
    -- Signals in IF part
    Signal PC_IF, PC4_IF, INSTRUCTION_IF  : std_logic_vector (31 downto 0);

    -- Signals in ID part
    Signal PC_ID, PC4_ID, INSTRUCTION_ID, ReadData_1_ID, ReadData_2_ID, IMM_ID : std_logic_vector (31 downto 0);
    Signal ALUOP_ID : std_logic_vector (3 downto 0);
    Signal WriteEnable_ID, MemRead_ID, MemWrite_ID, Jump_ID, Branch_ID, MUX1_ID, MUX2_ID, MUX3_ID, MUX4_ID, MUX5_ID : std_logic; -- Some of them are not connected

    -- Signals in EX part
    Signal PC_EX, PC4_EX, IMM_EX, ReadData_1_EX, ReadData_2_Ex, DATA2_EX, ALURESULT_EX : std_logic_vector (31 downto 0);
    Signal RD_EX    : std_logic_vector (4 downto 0);
    Signal ALUOP_EX : std_logic_vector (3 downto 0);
    Signal FUNC3_EX : std_logic_vector (2 downto 0);
    Signal WriteEnable_EX, MUX1_EX, MUX2_EX, MemRead_EX, MemWrite_EX, ZERO_EX : std_logic;

    -- Signals in MEM part
    Signal ALURESULT_MEM, MemDataInput_MEM, MemOut_Mem : std_logic_vector (31 downto 0);
    Signal RD_MEM        : std_logic_vector (4 downto 0);
    Signal FUNC3_MEM     : std_logic_vector (2 downto 0);
    Signal WriteEnable_MEM, MUX2_MEM, MemRead_MEM, MemWrite_MEM : std_logic;

    -- Signals in WB part
    Signal ALURESULT_WB, MemOut_WB, WriteData_WB : std_logic_vector (31 downto 0);
    Signal RD_WB        : std_logic_vector (4 downto 0);
    Signal WriteEnable_WB, MUX2_WB : std_logic;

    -- Instruction decording signals
    Signal FUNC3         : std_logic_vector(2 downto 0);
    Signal RS1, RS2, RD  : std_logic_vector(4 downto 0);
    Signal OPCODE, FUNC7 : std_logic_vector(6 downto 0);


    -- Some Fileds Are Not Completed Yet.

begin
    ------------------------------- Component Mapping (Wiring) -------------------------------
  RV_PC : ProgramCounter
  port map(
    CLK   => CLK,
    RESET => RESET,
    PC    => PC_IF,
    PC4   => PC4_IF
  );

  RV_IF_ID : REG_IF_ID
  port map(
    INSTRUCTION_I => INSTRUCTION_IF,
    PC_I          => PC_IF,
    PC4_I         => PC4_IF,
    RESET         => RESET,
    CLK           => CLK,
    INSTRUCTION_O => INSTRUCTION_ID,
    PC_O          => PC_ID,
    PC4_O         => PC4_ID
  );

  RV_CONTROLER : CONTROL_UNIT
  port map(
    -- INPUT PORTS
    FUNC3       => FUNC3,
    FUNC7       => FUNC7,
    OPCODE      => OPCODE,

    -- OUTPUT PORTS
    ALUOP       => ALUOP_ID,
    WriteEnable => WriteEnable_ID, 
    MemRead     => MemRead_ID, 
    MemWrite    => MemWrite_ID, 
    Jump        => Jump_ID, 
    Branch      => Branch_ID, 
    MUX1_EN     => MUX1_ID, 
    MUX2_EN     => MUX2_ID, 
    MUX3_EN     => MUX3_ID, 
    MUX4_EN     => MUX4_ID, 
    MUX5_EN     => MUX5_ID
  );

  RV_REGFILE : Reg_File
  port map(
    ReadRegister_1 => RS1,
    ReadRegister_2 => RS2,
    WriteRegister  => RD_WB,
    WriteData      => WriteData_WB,
    ReadData_1     => ReadData_1_ID,
    ReadData_2     => ReadData_2_ID,
    Clock          => CLK, 
    Reset          => RESET,
    WriteEnable    => WriteEnable_WB
  );

  RV_IMM_DECORDER : IMM_DECORDER
  port map(
    INSTRUCTION => INSTRUCTION_ID,
    IMM_OUTPUT  => IMM_ID
  );

  RV_ID_EX : REG_ID_EX
  port map(
    RESET         => RESET,
    CLK           => CLK,

    -- INPUT PORTS
    WriteEnable_I => WriteEnable_ID,
    MUX1_I        => MUX1_ID,
    MUX2_I        => MUX2_ID,
    MemRead_I     => MemRead_ID,
    MemWrite_I    => MemWrite_ID,
    FUNC3_I       => FUNC3,
    ALUOP_I       => ALUOP_ID,
    RD_I          => RD,
    IMM_I         => IMM_ID, 
    PC_I          => PC_ID, 
    PC4_I         => PC4_ID, 
    DATA1_I       => ReadData_1_ID, 
    DATA2_I       => ReadData_2_ID,

    -- OUTPUT PORTS
    WriteEnable_O => WriteEnable_EX, 
    MUX1_O        => MUX1_EX,
    MUX2_O        => MUX2_EX,
    MemRead_O     => MemRead_EX,
    MemWrite_O    => MemWrite_EX,
    FUNC3_O       => FUNC3_EX, 
    ALUOP_O       => ALUOP_EX, 
    RD_O          => RD_EX, 
    IMM_O         => IMM_EX, 
    PC_O          => PC_EX, 
    PC4_O         => PC4_EX, 
    DATA1_O       => ReadData_1_EX, 
    DATA2_O       => ReadData_2_EX
  );

  RV_MUX_1 : mux2_1
  port map(
    input_1  => ReadData_2_Ex,
    input_2  => IMM_EX,
    selector => MUX1_EX,
    output_1 => DATA2_EX
  );

  RV_ALU : ALU
  port map(
    DATA1     => ReadData_1_EX,
    DATA2     => ReadData_2_Ex,
    ALUOP     => ALUOP_EX,
    ALURESULT => ALURESULT_EX,
    ZERO      => ZERO_EX
  );

  RV_EX_MEM : REG_EX_MEM
  port map(
    RESET => RESET,
    CLK   => CLK,

    -- INPUT PORTS
    WriteEnable_I => WriteEnable_EX,
    MUX2_I        => MUX2_EX,
    MemRead_I     => MemRead_EX,
    MemWrite_I    => MemWrite_EX,
    RD_I          => RD_EX,
    FUNC3_I       => FUNC3_EX,
    ALURESULT_I   => ALURESULT_EX,

    -- OUTPUT PORTS    
    WriteEnable_O => WriteEnable_MEM,
    MUX2_O        => MUX2_MEM,
    MemRead_O     => MemRead_MEM,
    MemWrite_O    => MemWrite_MEM,
    RD_O          => RD_MEM,
    FUNC3_O       => FUNC3_MEM,
    ALURESULT_O   => ALURESULT_MEM
  );

  RV_DMEM : DMEM
  port map(
    CLK          => CLK, 
    RESET        => RESET,
    MemAddress   => ALURESULT_MEM,
    MemDataInput => MemDataInput_MEM,
    FUNC3        => FUNC3_MEM,
    MemRead      => MemRead_MEM,
    MemWrite     => MemWrite_MEM,
    MemOut       => MemOut_Mem
  );

  RV_MEM_WB : REG_MEM_WB
  port map(
    RESET => RESET,
    CLK   => CLK,

    -- INPUT PORTS
    WriteEnable_I => WriteEnable_MEM,
    MUX2_I        => MUX2_MEM,
    RD_I          => RD_MEM,
    ALURESULT_I   => ALURESULT_MEM,
    MEMOUT_I      => MemOut_Mem,

    -- OUTPUT PORTS  
    WriteEnable_O => WriteEnable_WB,
    MUX2_O        => MUX2_WB,
    RD_O          => RD_WB,
    ALURESULT_O   => ALURESULT_WB,
    MEMOUT_O      => MemOut_WB
  );

  RV_MUX_2 : mux2_1
  port map(
    input_1  => ALURESULT_WB,
    input_2  => MemOut_WB,
    selector => MUX2_WB,
    output_1 => WriteData_WB
  );

  --------------------------------------- CPU Processes ---------------------------------------
  PC_UPDATING : process (PC_IF)
  begin
    PC <= PC_IF;
  end process;

  INSTRUCTION_FETCHING : process (INSTRUCTION)
  begin
    INSTRUCTION_IF <= INSTRUCTION;
  end process;

  INSTUCTION_DECORDING : process (INSTRUCTION_ID)
  begin
    -- Current decording is for R-Type
    FUNC7  <= INSTRUCTION_ID(31 downto 25);
    RS2    <= INSTRUCTION_ID(24 downto 20);
    RS1    <= INSTRUCTION_ID(19 downto 15);
    FUNC3  <= INSTRUCTION_ID(14 downto 12);
    RD     <= INSTRUCTION_ID(11 downto 7);
    OPCODE <= INSTRUCTION_ID(6 downto 0);
  end process; 

end architecture;