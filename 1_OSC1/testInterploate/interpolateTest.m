clear variables
clc

len = 8;
tG_vet_full = zeros(1,len);
tW_vet_full = zeros(1,len);
tRBFint_vet_full = zeros(1,len);
tplot_vet_full = zeros(1,len);

for i = 1 : len
    %     figure(i);
    fprintf("\n#########\nn°center use: %d\n",i);
    [tG_vet_full(i), tW_vet_full(i), tRBFint_vet_full(i), tplot_vet_full(i)] = interpolateMain(i,0.5, 1, 0);
    
end
%%
figure(1)
interpolateMain(16,0.5, 1, "full");

%%

tG_vet_speed = zeros(1,len);
tW_vet_speed = zeros(1,len);
tRBFint_vet_speed = zeros(1,len);
tplot_vet_speed = zeros(1,len);

for i = 1 : len
    %     figure(i);
    fprintf("\n#########\nn°center use: %d\n",i);
    [tG_vet_speed(i), tW_vet_speed(i), tRBFint_vet_speed(i), tplot_vet_speed(i)] = interpolateMain(i,0.5, 1, 1);
    
end

tG_vet_wTrunc = zeros(1,len);
tW_vet_wTrunc= zeros(1,len);
tRBFint_vet_wTrunc= zeros(1,len);
tplot_vet_wTrunc= zeros(1,len);

for i = 1 : len
    %     figure(i);
    fprintf("\n#########\nn°center use: %d\n",i);
    [tG_vet_wTrunc(i), tW_vet_wTrunc(i), tRBFint_vet_wTrunc(i), tplot_vet_wTrunc(i)] = interpolateMain(i,0.5, 1, 2);
    
end

%%
figure(len+1)
clf
plot(tG_vet_full,'g');
hold on
grid on
plot(tG_vet_speed,'g--');
plot(tG_vet_wTrunc,'g:');

plot(tW_vet_full,'r');
plot(tW_vet_speed,'r--');
plot(tW_vet_wTrunc,'r:');

plot(tRBFint_vet_full,'b');
plot(tRBFint_vet_speed,'b--');
plot(tRBFint_vet_wTrunc,'b:');

legend("tG full","tG speed","tG trunc","tW full","tW speed","tW trunc","tRBFint full","tRBFint speed","tRBFint trunk");

