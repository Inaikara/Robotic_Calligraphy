function [data,stroke,componentOrder]= AddStroke(data,stroke,charGMM)
    numComponent=charGMM.NumComponents;
    strokeComponent=cluster(charGMM,stroke(:,[1,2]));
    stroke(:,4)=strokeComponent;
    stroke2ComponentList=unique(stroke(:,[3,4]),'stable','rows');
    stroke2Component=zeros(numComponent,2);
    for componentType=1:numComponent
        componentIdx=find(stroke2ComponentList(:,2)==componentType);
        maxStrokeNum=0;
        for j=1:length(componentIdx)           
            strokeType=stroke2ComponentList(componentIdx(j),1);
            strokeNum=length(find(stroke(:,3)==strokeType&stroke(:,4)==componentType))/length(find(stroke(:,3)==strokeType));
            if(strokeNum>maxStrokeNum)
                stroke2Component(componentType,:)=[strokeType,componentType];
                maxStrokeNum=strokeNum;
            end          
        end        
    end
    
    data(:,3)=cluster(charGMM,data);
    stroke(:,[3,4])=stroke(:,[4,3]);
    for i=1:numComponent
        data(data(:,3)==i,4)=stroke2Component(i,1);
        stroke(stroke(:,3)==i,4)=stroke2Component(i,1);
    end
      

        
    componentOrder=stroke2ComponentList;
    componentOrder(ismember(stroke2ComponentList,stroke2Component,'rows')==0,:)=[];

       
end

