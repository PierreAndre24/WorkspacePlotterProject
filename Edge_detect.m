function [time,weight]=Edge_detect(X,Y)
    
    if mod(max(size(Y)),2)==1
        X=X(1:end-1);
        Y=Y(1:end-1);
    end

    wtdata=CWT_Wavelab(Y,8,'DerGauss',2,4);

    maxmap=WTMM(wtdata);
%     toc
%     disp('SkelMap')
%     tic
    [skellist,skelptr,skellen]=BuildSkelMapFast(maxmap);
%     toc
    
    weight=zeros(size(skellen,2),1);
    time=zeros(size(skellen,2),1);
    wt2_median=median(wtdata.^2);
%     disp('weight calculation')
%     tic
    for i=1:size(skellen,2)
        [Amp2,RidgeLim]=ExtractSquareAmpRidge(i,wtdata,skellist,skelptr,skellen);
        weight(i)=sum(Amp2./wt2_median(RidgeLim(1,1):RidgeLim(1,2))');
        time(i)=X(RidgeLim(2,2));
    end
%     toc
   
%     figure
%     subplot(2,1,1);
%     plot(X,Y,'Linewidth',2)
%     set(gca,'XtickLabel','')
%     ylabel('I (nA)')
%     set(gca,'Fontsize',20,'Linewidth',2)
% 
%     subplot(2,1,2);
%     stem(time,weight,'Linewidth',2)
%     xlabel('time (ms)')
%     ylabel('track weight')
%     set(gca,'Fontsize',20,'Linewidth',2)
