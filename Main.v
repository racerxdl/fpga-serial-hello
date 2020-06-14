module Main(
    input clk,
    input rst,
    output uart0_txd,
    output led_a
);


//Microsseconds divider

reg     [5:0]     contus         = 0;               //  Counter for division by 32
wire              clk1us         = (contus > 12);    //  Clock 1us

reg     [10:0]     conts          = 0;               // Counter for seconds
wire              clk1s          = (conts > 2047);   //  Clock 1 second

always @(posedge clk)
  if(contus == 25) // 25MHz clock, divide by 25
    contus <= 0;
  else
    contus <= contus + 1;

always @(posedge clk1us)
  conts <= conts + 1;


wire [7:0] hellostring [0:12];
assign hellostring[0]  = "H";
assign hellostring[1]  = "e";
assign hellostring[2]  = "l";
assign hellostring[3]  = "l";
assign hellostring[4]  = "o";
assign hellostring[5]  = " ";
assign hellostring[6]  = "W";
assign hellostring[7]  = "o";
assign hellostring[8]  = "r";
assign hellostring[9]  = "l";
assign hellostring[10] = "d";
assign hellostring[11] = "!";
assign hellostring[12] = "\n";

reg    [7:0]        ledpwm0         =  127;
reg    [5:0]        TXByteCount     =   13;                //    Bytes to Send
reg    [5:0]        TXByteSent      =    0;                //    Bytes sent
reg                 TXBusy          =    1;                //    Send Started Flag
reg    [7:0]        TXSendBuffer    =    0;                //    Send Buffer
reg                 TXSend          =    0;                //    Send Flag
wire                TXTransmitting;                        //    Send Busy Flag

always @(posedge clk1s)
begin
  ledpwm0 <= ledpwm0 + 1;
end

always @(posedge clk)
begin
        if(TXBusy)    //    Send Initialized
        begin
            if(~TXTransmitting)    //    Checks if the TX isnt sending anything
            begin
                if(~TXSend)
                begin
                    if(TXByteCount > 0)    //    Still has bytes to send
                    begin
                            TXSend             <=    1;
                            TXSendBuffer       <=    hellostring[TXByteSent];
                            TXByteCount        <=    TXByteCount -1;
                            TXByteSent         <=    TXByteSent + 1;
                    end
                    else
                    begin    //    No more bytes to send. Restart Hello World
                            TXBusy        <=    1;
                            TXByteSent    <=    0;
                            TXSend        <=    0;
                            TXByteCount   <=    13;
                    end
                end
            end
            else
                TXSend    <=    0;
        end
end


LedPWM led0 (
  .clk(clk1us),
  .value(ledpwm0),
  .out(led_a)
);


SerialTX RS232_Transmitter (
  .clk(clk),
  .TxD_start(TXSend),
  .TxD_data(TXSendBuffer),
  .TxD(uart0_txd),
  .TxD_busy(TXTransmitting)
);

endmodule