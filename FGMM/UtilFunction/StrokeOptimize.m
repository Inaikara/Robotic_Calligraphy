function [strokeNew] = StrokeOptimize(stroke)
    %% ”≈ªØ± ª≠ È–¥À≥–Ú
    strokeType=unique(stroke(:,3));
    for i=1:length(strokeType)
        strokeType0=strokeType(i);
        stroke0=stroke(stroke(:,3)==strokeType0,[1,2]);
        strokeDirect=stroke0(fix(4*end/5),:)-stroke0(fix(1*end/5)+1,:);
        strokeTheta= rad2deg(cart2pol(strokeDirect(2),strokeDirect(1)));
        if strokeTheta < 0
            stroke0=flip(stroke0);
            stroke(stroke(:,3)==strokeType0,[1,2])=stroke0;
        end
    end

    %% ”≈ªØÕ‰π≥± ª≠
    strokeNew=stroke;  
    for i=1:(length(strokeType)-1)
        strokeType1=strokeType(i);
        stroke1=stroke(stroke(:,3)==strokeType1,[1,2]);
        for j=(i+1):length(strokeType)
            strokeType2=strokeType(j);
            stroke2=stroke(stroke(:,3)==strokeType2,[1,2]);
            strokeEndDistance=norm(stroke1(end,:)-stroke2(end,:));
            strokeLengthDiff=min(length(stroke1),length(stroke2))/max(length(stroke1),length(stroke2));
            if strokeEndDistance<20 && strokeLengthDiff<0.5
                stroke2=flip(stroke2);
                strokeNew(stroke(:,3)==strokeType2,[1,2])=stroke2;
                strokeNew(stroke(:,3)==strokeType2,3)=strokeType1;
                if length(stroke1)==min(length(stroke1),length(stroke2))                    
                    strokeNew(strokeNew(:,3)==strokeType1,:)=flip(strokeNew(strokeNew(:,3)==strokeType1,:));
                end
            end
        end
    end
end

