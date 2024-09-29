library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity parallel_fir is

  port (
    --! clock signal
    clk          : in  std_logic;
    --! asyncronous active low reset
    nrst         : in  std_logic;
    --! new sample flag
    new_sample   : in  std_logic;
    --! new sample
    sample_in    : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! output of the FIR filter
    output       : out signed(RESULT_WIDTH-1 downto 0);
    --! output ready flag
    output_ready : out std_logic);

end entity parallel_fir;

architecture structure of parallel_fir is

  signal all_coeffs       : coeff_file;
  signal all_samples      : sample_file;
  signal result           : signed (result_width-1 downto 0);
  signal output_ready_tmp : std_logic;
begin  -- architecture structure

  ROM_COEFFICIENTS_1 : entity work.rom_coefficients
    port map (
      coeff_out => all_coeffs);

  SHIFT_REGISTER_1 : entity work.shift_register
    port map (
      clk         => clk,
      nrst        => nrst,
      new_sample  => new_sample,
      sample_in   => sample_in,
      all_samples => all_samples);

  FSM_1 : entity work.FSM
    port map (
      clk          => clk,
      nrst         => nrst,
      new_sample   => new_sample,
      output_ready => output_ready_tmp);

  ARITHMETIC_UNIT_1 : entity work.arithmetic_unit
    port map (
      all_samples      => all_samples,
      all_coefficients => all_coeffs,
      result           => result);

  OUT_REG : process (clk, nrst)
  begin
    if nrst = '0' then
      output <= (others => '0');
    elsif rising_edge(clk) then
      if output_ready_tmp = '1' then
        output <= result;
      else
        output <= (others => '0');
      end if;
    end if;
  end process;

  output_ready <= output_ready_tmp;

end architecture structure;
