module deb(input clk, rst, in, output reg out);
    reg[4:0] register;
    always @(posedge clk, posedge rst) begin
        if (rst) register<= 0;
        else register <= (register<<1) + in;
        out = (register[4:2] == 7);
    end
endmodule
