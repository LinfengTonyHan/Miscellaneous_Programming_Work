function output_prob = spOrganize(serial_position, study_items, recall_items, num_list, list_length)
%% spanalysis is for analyzing the recall probability as a function of serial position
% output_prob = spanalysis(serial_position, study_items, recall_items, num_list, list_length)
% This function can be used for analyzing recall probabilities of multiple
% lists of one subject -- for instance, a subject studies 8 word lists,
% each containing 20 words, then the input "serial position" should be a 1 * 160
% vector containing 8 groups of serial positions ranging from 1 ~ 20. The
% input "num_list" refers to the number of lists (8).

size_v = size(serial_position,2);
size_l = size(study_items,2);

if size_v ~= size_l %check if the sizes match
    error('Size of serial positions and study items do not match.');
end

if 3 <= nargin && nargin <= 4 %a little confusing here, check later
    num_list = 1;
    list_length = size(serial_position, 2);
end

if size_v ~= num_list * list_length
    error('Size of serial positions and study items do not match.');
end

for ite_i = 1:num_list
    PLnum = (list_length*(ite_i - 1) + 1):(list_length * ite_i);
    [output,~] = crecallprob(study_items(PLnum), recall_items(PLnum));
    output_prob_all(PLnum) = output;
end
output_prob_all(output_prob_all ~= 0) = 1;

output_prob = zeros(1,list_length);
for ite_list = 1:list_length
    for ite_item = 1:num_list
        output_prob(ite_list) = output_prob(ite_list) + output_prob_all((ite_item-1)*(list_length)+ite_list);
    end
end

output_prob = output_prob / num_list;

end
