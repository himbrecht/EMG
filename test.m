function test

R = [0.40, 0.25, 0.15, 0.10, 0.10];

% happy1 = R.*[0, 3, 1, 0, 1];
% H1=sum(happy1);
% disp('happy1');
% disp(H1);
% 
% happy2 = R.*[1, 4, 2, 0, 1];
% H2=sum(happy2);
% disp('happy2');
% disp(H2);
% 
% happy3 = R.*[1, 5, 2, 0, 1];
% H3=sum(happy3);
% disp('happy3');
% disp(H3);
% 
% happy4 = R.*[1, 6, 2, 0, 1];
% H4=sum(happy4);
% disp('happy4');
% disp(H4);
% 
% happy5 = R.*[1, 7, 2, 0, 1];
% H5=sum(happy5);
% disp('happy5');
% disp(H5);
% 
% happy6 = R.*[1, 8, 2, 0, 1];
% H6=sum(happy6);
% disp('happy6');
% disp(H6);
% 
% happy7 = R.*[1, 9, 2, 0, 1];
% H7=sum(happy7);
% disp('happy7');
% disp(H7);
% 
% sad1 = R.*[0, 0, 0, 1, 0];
% S1=sum(sad1);
% disp('sad1');
% disp(S1);
% 
% sad2 = R.*[1, 1, 1, 1, 0];  
% S2=sum(sad2);
% disp('sad2');
% disp(S2);
% 
% sad3 = R.*[1, 2, 1, 1, 0];  
% S3=sum(sad3);
% disp('sad3');
% disp(S3);
% 
% sad4 = R.*[1, 3, 1, 1, 0];  
% S4=sum(sad4);
% disp('sad4');
% disp(S4);
% 
% angry1 = R.*[1, 7, 1, 0, 0];
% A1=sum(angry1);
% disp('angry1');
% disp(A1);
% 
% angry2 = R.*[1, 8, 2, 0, 0];
% A2=sum(angry2);
% disp('angry2');
% disp(A2);
% 
% angry3 = R.*[1, 9, 2, 0, 0];
% A3=sum(angry3);
% disp('angry3');
% disp(A3);
% 
% calm1 = R.*[0, 0, 0, 0, 0];
% disp('calm1');
% C1=sum(calm1);
% disp(C1);
% 
% calm2 = R.*[0, 1, 1, 0, 0];
% C2=sum(calm2);
% disp('calm2');
% disp(C2);
% 
% calm3 = R.*[0, 1, 2, 0, 0];
% C3=sum(calm3);
% disp('calm3');
% disp(C3);
% 
% calm4 = R.*[0, 0, 0, 0, 1];
% C4=sum(calm4);
% disp('calm4');
% disp(C4);
% 
% calm5 = R.*[0, 1, 1, 0, 1];
% C5=sum(calm5);
% disp('calm5');
% disp(C5);
% 
% calm6 = R.*[0, 1, 2, 0, 1];
% C6=sum(calm6);
% disp('calm6');
% disp(C6);

% i - dynamics counter
% j - tempo counter
% k - pitch counter
% l - keymode counter
% m - timbre counter

for i=0:1
    for j=3:9
        for k=1:2
            for l=0:1
                for m=0:1
happy = R.*[i, j, k, l, m];
H=sum(happy);
disp('happy');
disp(H);
                end
            end
        end
    end
end

for i=0:1
    for j=0:3
        for k=0:1
            for l=0:1
                for m=0:1
sad = R.*[i, j, k, l, m];
S=sum(sad);
disp('sad');
disp(S);
                end
            end
        end
    end
end

all sums in a matrix, use unique to remove duplicate values


% sad1 = R.*[0, 0, 0, 1, 0];
% S1=sum(sad1);
% disp('sad1');
% disp(S1);
% 
% angry1 = R.*[1, 7, 1, 0, 0];
% A1=sum(angry1);
% disp('angry1');
% disp(A1);
% 
% calm1 = R.*[0, 0, 0, 0, 0];
% disp('calm1');
% C1=sum(calm1);
% disp(C1);