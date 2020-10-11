# QuestaSimTutorial
 Examples for performing the QuestaSim simulator on Windows
 
# SimpleBatchModeSimulation
 Running the QuestaSim in the batch mode
 
## 1. Commands

 1/ Run sim with the optimization (cannot view the waveform):
 perl run_sim.pl -sim
 
 2/ Run sim without the optimization (can view the waveform):
 perl run_sim.pl -simnovopt
 
 3/ Waveform view command:
 perl run_sim.pl -wave Testbench.vcd
 
## 2. Emvironment properties:
 OS: Windows
 
 Perl program: strawberry_5_26_0_2
 
 Waveform viewer: GtkWave
 
 QuestaSim: questasim64_10.2c
