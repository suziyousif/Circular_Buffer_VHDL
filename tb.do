# ============================================================================
# Name        : testbench.do
# Author      : Renan Augusto Starke
# Version     : 0.1
# Copyright   : Renan, Departamento de Eletrônica, Florianópolis, IFSC
# Description : Exemplo de script de compilação ModelSim
# ============================================================================

#Cria biblioteca do projeto
vlib work

#compila projeto: todos os aquivo. Ordem é importante
vcom basic_rom.vhd reg16.vhd fila.vhd testbench.vhd

#Simula (work é o diretorio, testbench é o nome da entity)
vsim -t ns work.testbench

#Mosta forma de onda
view wave

#Adiciona ondas específicas
# -radix: binary, hex, dec
# -label: nome da forma de onda

add wave -label clk /clk
add wave -label clear /clear
add wave -label enqueue_flag /enqueue_flag
add wave -label dequeue_flag /dequeue_flag
add wave -label full /full
add wave -label empty /empty
add wave -label data_in -radix dec /data_in
add wave -label data_out -radix dec /data_out
add wave -label reg_vector -radix dec /my_registers/registers
add wave -label tamanho -radix unsigned /my_registers/tamanho
#add wave -label cabeca -radix unsigned /my_registers/cabeca
#add wave -label cauda -radix unsigned /my_registers/cauda
add wave -label w_flag_encoder -radix unsigned /my_registers/w_flag_encoder

#Simula até um 500ns
run 900ns

wave zoomfull
write wave wave.ps
