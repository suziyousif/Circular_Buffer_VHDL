library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity testbench is
end entity testbench;

architecture RTL of testbench is

	
	signal clk 			: std_logic;
	signal clear 		: std_logic;
	signal dequeue_flag : std_logic;
	signal enqueue_flag : std_logic;
	signal data_in		: std_logic_vector (15 downto 0);
	signal data_out 	: std_logic_vector (15 downto 0);-- @suppress "signal data_out is never read"
	signal full			: std_logic;					 -- @suppress "signal full is never read"
	signal empty 		: std_logic;					 -- @suppress "signal empty is never read"
	 
begin
	
	my_registers: entity work.fila
		port map(
			clk      		=> clk,
			clear    		=> clear,
			enqueue_flag 	=> enqueue_flag,
			dequeue_flag 	=> dequeue_flag,
			data_in  		=> data_in,
			data_out 		=> data_out,
			full 			=> full,
			empty 			=> empty
		);	
	
	clock_driver : process
		constant period : time := 10 ns;
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clock_driver;
	
	dataIn : process is
	begin
		for i in 0 to 33 loop
			data_in <= std_logic_vector(to_unsigned(i, data_in'length));
			wait for 10 ns;
		end loop;
	end process dataIn;

	clear <= '1', '0' after 5 ns;
	enqueue_flag <= '0', '1' after 2 ns, '0' after 350 ns, '1' after 380 ns;	
	dequeue_flag <= '0' , '1' after 340 ns, '0' after 370 ns, '1' after 420 ns;
		
end architecture RTL;
