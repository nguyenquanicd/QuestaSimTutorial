//-----------------------------------------------------------
// Function:	Test components for the simple simulation
//-----------------------------------------------------------
// Author  : Nguyen Hung Quan
// Blog    : http://nguyenquanicd.blogspot.com/
// Github  : https://github.com/nguyenquanicd
// LinkIn  : https://www.linkedin.com/company/icdesign-vlsi-technology/
// Facebook: https://www.facebook.com/integratedcircuitdesign/
// Twitter : https://twitter.com/NguyenQ23302315?s=03
// YouTube : https://www.youtube.com/channel/UC0EoSTTMWQqhem-0fXNJKfg
// email   : nguyenquan.icd@gmail.com
//-----------------------------------------------------------
// History:
//-----------------------------------------------------------
class cSimData;
  rand bit [31:0] bit_stream;
  //
  function new ();
  endfunction
endclass: cSimData

class cStimulusGenerator;
  cSimData driver_in;
  virtual ifDut ifDutport; 
  //
  function new (virtual ifDut ifDutGen);
    ifDutport = ifDutGen;
  endfunction
  //
  task tRun (int PkgNum, bit [31:0] MinValue, bit [31:0] MaxValue);
    ifDutport.s_in = 1'b1;
    @ (posedge ifDutport.rst_n);
    for (int g0 = 0; g0 < PkgNum; g0++) begin
      driver_in = new();
      assert(driver_in.randomize() with {bit_stream >= MinValue; bit_stream <= MaxValue;});
      $strobe ("[INFO][SGEN][%t] Send the bit stream from LSB to MSB %32b", $time, driver_in.bit_stream);
      for (int g1 = 0; g1 < 32; g1++) begin
        @ (posedge ifDutport.clk);
        ifDutport.s_in = driver_in.bit_stream[0];
        driver_in.bit_stream = driver_in.bit_stream >> 1;
      end
    end
    repeat (8) @ (posedge ifDutport.clk);
    $stop;
  endtask: tRun
endclass: cStimulusGenerator

class cMonitor;
  virtual ifDut ifDutport;
  bit       Mon2Comp;
  bit [3:0] ShiftReg;
  //
  function new (virtual ifDut ifDutMon);
    ifDutport = ifDutMon;
  endfunction
  //
  task tRun(int InMonEnable);
    while (1) begin
      @ (posedge ifDutport.clk);
      #1
      if (ifDutport.rst_n) begin
        if (InMonEnable == 1) begin
          ShiftReg   = {ShiftReg[2:0], ifDutport.s_in};
          if (ShiftReg[3:1] == 3'b001) begin
            Mon2Comp = 1'b1;
            $strobe ("[INMON][%t] Detect 001", $time);
          end
          else begin
            Mon2Comp = 1'b0;
          end
        end
        else begin
          Mon2Comp = ifDutport.valid;
        end
      end
      else begin
        ShiftReg   = '1;
        Mon2Comp = '0;
      end
    end
  endtask: tRun
  //
  task tResetCheck;
    while (1) begin
      @ (posedge ifDutport.clk);
      if (!ifDutport.rst_n & ifDutport.valid) begin
        $strobe ("[OUTMON][%t] valid=1 during the reset is asserting", $time);
        @ (posedge ifDutport.clk);
        $stop;
      end
    end
  endtask
endclass: cMonitor

class cComparator;
  virtual ifDut ifDutport;
  //
  function new (virtual ifDut ifDutComp);
    ifDutport   = ifDutComp;
  endfunction
  //
  task tRun (ref bit InMon2Comp, ref bit OutMon2Comp);
    while (1) begin
      @ (posedge ifDutport.clk);
      if (ifDutport.rst_n) begin
        if (InMon2Comp != OutMon2Comp) begin
          $strobe ("[ERROR][COMP][%t] The valid is toggled wrongly INMON=%1b OUTMON=%1b", $time, InMon2Comp, OutMon2Comp);
          @ (posedge ifDutport.clk);
          $stop;
        end
      end
    end
  endtask: tRun
  //
endclass: cComparator

class cEnv;
  cStimulusGenerator oSGen;
  cMonitor           oOutMon;
  cMonitor           oInMon;
  cComparator        oComp;
  //Constructor
  function new();
  endfunction
  //Create all objects and connect them
  function void build(virtual ifDut ifDutEnv);
    oSGen   = new(ifDutEnv);
    oOutMon = new(ifDutEnv);
    oInMon  = new(ifDutEnv);
    oComp   = new(ifDutEnv);
  endfunction: build
  //Call and run all tasks tRun in the Stimulus Generator,
  //  Output Monitor, Input Monitor and Comparator
  task run(int PkgNum, bit [31:0] MinValue, bit [31:0] MaxValue);
    fork
      oSGen.tRun(PkgNum, MinValue, MaxValue);
      oOutMon.tRun(0);
      oOutMon.tResetCheck();
      oInMon.tRun(1);
      oComp.tRun(oInMon.Mon2Comp, oOutMon.Mon2Comp);
    join
  endtask: run
endclass: cEnv