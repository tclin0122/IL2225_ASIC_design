library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity shift_register is

  port (
    --! Clock signal
    clk         : in  std_logic;
    --! Asynchronous active low reset
    nrst        : in  std_logic;
    --! New sample flag
    new_sample  : in  std_logic;
    --! Input sample
    sample_in   : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! Output of all samples
    all_samples : out sample_file);

end entity shift_register;

architecture behaviour of shift_register is

  signal data : sample_file;            -- All data in the shift register
  signal i    : integer;                -- Iterator for shift loop

begin  -- architecture behaviour

  -- purpose: Implementation of the shift register
  -- type   : sequential
  -- inputs : clk, nrst, sample_in, new_sample
  -- outputs: data
  SHIFT_PROC : process (clk, nrst) is
  begin  -- process SHIFT_PROC
    if nrst = '0' then                  -- asynchronous reset (active low)
      data <= (others => (others => '0'));
    elsif rising_edge(clk) then         -- rising clock edge
      if new_sample = '1' then
        for i in 1 to FILTER_TAPS-1 loop
          data(i) <= data(i-1);
        end loop;
        data(0) <= sample_in;
      end if;
    end if;
  end process SHIFT_PROC;

  all_samples <= data;
end architecture behaviour;
