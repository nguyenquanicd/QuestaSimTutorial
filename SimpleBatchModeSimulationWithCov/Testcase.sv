//Modify this row to create your expected testcase
RUN_NUMBER   = 2;
MIN_VALUE    = 32'b00000000_00000000_10000000_00000000;
MAX_VALUE    = 32'b00000000_00000000_10000000_00000000;
//force DUT.valid = 0;
//force DUT.valid = 1;
oEnv.run(RUN_NUMBER, MIN_VALUE, MAX_VALUE);