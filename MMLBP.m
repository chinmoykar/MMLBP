    clear;
    str0='';
    M = csv2cell('random_forest_update_7_04.csv'); 
    L=length(M);
    itr=0; 
    for itr=1 : L
    disp(itr);
    MM=81;
    NN=81;
    PX= zeros(1,11);
    str1=M(itr,1);
    str=(strcat(str0,str1));
    str11=(str{:});
    II=imread(str11);  
    cycl=imresize(II,[MM,NN]);  
             
    if(isrgb(cycl))
        grayImage=rgb2gray(cycl);
    else
        grayImage=cycl;  
    end           
    cycl2=(grayImage);     
    features=1;
    PX= zeros(1,819);  
    size= 27; %it can be 27
    factor= 3;    
    %======================    
    localBinaryPatternImage = cycl2; 
        
    for LBP_round = 1 : 3       
     
      if(LBP_round == 1)
      localBinaryPatternImage1 = uint8(zeros(27, 27));
      MM= NN =81; 
      endif
      if(LBP_round == 2)
      localBinaryPatternImage2 = uint8(zeros(9, 9));  
      localBinaryPatternImage  = resize(9,9);
      localBinaryPatternImage  = localBinaryPatternImage1;
      MM= NN =27; 
      endif
      if(LBP_round == 3)
      localBinaryPatternImage3 = uint8(zeros(3, 3));
      localBinaryPatternImage  = resize(3,3);  
      localBinaryPatternImage  = localBinaryPatternImage2;
      MM = NN = 9;
      endif     
      count=0;
      inrow=1;   
      while ((row=((inrow*3)-1)) < MM )
        incol=1;
        while( (col=((incol*3)-1)) < NN )           
        sum_1=0;
        avg=0;
        for i= (row-1) : (row+1)
            for j= (col-1) : (col+1)                
               sum_1= sum_1+ uint32(localBinaryPatternImage(i, j));                
            end                
        end          
        avg=(sum_1/(factor*factor));
 
        centerPixel = localBinaryPatternImage(row, col);
        %disp('row=');disp(row); disp('col=');disp(col);
        pixel7=(abs(localBinaryPatternImage(row-1, col-1)- centerPixel)) >= avg;  
        pixel6=(abs(localBinaryPatternImage(row-1, col) - centerPixel)) >=   avg;   
        pixel5=(abs(localBinaryPatternImage(row-1, col+1) - centerPixel)) >= avg;  
        pixel4=(abs(localBinaryPatternImage(row, col+1) - centerPixel))>=   avg;     
        pixel3=(abs(localBinaryPatternImage(row+1, col+1) - centerPixel))>= avg;    
        pixel2=(abs(localBinaryPatternImage(row+1, col) - centerPixel)) >= avg;      
        pixel1=(abs(localBinaryPatternImage(row+1, col-1) - centerPixel)) >= avg;     
        pixel0=(abs(localBinaryPatternImage(row, col-1) - centerPixel))>= avg;       
        centerPixel = uint8(...
        pixel7 * 2^7 + pixel6 * 2^6 + ...
        pixel5 * 2^5 + pixel4 * 2^4 + ...
        pixel3 * 2^3 + pixel2 * 2^2 + ...
        pixel1 * 2 + pixel0);                              
        PX(1,features)= centerPixel;            
        if(LBP_round == 1)
            localBinaryPatternImage1(inrow, incol,:)=  uint8(centerPixel);               
        endif    
        if(LBP_round == 2)
            localBinaryPatternImage2(inrow, incol,:)=  uint8(centerPixel); 
        endif    
        if(LBP_round == 3)
            localBinaryPatternImage3(inrow, incol,:)=  uint8(centerPixel); 
        endif                               
        incol=incol+1;
        features= features+1;           
      end        
      inrow=inrow+1;  
    end    
    end
      dlmwrite('CKLBP-NEW_27_09_V1.csv',PX,'delimiter',',','-append');                    
  end