function spCurvePlot(input_spdata)
%% This function is for plotting out the serial position curve
list_length = size(input_spdata,2);
sub_num = size(input_spdata,1);

mean_prob = mean(input_spdata);
std_prob = std(input_spdata);
ste_prob = std_prob / sqrt(sub_num);

SP_X = 1:list_length;
plot(SP_X,mean_prob);
errorbar(SP_X,mean_prob,ste_prob);
end