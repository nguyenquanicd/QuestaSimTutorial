//-----------------------------------------------------------
// Function:	The Moore FSM is used to detect the serial stream 001
// Property:  Synthesizable
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
module MooreFsm (
  input  logic clk,
  input  logic rst_n,
  input  logic s_in,
  output logic valid);
  //State values
  typedef enum logic [3:0] {IDLE    = 4'b0001,
                  D0      = 4'b0010,
                  D00     = 4'b0100,
                  D001    = 4'b1000,
                  DEFAULT = 4'bxxxx} state;
  state next_state, current_state;
  //Combinational circuit of the next state
  always_comb begin
    next_state = DEFAULT;
    case (current_state)
      IDLE: begin
        if (~s_in) next_state = D0;
        else next_state = current_state;
      end
      D0: begin
        if (~s_in) next_state = D00;
        else next_state = IDLE;
      end
      D00: begin
        if (s_in) next_state = D001;
        else next_state = current_state;
      end
      D001: begin
        if (s_in) next_state = IDLE;
        else next_state = D0;
      end
    endcase
  end
  //The state register
  always_ff @ (posedge clk, negedge rst_n) begin
    if (~rst_n) current_state <= IDLE;
    else current_state        <= next_state;
  end
  //Combinational circuit of the output
  always_comb begin
    case (current_state)
      IDLE:    valid = 1'b0;
      D0  :    valid = 1'b0;
      D00 :    valid = 1'b0;
      D001:    valid = 1'b1;
      default: valid = 1'bx;
    endcase
  end
 
endmodule
