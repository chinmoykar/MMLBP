    clear;
    str0='';
    M = csv2cell('random_forest_update_7_04.csv'); 
    L=length(M);
    itr=0; 
    for itr=1 : L
    disp(itr);
    MM=81;
    NN=81;
    PX= zeros(1,625);
    str1=M(itr,1);
    str=(strcat(str0,str1));
    str11=(str{:});
    II=imread(str11);      
    cycl=imresize(II,[MM,NN]);    
    %[rows columns numberOfColorBands] = size(grayImage);      
    if(isrgb(cycl))
        grayImage=rgb2gray(cycl);
    else
        grayImage=cycl;  
    end           
    cycl2=(grayImage);          
    size= 27; %it can be 27
    factor= 3;
    localBinaryPatternImage = uint8(zeros(size, size));
    for i= 1 : size
      for j= 1 : size
        sum=0;  
          for row= ((factor*i)-(factor-1)) : (factor*i)              
            for col= ((factor*j)-(factor-1)) : (factor*j)       
                sum= sum+ uint16(cycl2(row, col));                          
            end                
          end 
          %disp(sum);
          avg=(sum/(factor*factor));
          localBinaryPatternImage(i,j,:)= uint8(avg);
      end
    end
      localBinaryPatternImage=padarray(localBinaryPatternImage, [1,1]);
      features=1;     
      count=0;      
      %disp(MM);      
      for row = 2 : (size+1) %after zero padding size of localBinaryPatternImage becomes 29 but size=27 so we need to increase by 1
        for col = 2 : (size+1)  
          centerPixel = localBinaryPatternImage(row, col);
          pixel7=localBinaryPatternImage(row-1, col-1) >= centerPixel;  
          pixel6=localBinaryPatternImage(row-1, col)   >=   centerPixel;   
          pixel5=localBinaryPatternImage(row-1, col+1) >= centerPixel;  
          pixel4=localBinaryPatternImage(row, col+1)   >=   centerPixel;     
          pixel3=localBinaryPatternImage(row+1, col+1) >= centerPixel;    
          pixel2=localBinaryPatternImage(row+1, col)   >= centerPixel;      
          pixel1=localBinaryPatternImage(row+1, col-1) >= centerPixel;     
          pixel0=localBinaryPatternImage(row, col-1)   >= centerPixel;   
          centerPixel = uint8(...
          pixel7 * 2^7 + pixel6 * 2^6 + ...
          pixel5 * 2^5 + pixel4 * 2^4 + ...
          pixel3 * 2^3 + pixel2 * 2^2 + ...
          pixel1 * 2 + pixel0);                              
          PX(1,features)= centerPixel;   
          %disp(centerPixel);
          localBinaryPatternImage(row, col,:)=  uint8(centerPixel);           
          features= features+1;            
        end            
      end      
      localBinaryPatternImage1=uint8(localBinaryPatternImage);
      dlmwrite('LLBP-NEW_27_09_others_new.csv',PX,'delimiter',',','-append');              
  end
