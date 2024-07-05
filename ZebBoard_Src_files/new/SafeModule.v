`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 07.12.2022 15:45:25
// Design Name: 
// Module Name: SafeModule
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module SafeModule(
    input Clk, //Basic Sampling ClockSource
    input Reset,
    input VaultStatus, //Holds the vaultStatus in conjucture with vault module
    output reg SafeStatus, //Holds the Safe Status OPENED/CLOSED
    input [3:0] UserPINRead, //Slide-switch given by user to enter 4-bit PIN
    output reg [3:0] VIOPINRead,//Output to read into VIO (to monitor user PIN button)
    output reg [3:0] PINStored, // PIN stored in database
    input OpenClosePush, //User push button to initiate open/close safe (during opening-> PIN authententication. during closing-> PIN updation)
    input PINChangePush, //Push to entry new PIN into database
    output reg InvalidLED,//User enters invalid PIN / any invalidity
    output reg [5:0]CurrentState //temp deleted after tb
    );
    reg [20:0] ClockSource;
always@(posedge Clk,posedge Reset)
   begin
       if(Reset==1)
         ClockSource<=0;
       else
        ClockSource=ClockSource+1;
    end
    
    /* Finite states defined as parameters */
    parameter CheckSafe=6'b000000, WaitingForPIN=6'b001000, ValidateOpen=6'b011000, SafeClosed=6'b111000,
    PINSucceed=6'b000100, SafeOpened=6'b000110, ValidateClose=6'b000111;
    //reg [5:0]CurrentState;
    
    /*Some local variables*/
    reg InvalidLED_Status;
    reg dummyLatchOpenCloseButton, dummyLatchPINChangeButton;
    
    /*Password stored - init to 0000*/
    initial begin
    PINStored=4'b1010;
    SafeStatus=1'b0;
    InvalidLED=1'b0;
    CurrentState=4'b0000;
    dummyLatchOpenCloseButton=1'b0;
    dummyLatchPINChangeButton=1'b0;
    end
    
    always @(posedge ClockSource[20])
    begin
          if(VaultStatus==1'b1)begin // Vault is OPEN
            case(CurrentState)
                CheckSafe: // Checks the SafeStatus and transitions to either opened/closed branch
                            if(SafeStatus==1'b0)begin //Safe=CLOSED
                                CurrentState=SafeClosed;
                            end
                            else CurrentState=SafeOpened; //Safe=OPENED
                            
                ValidateClose:
                            if(OpenClosePush==1'b1)begin CurrentState=ValidateClose; end // to latch till push button released
                            else begin
                                #10000000;// wait for 10-100mS for debouncing push button
                                if(UserPINRead == 4'b0000)begin // Switches are resetted
                                    InvalidLED=1'b0;
                                    CurrentState=SafeClosed; // Close safe
                                end
                                else begin//switches not resetted all 0000
                                    InvalidLED=1'b1; 
                                    CurrentState=SafeOpened;
                                end
                            end
                ValidateOpen:
                            if(OpenClosePush==1'b1)begin CurrentState=ValidateOpen; end // to latch till push button released
                            else begin
                                #10000000;// wait for 10-100mS for debouncing push button
                                if((UserPINRead ~^ PINStored) == 4'b1111)begin // Pin matched
                                    InvalidLED=1'b0;
                                    CurrentState=SafeOpened;
                                end
                                else begin//Pin Failed
                                    InvalidLED=1'b1; 
                                    CurrentState=SafeClosed;
                                end
                            end
                SafeOpened: begin// Safe is Opened -> check for new PIN change or close safe seq
                            SafeStatus=1'b1;
                            if(PINChangePush==1'b0) begin
                                if(OpenClosePush==1'b0)CurrentState=SafeOpened;
                                else begin
                                    #10000000;// wait for 10-100mS for debouncing push button
                                    CurrentState=ValidateClose;
                                    //dummyLatchOpenCloseButton=1'b1; // to latch till push button released
                                end
                            end
                            else begin
                                #10000000;// wait for 10-100mS for debouncing push button
                                PINStored<=UserPINRead;
                            end
                            end
                SafeClosed: begin // If safe is Closed -> check for PIN entry to open safe
                            SafeStatus=1'b0;
                            if(OpenClosePush==1'b0) CurrentState=SafeClosed;
                            else begin
                                #10000000;// wait for 10-100mS for debouncing push button
                                CurrentState=ValidateOpen;
                            end    
                            end
            endcase 
          
          end
          else begin // Vault is CLOSED
            CurrentState=CheckSafe;// Idle state of Safe FSM
            InvalidLED=1'b0;
            SafeStatus=1'b0;
          end
        
    end
    
    always @(posedge ClockSource[10])begin //This piece would copy the input USER PIN to VIORead.
        VIOPINRead<=UserPINRead;
    end
    
endmodule
