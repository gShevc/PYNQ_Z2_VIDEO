module counter(     input wire clk_in,
                    input wire rst_in,
                    input wire [31:0] period_in,
                    output logic [31:0] count_out
              );
 
    always_ff @(posedge clk_in)begi
    if(rst_in) 
    count_out <= 0;
    else if(count_out == (period_in - 1))
     count_out <= 0;
     else 
    
        count_out <= count_out + 1;
    
    
    end
endmodule