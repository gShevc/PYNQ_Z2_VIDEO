//This module is used to choose which Transition minimization encoding scheme to use

module tm_choice (
  input wire [7:0] data_in,
  output logic [8:0] qm_out
  );
 
 logic [8:0]  qm = 8'h00;
 logic [3:0] sum_ones;


always_comb begin
qm[0] = data_in[0]; 
sum_ones = $countones(data_in);


if((sum_ones > 4) || ((sum_ones == 4) && data_in[0] == 1'b0))begin
    for(int i =1; i<8; i++)begin
    qm[i] = data_in[i] ^~ qm[i-1];
    end

    qm[8] = 1'b0;
end
else begin
    for(int i =1; i<8; i++)begin
    qm[i] = data_in[i] ^ qm[i-1];
    end

    qm[8] = 1'b1; end
end

assign qm_out = qm;



endmodule