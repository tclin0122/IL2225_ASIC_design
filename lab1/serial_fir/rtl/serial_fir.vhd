library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;

entity serial_fir is

  port (
    --! Clock signal
    clk          : in  std_logic;
    --! Active low asynchronous reset
    nrst         : in  std_logic;
    --! Sample input
    sample_in    : in  signed(SAMPLE_WIDTH-1 downto 0);
    --! New sample flag
    new_sample   : in  std_logic;
    --! Output of the FIR filter
    output       : out signed(RESULT_WIDTH-1 downto 0);
    --! Output ready flag
    output_ready : out std_logic);

end entity serial_fir;

architecture structural of serial_fir is

  signal nrst_mac            : std_logic;
  signal write_enable        : std_logic;
  signal result              : signed(RESULT_WIDTH-1 downto 0);
  signal write_address       : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal read_address        : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal coefficient_address : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal sample_out          : signed(SAMPLE_WIDTH-1 downto 0);
  signal coefficient         : signed(SAMPLE_WIDTH-1 downto 0);

begin

  ARITHMETIC_UNIT_1 : entity work.arithmetic_unit
    port map (
      clk         => clk,
      nrst        => nrst,
      nrst_mac    => nrst_mac,
      sample_in   => sample_out,
      coefficient => coefficient,
      result      => result);

  FSM_1 : entity work.fsm
    port map (
      clk                 => clk,
      nrst                => nrst,
      new_sample          => new_sample,
      write_enable        => write_enable,
      write_address       => write_address,
      read_address        => read_address,
      output_ready        => output_ready,
      nrst_mac            => nrst_mac,
      coefficient_address => coefficient_address);

  ROM_COEFFICIENTS_1 : entity work.rom_coefficients
    port map (
      coeff_addr => coefficient_address,
      coeff_out  => coefficient);

  DELAY_LINE_1 : entity work.delay_line
    port map (
      clk           => clk,
      nrst          => nrst,
      new_sample    => new_sample,
      write_address => write_address,
      write_enable  => write_enable,
      sample_in     => sample_in,
      read_address  => read_address,
      sample_out    => sample_out);

  OUTPUT_SELECT : output <= result when (output_ready = '1') else (others => '0');

end structural;
