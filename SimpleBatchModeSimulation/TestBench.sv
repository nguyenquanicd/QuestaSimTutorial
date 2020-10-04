//-----------------------------------------------------------
// Function:	TestBench TOP
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
`include "ifDut.sv"
module TestBench;
  `include "TestComponent.sv"
  parameter int    CLOCK_CYCLE  = 10;
  parameter int    TIMEOUT = 1000;
  int        RUN_NUMBER;
  bit [31:0] MIN_VALUE;
  bit [31:0] MAX_VALUE;
  ifDut ifDut();
  cEnv  oEnv;
  //Clock generator
  bit clk;
  always #(CLOCK_CYCLE/2) clk = ~clk;
  //Reset generator
  bit rst_n;
  initial begin
    rst_n = 1'b0;
    #(8*CLOCK_CYCLE)
    rst_n = 1'b1;
  end
  //
  assign ifDut.clk  = clk;
  assign ifDut.rst_n = rst_n;
  //DUT connection
  MooreFsm DUT (
    .clk   (ifDut.clk  ),
    .rst_n (ifDut.rst_n),
    .s_in  (ifDut.s_in ),
    .valid (ifDut.valid)
    );
  //Run
  initial begin
    oEnv = new();
    oEnv.build(ifDut);
    `include "Testcase.sv"
  end
  //Debug
  initial begin
    $dumpfile("TestBench.vcd");
    $dumpvars(0, TestBench);
  end
  //Timeout
  initial begin
    for (int t=0; t< TIMEOUT; t++) begin
      @ (posedge clk);
    end
    $strobe ("[TIMEOUT][%t] SIMULATION END", $time);
    @ (posedge clk);
    $stop;
  end
endmodule: TestBench