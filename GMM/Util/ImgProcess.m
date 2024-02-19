function [img,data] = ImgProcess(img)
    img = imresize(img,[120,120]);
    img = imbinarize(img);
    [data(:,1),data(:,2)]=find(~img);
end

