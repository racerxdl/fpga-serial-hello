`timescale 1ns / 1ps

module LedPWM(
    input clk,
    input [7:0] value,
    output out
    );

reg [7:0]    PWMCounter;
reg            outreg;
always @(posedge clk)
begin
        if(PWMCounter <= value & value != 0)
            outreg <= 1;
        else
            outreg <= 0;

        PWMCounter <= PWMCounter+1;
end

assign out = outreg;
endmodule