-------------------------------- Ownership Note ---------------------------------

-- Created by BG
-- Created on 2024-12-28
-- Last modified on 2024-12-28


------------------------------------ About -------------------------------------

-- This is the my 1st program with VHDL
-- This is used to print simple "Hello World!" text in the command line
-- This is running on the VS Code with GHDL and GTKWave


---------------------------- How to run the program ----------------------------
-- Step 1: Go to the actual directory
--  	cd <directory_name>

-- Step 2: analyse the file
--      ghdl -a <filename>.vhdl 
--      ex: ghdl -a T01_HelloWorld.vhdl 

-- Step 3: execute the program
--      ghdl -e <entity_name>
--      ex: ghdl -e T01_HelloWorldTb

-- Step 4: run the program
--      ghdl -r <entity_name>
--      ex: ghdl -r T01_HelloWorldTb


----------------------- T01_HelloWorld Program Structure -----------------------

-- **************************** Defining the entity ****************************
-- Here we can add any arbitary name as the <entity_name>
-- Good practice: use meaningfull name
-- Remember to end the entity after the declarartion.

entity T01_HelloWorldTb is
    -- <Here body is empty>
end entity;



-- ************************* Defining the architecture *************************
-- Here we can add any arbitary name as the <architecture_name>
-- Good practice: use meaningfull name

-- architecture <architecture_name> of <entity_name> is 
-- begin
--        < Body of the architecture >

-- Remember to end the architectuer after the declarartion. For this we can use
-- end architecture;   OR   end <architecture_name>;

architecture simulation of T01_HelloWorldTb is
begin
    -- Body of the architecture

    -- Defining the process (more in future)
    process is
    begin

        -- Body of the process
        report "Hello World!";
        wait;

    end process;

end architecture;