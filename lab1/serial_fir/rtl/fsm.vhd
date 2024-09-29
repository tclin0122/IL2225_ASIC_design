library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.types_and_constants.all;


entity fsm is
  port(
    nrst                : in  std_logic;
    clk                 : in  std_logic;
    new_sample          : in  std_logic;
    write_enable        : out std_logic;
    write_address       : out unsigned(ADDRESS_WIDTH-1 downto 0);
    read_address        : out unsigned(ADDRESS_WIDTH-1 downto 0);
    coefficient_address : out unsigned(ADDRESS_WIDTH-1 downto 0);
    output_ready        : out std_logic;
    nrst_mac            : out std_logic);
end fsm;

architecture behavioral of fsm is

  constant MAX_TAP          : unsigned(ADDRESS_WIDTH-1 downto 0) := to_unsigned(FILTER_TAPS-1, ADDRESS_WIDTH);
  constant NUM_COEFFICIENTS : integer                            := 13;

  -- fsm state signals
  type state_type is (IDLE, CALC, READY);
  signal present_state : state_type;
  signal next_state    : state_type;

  signal nrst_mac_tmp            : std_logic;
  signal write_enable_tmp        : std_logic;
  signal counter                 : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal write_address_tmp       : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal read_address_tmp        : unsigned(ADDRESS_WIDTH-1 downto 0);
  signal coefficient_address_tmp : unsigned(ADDRESS_WIDTH-1 downto 0);

begin

  WRITE_ADDRESS_PR : process(clk, nrst)
  begin
    if nrst = '0' then
      write_address_tmp <= (others => '0');
    elsif rising_edge (clk) then
      if new_sample = '1' then
        if write_address_tmp = MAX_TAP then
          write_address_tmp <= (others => '0');
        else
          write_address_tmp <= write_address_tmp + 1;
        end if;
      end if;
    end if;
  end process WRITE_ADDRESS_PR;

  READ_ADDRESS_PR : process(clk, nrst)
  begin
    if nrst = '0' then
      read_address_tmp <= (others => '0');
    elsif rising_edge (clk) then
      if new_sample = '1' then
        read_address_tmp <= write_address_tmp;
      else
        if nrst_mac_tmp = '0' then
          read_address_tmp <= to_unsigned(0, read_address_tmp'length);
        elsif read_address_tmp = 0 then
          read_address_tmp <= MAX_TAP;
        else
          read_address_tmp <= read_address_tmp - to_unsigned(1, read_address_tmp'length);
        end if;
      end if;
    end if;
  end process READ_ADDRESS_PR;


  COUNTER_PR : process(clk, nrst)
  begin
    if nrst = '0' then
      counter <= (others => '0');
    elsif rising_edge (clk) then
      if (nrst_mac_tmp = '0') then
        counter <= (others => '0');
      else
        counter <= counter + 1;
      end if;
    end if;
  end process COUNTER_PR;

  -- purpose: fsm state registers
  -- type   : sequential
  -- inputs : clk, nrst, present_state
  -- outputs: next_state
  REG_STATE_PR : process(clk, nrst)
  begin
    if nrst = '0' then
      present_state <= IDLE;
    elsif rising_edge (clk) then
      present_state <= next_state;
    end if;
  end process REG_STATE_PR;


  -- purpose: main fsm logic controling the MACs, address pointers and delay line
  -- type   : combinational
  -- inputs : all (requires VHDL 2008)
  -- outputs: 
  FSM_LOGIC_PR : process(all)
  begin
    next_state              <= present_state;
    coefficient_address_tmp <= (others => '0');
    output_ready            <= '0';
    write_enable_tmp        <= '0';
    nrst_mac_tmp            <= '1';
    case present_state is
      when IDLE =>
        nrst_mac_tmp <= '0';
        if new_sample = '1' then
          write_enable_tmp <= '1';
          next_state       <= CALC;
        end if;
      when CALC =>
        nrst_mac_tmp <= '1';
        if (counter = NUM_COEFFICIENTS -1) then
          next_state <= READY;
        elsif counter = ("0000") then
          coefficient_address_tmp <= (others => '0');
        else
          coefficient_address_tmp <= counter;
        end if;

      when READY =>
        output_ready <= '1';
        next_state   <= IDLE;
    end case;
  end process FSM_LOGIC_PR;

  nrst_mac            <= nrst_mac_tmp;
  write_enable        <= write_enable_tmp;
  write_address       <= write_address_tmp;
  read_address        <= read_address_tmp;
  coefficient_address <= coefficient_address_tmp;

end behavioral;
