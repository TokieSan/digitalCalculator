module RED(input clk, rst, in, output reg out);
    reg[1:0] register;
    always @(posedge clk, posedge rst) begin
        if (rst) register <= 0;
        else register <= (register<<1) + in;
        out = (register == 1);
    end    
endmodule
