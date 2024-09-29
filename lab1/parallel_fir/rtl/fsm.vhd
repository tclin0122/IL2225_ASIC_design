library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity FSM is
  port (
    clk          : in  std_logic;
    nrst         : in  std_logic;
    new_sample   : in  std_logic;
    output_ready : out std_logic);
end FSM;


architecture behavior of FSM is

  type state_type is (IDLE, READY);
  signal pres_state, next_state : state_type;

begin
  process (all)
  begin
    next_state   <= pres_state;
    output_ready <= '0';
    case pres_state is
      when IDLE =>
        if new_sample = '1' then
          next_state <= READY;
        end if;
      when READY =>
        output_ready <= '1';
        next_state   <= IDLE;
    end case;
  end process;

  process (nrst, clk)
  begin
    if nrst = '0' then
      pres_state <= IDLE;
    elsif rising_edge (clk) then
      pres_state <= next_state;
    end if;
  end process;

end behavior;
