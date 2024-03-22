function [img,data] = ImgProcess(img)
    img = imresize(img,[100,100]);
    img = imbinarize(img);
    [data(:,1),data(:,2)]=find(~img);
end

