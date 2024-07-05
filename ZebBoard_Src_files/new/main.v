`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2022 23:32:30
// Design Name: 
// Module Name: main
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


module main(Clk,UserPINRead,VIOPINRead,OpenClosePush,PINChangePush,GaurdAvailability,PresidentAuthenticated,VP1Authenticated,VP2Authenticated,SafeStatus,InvalidLED);
input Clk,OpenClosePush,PINChangePush,GaurdAvailability,VP1Authenticated,VP2Authenticated,PresidentAuthenticated;
wire BankTiming, VaultStatus;
input [3:0] UserPINRead;
output SafeStatus,InvalidLED;
output [3:0] VIOPINRead;
wire [5:0] CurrentState;
reg [20:0] ClockSource;
wire [3:0]PINStored;
wire Reset;

     AuthenticationModule BankAuthenticaiton (Clk,Reset,BankTiming,PresidentAuthenticated,GaurdAvailability,VP1Authenticated,VP2Authenticated,VaultStatus);
     
     SafeModule BankSafe (Clk,Reset,VaultStatus,SafeStatus,UserPINRead,VIOPINRead,PINStored,OpenClosePush,PINChangePush,InvalidLED,CurrentState);

     vio_1 VIOProbeInstance(Clk,CurrentState,PINStored,VaultStatus,BankTiming);
  
endmodule
