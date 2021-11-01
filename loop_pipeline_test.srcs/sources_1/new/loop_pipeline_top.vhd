----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/12/2021 03:05:06 PM
-- Design Name: 
-- Module Name: loop_pipeline_top - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity loop_pipeline_top is
    port ( 
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
end loop_pipeline_top;

architecture Behavioral of loop_pipeline_top is
    --------------------
    -- Signals
    --------------------
    signal reset              : std_logic; 
    signal clk                : std_logic;

    -- IP interface control
    signal ap_idle            : std_logic;
    signal ap_start           : std_logic;
    signal ap_done            : std_logic;
    signal ap_ready           : std_logic;

    -- Input Array Interface
    signal input_array_ce     : std_logic;
    signal input_array_addr   : std_logic_vector(4 downto 0);
    signal input_array_data   : std_logic_vector(7 downto 0);

    -- Output
    signal output_acc         : std_logic_vector(19 downto 0);


    --------------------
    -- Components
    --------------------

    COMPONENT loop_pipeline_0
        PORT (
            A_ce0 : OUT STD_LOGIC;
            ap_clk : IN STD_LOGIC;
            ap_rst : IN STD_LOGIC;
            ap_start : IN STD_LOGIC;
            ap_done : OUT STD_LOGIC;
            ap_idle : OUT STD_LOGIC;
            ap_ready : OUT STD_LOGIC;
            ap_return : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
            A_address0 : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
            A_q0 : IN STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

begin

    -- Signal Mapping
    clk <= CLK_SYS;
    reset <= not(RESET_N);
    ap_start <= START;
    input_array_data <= INPUT_DATA;

    DONE <= ap_done;
    READY <= ap_ready;
    IDLE <= ap_idle;
    INPUT_ADDR <= input_array_addr;
    OUTPUT_SUM <=  output_acc;
    INPUT_ENABLE <= input_array_ce; 


    -- IP generated from Vitus HLS Example
    hls_loop_pipeline_ip0 : loop_pipeline_0
    PORT MAP (
        A_ce0 =>           input_array_ce,
        ap_clk =>          clk,
        ap_rst =>          reset,
        ap_start =>        ap_start,
        ap_done =>         ap_done,
        ap_idle =>         ap_idle,
        ap_ready =>        ap_ready,
        ap_return =>       output_acc,
        A_address0 =>      input_array_addr,
        A_q0 =>            input_array_data
    );

end Behavioral;
