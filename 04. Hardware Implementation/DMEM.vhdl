-- Create by BG
-- Created on Thu, 02 Jan 2025 at 09:37 PM
-- Last modified on Thu, 02 Jan 2025 at 09:37 PM
-- This is the data memory unit for RMV-32IM Pipelined processor

-------------------------------------------------------------
--       RV-32IM Pipelined Processor Data Memory Unit      --
-------------------------------------------------------------
-- A Data Memory with 2 input streams and 1 output stream. --
-- Each input and output stream is 32 bit wide.            --
-------------------------------------------------------------

------------------
-- DMEM OPCODES --
------------------
-- 000 - LB     --
-- 001 - LH     --
-- 010 - LW     --
-- 011 - LBU    --
-- 100 - LHU    --
------------------


-- Note: 1 time unit = 1ns/100ps = 10ns

-- Libraries (IEEE)
library ieee ;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Entity 
entity DMEM is
  port(
    MemAddress   : in std_logic_vector (31 downto 0);
    MemDataInput : in std_logic_vector (31 downto 0);
    DMEMOP       : in std_logic_vector (2 downto 0);
    CLK, RESET   : in std_logic;
    MemOut       : out std_logic_vector (31 downto 0);
  );
end DMEM; 

-- Architecture of the DMEM
architecture DMEM_Architecture of DMEM is
    -- Components
    

    -- Internal Signals
    

    -- Clock period

begin
    ------------------- Component Mapping -------------------
    
end architecture;