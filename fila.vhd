library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fila is
	port (
		clk 	:		 in std_logic;
		clear			: in std_logic;
		enqueue_flag	: in std_logic;
		dequeue_flag	: in std_logic;
		data_in			: in std_logic_vector (15 downto 0);
		data_out		: out std_logic_vector (15 downto 0);
		full			: out std_logic;
		empty			: out std_logic		
	);
end entity;

architecture RTL of fila is
	type reg_array is array (0 to 31) of std_logic_vector (15 downto 0);
	signal registers : reg_array;
	signal w_flag_encoder : std_logic_vector(31 downto 0);
	signal clear_n : std_logic;
	signal cabeca:unsigned(4 downto 0) := "00000";
	signal cauda:unsigned(4 downto 0):= "00000";
	signal tamanho:unsigned(5 downto 0):= "000000";
begin
	
	clear_n <= not clear;
	
	-- gera 32 componentes
	reg_gen: for i in 0 to 31 generate
		regs: entity work.reg16
			port map (
				clk 	=> clk,
				sclr_n 	=> clear_n,
				clk_ena => w_flag_encoder(i),
				datain 	=> data_in,
				reg_out => registers(i)
			);
	end generate;
	
	process (clk, clear) is
	begin
		if clear = '1' then
			tamanho <= "000000";
			cauda <= "00000";
			cabeca <= "00000";
			full <= '0';
			empty <= '0';
		elsif rising_edge(clk) then	
			if enqueue_flag = '1' then
				if tamanho < 32 then
					tamanho <= tamanho + 1;
					cauda <= cauda + 1;
				else
					full <= '1';
				end if;
			end if;
			if dequeue_flag = '1' then
				if tamanho > 0 then
					tamanho <= tamanho - 1;
					cabeca <= cabeca + 1;
					full <= '0';
				end if;
			end if;	
			if tamanho = 0 then
				empty <= '1';
			else
				empty <= '1';
			end if;	
		end if;
	end process;
	
	data_out <= registers(to_integer(cabeca));
	
	-- Codificador do enqueue_flag
	process(enqueue_flag, cauda, tamanho)
	begin
		w_flag_encoder <= (others =>'0');	
		if tamanho(5) = '0' then
			w_flag_encoder(to_integer(cauda)) <= enqueue_flag;
		end if;
	end process;	
	
	
end architecture RTL;