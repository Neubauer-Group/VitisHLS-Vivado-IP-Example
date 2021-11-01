----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2021 03:06:28 PM
-- Design Name: 
-- Module Name: loop_pipeline_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_TEXTIO.all;
use STD.TEXTIO.all;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity loop_pipeline_tb is
end loop_pipeline_tb;

architecture Behavioral of loop_pipeline_tb is

    --------------------
    -- Signals
    --------------------
    signal reset_n            : std_logic; 
    signal reset              : std_logic;
    signal clk                : std_logic;
    signal clk_sys_100m       : std_logic;

    -- IP interface control;
    signal start              : std_logic;
    signal done               : std_logic;
    signal ready              : std_logic;
    signal idle               : std_logic;
    signal dut_resetn          : std_logic;

    -- Input Array Interface
    signal input_addr         : std_logic_vector(4 downto 0);
    signal input_data         : std_logic_vector(7 downto 0);
    signal input_enable       : std_logic;

    -- Output
    signal output_sum         : std_logic_vector(19 downto 0);

    -- State definitions for TF Read Simulation process
    TYPE state_type is (
        s_idle,
        s_process,
        s_done);
    signal state : state_type;

    signal result_count       : integer;


    --------------------
    -- Components
    --------------------
    COMPONENT loop_pipeline_top
        PORT (
            CLK_SYS              : in std_logic;
            RESET_N              : in std_logic;
            START                : in std_logic;

            INPUT_ADDR           : out std_logic_vector(4 downto 0);
            INPUT_DATA           : in  std_logic_vector(7 downto 0);
            INPUT_ENABLE         : out std_logic;

            OUTPUT_SUM           : out std_logic_vector(19 downto 0);

            IDLE                 : out std_logic;
            READY                : out std_logic;
            DONE                 : out std_logic
        );
    END COMPONENT;

    ----------------------
    -- Constants
    ----------------------
    constant CLK_SYS_100M_period  : time := 10 ns;
    type ram_type is array (0 to 19) of std_logic_vector(7 downto 0); 
    signal RAM : ram_type := (X"01", X"01", X"01", X"01",
                              X"01", X"01", X"01", X"01",
                              X"01", X"01", X"01", X"01",
                              X"01", X"01", X"01", X"01",
                              X"01", X"01", X"01", X"01");
    signal rom_addr           : integer;

begin

    reset <= not(reset_n);
    clk <= clk_sys_100m;

    -- Top level DUT
    dut : loop_pipeline_top
    PORT MAP (
        CLK_SYS     => clk,
        RESET_N     => dut_resetn,
        START       => start,

        INPUT_ADDR  => input_addr,
        INPUT_DATA  => input_data,
        INPUT_ENABLE => input_enable,

        OUTPUT_SUM  => output_sum,

        IDLE        => idle,
        READY       => ready,
        DONE        => done
    );

    -- Test Bench State Machine
    tb_state_machine : process(clk)
        variable msg_line          : line;
    begin
        if ( rising_edge(clk) ) then
            if (reset ='1') then
                start <= '0';
                state <= s_idle;
                result_count <= 0;
                dut_resetn <= '0';
            else
                --Default signal states
                dut_resetn <= '1';
    
                case (state) is

                    when s_idle =>
                        if(idle = '1') then
                            start <= '1';
                            state <= s_process;
                        else    
                            state <= s_idle;
                        end if;

                    when s_process =>
                        if(ready = '1') then
                            start <= '0';
                            result_count <= result_count + 1;
                        end if;

                        if(done = '1') then
                            write(msg_line, STRING'("---- Accumulation Process Complete - Cycle # "));
                            write(msg_line, result_count);
                            write(msg_line, STRING'(" Result: "));
                            write(msg_line, to_integer(unsigned(output_sum)));
                            writeline(output, msg_line);
                            state <= s_done;
                        else    
                            state <= s_process;
                        end if;

                    when s_done =>
                        if(idle = '1') then
                            dut_resetn <= '0';
                            state <= s_idle;
                        else    
                            state <= s_done;
                        end if;
                    
                    when others =>
                        state <= s_idle; 

                end case;
            end if;
        end if;     

    end process tb_state_machine;

    -- Input Memory Process
    input_rom : process (clk) begin

        if rising_edge(clk) then 
            if (reset ='1') then
                rom_addr <= 0;
                input_data <= x"00";
            else
                rom_addr <= to_integer(unsigned(input_addr));
                input_data <= RAM(rom_addr); 
            end if;
        end if;

    end process;

    

    -- Reset Process
    reset_process : process
    begin
        reset_n  <= '1';
        wait for 5 ns;
        reset_n  <= '0';
        wait for 15 ns;
        reset_n  <= '1';
        wait for 35 us;
    end process reset_process;
    
    -- Clock process for 100 MHz system clock
    CLK_SYS_100M_process : process
    begin
        clk_sys_100m  <= '0';
        wait for CLK_SYS_100M_period/2;
        clk_sys_100m  <= '1';
        wait for CLK_SYS_100M_period/2;
    end process CLK_SYS_100M_process;

end Behavioral;
