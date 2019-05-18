% Initialize
clear
load('train_index.mat')
load('test_index.mat')
load('label.mat')
load('test_label.mat')
load('table.mat')
train_index = train_index + 1;
test_index = test_index + 1; % matlab indices different from python
label = label + 1;
test_label = test_label + 1;
map = zeros(1, 10000);
database_size = 40000; 
image_size = 2; % image_size at bottleneck
N = 1000; % top-N retrivel

% Begin Query
for m = 1:10000 % test_data size
    correct = 0;
    test = reshape(test_index(m,:,:), [image_size,image_size]);
    d = zeros(1,database_size);
    for i = 1:database_size
        for j = 1:image_size
            for k = 1:image_size
                o = train_index(i,j,k);
                p = test(j,k);
                d(i) = d(i) + table(o,p);
            end
        end
    end
    [~,sortted_index] = sort(d);
    topN_index=sortted_index(1:N);
    topN_label=zeros(1, N);
    corr = [];
    for l = 1:N
        topN_label(l)=label(topN_index(l));
    end
    num = sum(test_label(m)==topN_label);
    
    for s = 1:N
        if correct==num
            break
        elseif topN_label(s)==test_label(m)
            corr = [corr,(correct+1)/s]; %#ok<AGROW>
            correct = correct + 1;
        end
    end
    if length(corr) > 1
        map(m) = mean(corr);
    else
        map(m) = 0;
    end
end
  
    
    
                
                
                