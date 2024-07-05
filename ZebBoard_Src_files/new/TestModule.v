`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.12.2022 15:58:58
// Design Name: 
// Module Name: TestModule
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


module TestModule(
    input ClockSource, //Basic Sampling ClockSource
    input [3:0]UserPIN, //Holds the vaultStatus in conjucture with vault module
    output reg Valid //Holds the Safe Status OPENED/CLOSED
    );
    
    always @(posedge ClockSource)
    begin
        if((UserPIN  ~^ 4'b1010) == 4'b1111) Valid=1'b1;
        else Valid=1'b0;            
    end
    
endmodule
