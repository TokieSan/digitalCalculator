`timescale 1ns / 1ps
module segmentDisplay(digit, enable, disp, showAns);
    input[3:0] digit;
    input showAns;
    input[3:0] enable;
    output reg[7:0] disp;
    always @(digit, enable) 
    begin
        case (digit) 
             0: disp = 8'b00000011; 
             1: disp = 8'b10011111; 
             2: disp = 8'b00100101;
             3: disp = 8'b00001101;
             4: disp = 8'b10011001;
             5: disp = 8'b01001001;
             6: disp = 8'b01000001;
             7: disp = 8'b00011111;
             8: disp = 8'b00000001;
             9: disp = 8'b00001001;
             10: disp =8'b11111101;
        endcase
        if(enable==4'b1101 && !showAns) disp<=disp-1;
    end
endmodule
