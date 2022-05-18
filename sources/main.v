module debug(buttons,operation,showOp,clk, rst, disp, enable);
input clk,rst,showOp;
input [3:0]buttons;
input [1:0]operation; // {addtion,subtraction,multiplication,division} 
wire clk_out;
output reg[7:0] disp;
output reg[3:0] enable;
reg [1:0]count;
wire [7:0] dispHolder[4:0]; // display holder
clkDiv clkDivInst(clk, rst, clk_out); // clock divider for the circulation
genvar i; integer j,k,idx; // iterators for loops
wire[3:0] d,df;
wire[7:0] n1, n2, x1;
reg[3:0] inpDig[3:0];

assign n2 = inpDig[1]*10+inpDig[0], n1 = inpDig[3]*10+inpDig[2];

wire[3:0] outDig[4:0];
reg[31:0] finalAns;
reg isNeg;
generate
    for(i=0;i<4;i=i+1) 
    begin     // process normal clock <-> debouncer <-> Rising Edge <-> increment
        deb d1(clk,rst,buttons[i],d[i]);
        RED r1(clk,rst,d[i],df[i]);
    end
endgenerate

generate
    for(i=0;i<5;i=i+1)
    begin
        segmentDisplay segDisp(outDig[i], enable, dispHolder[i], showOp); // process the number "count" into segment display
    end
endgenerate

segmentDisplay segDisp2(10, 1, x1);

wire [3:0] ch;
assign ch[3] = (finalAns < 1000 && (!isNeg || operation != 1));
assign ch[2] = (finalAns < 100);
assign ch[1] = (finalAns < 10);
assign ch[0] = 0;
generate
    for(i=0;i<4;i=i+1)
    begin
        assign outDig[i] = showOp && ch[i] ? 11 : (finalAns/(10**i))%10;
    end
endgenerate
always @(posedge clk)
begin
    case(operation)
        0: finalAns <= n1 + n2;
        1: 
            begin
                finalAns <= (n1>n2?n1-n2:n2-n1);
                if(n2<n1) isNeg <= 1;
                else isNeg<=0;
            end
        2: finalAns <= n1*n2;
        3: finalAns <= n2/n1;
    endcase
    if(!showOp) finalAns <= n1*100 + n2;
    
end 


always @(posedge clk_out) 
begin
    count = (rst?0:count+1);
    enable = (4'b1111 - (1<<count)); 
    disp <= (isNeg && showOp && operation == 1 && count==3)? x1 : dispHolder[count];
end

always @(posedge clk, posedge rst) 
begin
    if (rst) 
        for(j=0;j<4;j=j+1) 
            inpDig[j] <= 0; // reset the digit
    else if (df!=0) // if we have final debouncer regular as wanted
    begin
        for (j=0;j<4;j=j+1)
        begin
            if (df[j]) 
                inpDig[j]<=(inpDig[j]+1)%10; // find the button clicked
        end
    end
end

endmodule
