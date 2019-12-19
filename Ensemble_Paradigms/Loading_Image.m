function Image_Store = Loading_Image(directory)
%% Image_Store = Loading_Image(directory)
% This function is for loading all the .jpg file in the target directory 
global window  
cd(directory);
filename_list = dir(sprintf('*.jpg')); %Finding all the .jpg images
numfile = length(filename_list);

Image_Store = zeros(1,numfile);

for file_ite = 1:numfile 
    imageID = filename_list(file_ite).name;
    img = imread(imageID);
    Image_Store(file_ite) = Screen('MakeTexture',window,img);
    DrawFormattedText(window,'Loading Images...','center','center');
end
cd ..

Screen('Flip',window);
end

