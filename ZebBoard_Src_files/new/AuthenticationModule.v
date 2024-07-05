`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2022 18:23:25
// Design Name: 
// Module Name: AuthenticationModule
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


module AuthenticationModule(
    input Clk, //Basic Sampling ClockSource
    input Reset,
    input BankTiming, //Openhour=1, closedhour=0
    input PresidentAuthenticated, //President permission granted=1
    input GaurdAvailability, //If safe gaurd is available 
    input VP1Authenticated, //Vice-President1 permission granted=1
    input VP2Authenticated, //Vice-President2 permission granted=1    
    output reg VaultStatus //Holds the Vault Status OPENED/CLOSED
    );
    reg [20:0] ClockSource;
always@(posedge Clk,posedge Reset)
   begin
       if(Reset==1)
         ClockSource<=0;
       else
        ClockSource=ClockSource+1;
    end
    
    always @(posedge ClockSource[20])
    begin
        VaultStatus = ((BankTiming&(PresidentAuthenticated|VP1Authenticated|VP2Authenticated))|((~BankTiming)&(PresidentAuthenticated|(VP1Authenticated&VP2Authenticated))))&GaurdAvailability;
        /* bankTIming=OPEN {either President, or any one VP have give autherisation along with a gauard so can open/close vault}
           bankTiming=CLOSE {either President, or both VPs have to give autherisation along with a guard so can open/close vault)*/ 
          /* if ( PresidentAuthenticated&GaurdAvailability&BankTiming)
 begin
      UNLOCK=1'b1;
      LEDBLINK<=~LEDBLINK;
      end
 else if( BM1&OPEN)
    begin
      UNLOCK=1'b1;
      LEDBLINK<=~LEDBLINK;
      end
  else if (VP&(GM1|BM1)&~OPEN)
      begin
      UNLOCK=1'b1;
      LEDBLINK<=~LEDBLINK;
      end
  else
    begin
    UNLOCK=1'b0;
      LEDBLINK=4'b0000;
    end  
    end  */
    end
endmodule
