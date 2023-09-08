module toneOrgan( CLK, LEDR, SW,);
input CLK;
output [9:0] LEDR;
input [9:0] SW;

wire CLK_50M;
reg  [7:0] LED;
assign CLK_50M =  CLK;
assign LEDR[7:0] = LED[7:0];

//Character definitions

//numbers
parameter character_0 =8'h30;
parameter character_1 =8'h31;
parameter character_2 =8'h32;
parameter character_3 =8'h33;
parameter character_4 =8'h34;
parameter character_5 =8'h35;
parameter character_6 =8'h36;
parameter character_7 =8'h37;
parameter character_8 =8'h38;
parameter character_9 =8'h39;


//Uppercase Letters
parameter character_A =8'h41;
parameter character_B =8'h42;
parameter character_C =8'h43;
parameter character_D =8'h44;
parameter character_E =8'h45;
parameter character_F =8'h46;
parameter character_G =8'h47;
parameter character_H =8'h48;
parameter character_I =8'h49;
parameter character_J =8'h4A;
parameter character_K =8'h4B;
parameter character_L =8'h4C;
parameter character_M =8'h4D;
parameter character_N =8'h4E;
parameter character_O =8'h4F;
parameter character_P =8'h50;
parameter character_Q =8'h51;
parameter character_R =8'h52;
parameter character_S =8'h53;
parameter character_T =8'h54;
parameter character_U =8'h55;
parameter character_V =8'h56;
parameter character_W =8'h57;
parameter character_X =8'h58;
parameter character_Y =8'h59;
parameter character_Z =8'h5A;

//Lowercase Letters
parameter character_lowercase_a= 8'h61;
parameter character_lowercase_b= 8'h62;
parameter character_lowercase_c= 8'h63;
parameter character_lowercase_d= 8'h64;
parameter character_lowercase_e= 8'h65;
parameter character_lowercase_f= 8'h66;
parameter character_lowercase_g= 8'h67;
parameter character_lowercase_h= 8'h68;
parameter character_lowercase_i= 8'h69;
parameter character_lowercase_j= 8'h6A;
parameter character_lowercase_k= 8'h6B;
parameter character_lowercase_l= 8'h6C;
parameter character_lowercase_m= 8'h6D;
parameter character_lowercase_n= 8'h6E;
parameter character_lowercase_o= 8'h6F;
parameter character_lowercase_p= 8'h70;
parameter character_lowercase_q= 8'h71;
parameter character_lowercase_r= 8'h72;
parameter character_lowercase_s= 8'h73;
parameter character_lowercase_t= 8'h74;
parameter character_lowercase_u= 8'h75;
parameter character_lowercase_v= 8'h76;
parameter character_lowercase_w= 8'h77;
parameter character_lowercase_x= 8'h78;
parameter character_lowercase_y= 8'h79;
parameter character_lowercase_z= 8'h7A;

//Other Characters
parameter character_colon = 8'h3A;          //':'
parameter character_stop = 8'h2E;           //'.'
parameter character_semi_colon = 8'h3B;   //';'
parameter character_minus = 8'h2D;         //'-'
parameter character_divide = 8'h2F;         //'/'
parameter character_plus = 8'h2B;          //'+'
parameter character_comma = 8'h2C;          // ','
parameter character_less_than = 8'h3C;    //'<'
parameter character_greater_than = 8'h3E; //'>'
parameter character_equals = 8'h3D;         //'='
parameter character_question = 8'h3F;      //'?'
parameter character_dollar = 8'h24;         //'$'
parameter character_space=8'h20;           //' '     
parameter character_exclaim=8'h21;          //'!'


wire Clock_1KHz, Clock_1Hz;
wire Sample_Clk_Signal;
reg [32:0] divClk;
reg [32:0] noteName; //4 letters, 8 bits each = 32 width bus 
//Switch config for each note
parameter DoSW_1 =  3'b000;
parameter DoName =  {character_D, character_lowercase_o, character_space, character_space};
parameter ReSW   =  3'b001;
parameter ReName =  {character_R,character_lowercase_e, character_space, character_space};
parameter MiSW   =  3'b010;
parameter MiName =  {character_M, character_lowercase_i, character_space, character_space};
parameter FaSW   =  3'b011;
parameter FaName =  {character_F, character_lowercase_a, character_space, character_space};
parameter SoSW   =  3'b100;
parameter SoName =  {character_S, character_lowercase_o, character_space, character_space};
parameter LaSW   =  3'b101;
parameter LaName =  {character_L, character_lowercase_a, character_space, character_space};
parameter SiSW   =  3'b110;
parameter SiName =  {character_S, character_lowercase_i, character_space, character_space};
parameter DoSW_2 =  3'b111;
parameter Do2Name=  {character_D, character_lowercase_o, character_2, character_space};
parameter nilName=  {character_N, character_lowercase_i, character_lowercase_l, character_space};

//=======================================================================================================================
//
// Insert your code for Lab1 here!
// "Do       Re    Mi    Fa   So    La    Si     Do"
// [ 523Hz 587Hz 659Hz 698Hz 783Hz 880Hz 987Hz 1046Hz ].

//Cases for how each switch combo changes clk division -> changes (clk) freq
always @(SW[3:1]) begin
  //Note that divClk = 1 => 5MHz
  // divClk = 50MHz / (2 * f)
  case (SW[3:1])
    DoSW_1: begin 
      divClk = 32'hBAB9;  //523Hz -> 47801
      noteName = DoName;
    end
    ReSW: begin
        divClk = 32'hA65D; //587Hz -> 42589
        noteName = ReName;
    end
    MiSW: begin
         divClk = 32'h9430; //659Hz -> 37936
         noteName = MiName;
    end
    FaSW: begin
         divClk = 32'h8BE9; //698Hz -> 35817
         noteName = FaName;
    end
    SoSW: begin
         divClk = 32'h7CB8; //783Hz -> 31928
         noteName = SoName;
    end
    LaSW: begin
         divClk = 32'h6EF9; //880Hz -> 28409
         noteName = LaName;
    end
    SiSW: begin
         divClk = 32'h62F1; //987Hz -> 25329
         noteName = SiName;
    end
    DoSW_2: begin
      divClk = 32'h5D5C; //1046Hz -> 23900
      noteName = Do2Name;
    end
   default: begin
    divClk = 32'd1000000000; //play no sound
    noteName = nilName;
   end
  endcase
end



assign Sample_Clk_Signal = SW[0] ? 1: 1'b0;


endmodule
