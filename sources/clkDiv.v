`timescale 1ns / 1ps

module clkDiv#(parameter n = 5000) (input clk, rst, output reg clk_out);
    reg[31:0] cnt;
    always @(posedge clk, posedge rst) begin
        if(rst) cnt<=0;
        else begin
            if(cnt != n-1)cnt <= cnt+1;
            else begin
                cnt <=0;
                clk_out = ~clk_out;
            end     
        end
    end
endmodule