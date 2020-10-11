//-----------------------------------------------------------
// Function:	Define the interface
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
interface ifDut;
  logic clk;
  logic rst_n;
  logic s_in;  //input of DUT
  logic valid; //output of DUT
endinterface: ifDut
