function [output_prob_condA,output_prob_condB] = spOrganize_MultiCond(conditions,serial_position,study_items,recall_items,num_list,list_length)
%% Organizing the serial position curves under multiple conditions
SIZE_V = size(serial_position,2);
size_l = size(study_items,2);

if SIZE_V ~= size_l
    error('Size of serial positions and study items do not match.');
end

if 4 <= nargin && nargin <= 5
    num_list = 1;
    list_length = size(serial_position,2);
end

if SIZE_V ~= num_list * list_length
    error('Size of serial positions and study items do not match.');
end

for ite_i = 1:num_list
    PLnum = (list_length*(ite_i-1)+1):(list_length*ite_i);
    [output,~] = crecallprob(study_items(PLnum),recall_items(PLnum));
    output_prob_all(PLnum) = output;
end
output_prob_all(output_prob_all ~= 0) = 1;

loc.cond1 = (conditions == 1);
loc.cond2 = (conditions == 0);
condA_OPA = output_prob_all .* loc.cond1;
condB_OPA = output_prob_all .* loc.cond2;

output_prob_condA = zeros(1,list_length);
output_prob_condB = zeros(1,list_length);

for ite_list = 1:list_length
    for ite_item = 1:num_list
        output_prob_condA(ite_list) = output_prob_condA(ite_list) + condA_OPA((ite_item-1)*(list_length)+ite_list);
        output_prob_condB(ite_list) = output_prob_condB(ite_list) + condB_OPA((ite_item-1)*(list_length)+ite_list);
    end
end

output_prob_condA = output_prob_condA / (num_list/2);
output_prob_condB = output_prob_condB / (num_list/2);
end
