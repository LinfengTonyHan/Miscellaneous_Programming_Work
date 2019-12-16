function serial_input = spReorder(serial_position, study_items)
%%
size_v = length(serial_position);
size_l = length(study_items);

if size_v ~= size_l
    error('Size of serial positions and study items do not match:(');
end

for search = 1:size_v
    serial_input{search} = study_items{find(serial_position) == search};
end
end