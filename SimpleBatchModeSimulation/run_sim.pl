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
} elsif ($ARGV[0] =~ "-sim") {
  #If the working directory is existed, it's removed
  if (-d "MyWork") { 
    system "rm -rf MyWork";
  }
  
  #Create the working library
  #C:/questasim64_10.2c/win64/vlib.exe MyWork
  system "$VLib MyWork";
  
  #Compile the source code
  system "$VLog -work MyWork -sv -f SrcList.f -l vlog.log";
  
  #Optimize the design
  system "$VOpt -work MyWork TestBench -o MyOpt";

  #Load the design into the simulator and run
  if ($ARGV[0] eq "-sim") {
    system "$VSim -c MyWork.MyOpt -do \"run -all; quit\" -l vsim.log";
  }
  else {
    system "$VSim -c -novopt MyWork.TestBench -do \"run -all; quit\" -l vsim.log";
  }
} else {
  print "Please select one of the below options:\n";
  print " -sim                 : Run the simulation with the optimization\n";
  print " -simnovopt           : Run the simulation without the optimization\n";
  print " -wave <VCD file name>: View the waveform\n";
}

1;
