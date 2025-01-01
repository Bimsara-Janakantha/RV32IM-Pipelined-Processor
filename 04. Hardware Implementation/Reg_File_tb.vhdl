-- Libraries (IEEE)
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Testbench entity
entity Reg_File_tb is
end Reg_File_tb;

-- Architecture of the testbench
architecture behavior of Reg_File_tb is
    -- Component Declaration for the Unit Under Test (UUT)
    component Reg_File
        port(
            ReadRegister_1 : in std_logic_vector(31 downto 0);
            ReadRegister_2 : in std_logic_vector(31 downto 0);
            WriteRegister  : in std_logic_vector(31 downto 0);
            WriteData      : in std_logic_vector(31 downto 0);
            ReadData_1     : out std_logic_vector(31 downto 0);
            ReadData_2     : out std_logic_vector(31 downto 0);
            Clock          : in std_logic;
            Reset          : in std_logic;
            WriteEnable    : in std_logic
        );
    end component;

    -- Internal Signals
    signal ReadRegister_1 : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadRegister_2 : std_logic_vector(31 downto 0) := (others => '0');
    signal WriteRegister  : std_logic_vector(31 downto 0) := (others => '0');
    signal WriteData      : std_logic_vector(31 downto 0) := (others => '0');
    signal ReadData_1     : std_logic_vector(31 downto 0);
    signal ReadData_2     : std_logic_vector(31 downto 0);
    signal Clock          : std_logic := '0';
    signal Reset          : std_logic := '0';
    signal WriteEnable    : std_logic := '0';

    -- Clock period
    constant clk_period : time := 20 ns;

begin
    -- Instantiate the Unit Under Test (UUT)
    testUnit: Reg_File
        port map(
            ReadRegister_1 => ReadRegister_1,
            ReadRegister_2 => ReadRegister_2,
            WriteRegister  => WriteRegister,
            WriteData      => WriteData,
            ReadData_1     => ReadData_1,
            ReadData_2     => ReadData_2,
            Clock          => Clock,
            Reset          => Reset,
            WriteEnable    => WriteEnable
        );

    -- Clock Process
    Clock_Process : process
    begin
        Clock <= '0';
        wait for clk_period / 2;
        Clock <= '1';
        wait for clk_period / 2;
    end process;

    -- Stimulus Process
    process
    begin
        -- Test Case 1: Reset operation
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';

        -- Test Case 2: Write and Read Operations
        WriteEnable <= '1';
        WriteRegister <= std_logic_vector(to_unsigned(5, 32)); -- Write to register 5
        WriteData <= x"ABCD1234";
        wait for clk_period;

        WriteEnable <= '0'; -- Disable write
        ReadRegister_1 <= std_logic_vector(to_unsigned(5, 32));
        wait for clk_period;
        
        -- Test Case 3: Register 0 remains constant zero
        WriteEnable <= '1';
        WriteRegister <= (others => '0'); -- Attempt to write to register 0
        WriteData <= x"12345678";
        wait for clk_period;

        WriteEnable <= '0'; -- Disable write
        ReadRegister_1 <= (others => '0'); -- Read register 0
        wait for clk_period;
        
        -- Test Case 4: Reset clears all registers
        Reset <= '1';
        wait for clk_period;
        Reset <= '0';

        ReadRegister_1 <= std_logic_vector(to_unsigned(5, 32));
        wait for clk_period;  
        
        assert false report "Simulation finished" severity failure;
    end process;
end behavior;
