#!/strawberry_5_26_0_2/perl/bin

#-----------------------------------------------------------
# Function:	QuestaSim running script on Windows
#-----------------------------------------------------------
# Author  : Nguyen Hung Quan
# Blog    : http://nguyenquanicd.blogspot.com/
# Github  : https://github.com/nguyenquanicd
# LinkIn  : https://www.linkedin.com/company/icdesign-vlsi-technology/
# Facebook: https://www.facebook.com/integratedcircuitdesign/
# Twitter : https://twitter.com/NguyenQ23302315?s=03
# YouTube : https://www.youtube.com/channel/UC0EoSTTMWQqhem-0fXNJKfg
# email   : nguyenquan.icd@gmail.com
#-----------------------------------------------------------
# History:
#-----------------------------------------------------------

#---------------------------------------------
#The installed directory of Simulation tool
#---------------------------------------------
print "-------------------------------------\n";
my $SIM_TOOL = "C:/questasim64_10.2c/win64";
print "-- Simulator: $SIM_TOOL\n";
my $WAVE_TOOL = "D:/1.Program/gtkwave/bin";
print "-- Waveform viewer: $WAVE_TOOL\n";
print "-------------------------------------\n";

#---------------------------------------------
#Define all used tools
#---------------------------------------------
#Simulation commands
my $VLib    = "$SIM_TOOL/vlib.exe";
my $VLog    = "$SIM_TOOL/vlog.exe";
my $VOpt    = "$SIM_TOOL/vopt.exe";
my $VSim    = "$SIM_TOOL/vsim.exe";
#Wave viewer commands
my $VWave   = "$WAVE_TOOL/gtkwave.exe";

#---------------------------------------------
#Define all used tools
#---------------------------------------------
if ($ARGV[0] eq "-wave") {
  if ($ARGV[1] eq "") {
    print "DO NOT HAVE THE WAVEFILE";
  } else {
    system "$VWave $ARGV[1]";
  }
} elsif ($ARGV[0] eq "-sim") {
  #If the working directory is existed, it's removed
  if (-d "MyWork") { 
    system "rm -rf MyWork";
  }
  
  #Create the working library
  system "$VLib MyWork";
  
  #Compile the source code
  system "$VLog -work MyWork -sv MooreFsm.sv TestBench.sv -l vlog.log";
  
  #Optimize the design
  system "$VOpt -work MyWork TestBench -o MyOpt";
  
  #Load the design into the simulator
  #vsim -c MyWork.MyOpt -l vsim.log
  #vsim -c MyWork.TestBench -l vsim.log
  #vsim -c -nonvopt MyWork.MyOpt -l vsim.log
  
  #system "$VSim -c MyWork.TestBench -do \"run -all; quit\" -l vsim.log";
  
  system "$VSim -c -novopt MyWork.TestBench -do \"run -all; quit\" -l vsim.log";
  
  #system "$VSim -c -novopt MyWork.MyOpt -do \"run -all; quit\" -l vsim.log";
} else {
  print "Please select one of the below options:\n";
  print " -sim                 : Run the simulation\n";
  print " -wave <VCD file name>: View the waveform\n";
}

1;
