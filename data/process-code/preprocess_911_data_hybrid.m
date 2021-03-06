clear all;
close all;

%pre-process 911 data, using nearest neighbor strategyf
%find parents/children candidates, separate training/testing
%
load('../911.mat');
ind_events = datas.ind;
T = datas.T;
events = datas.e;
events = events/3600;
T = T/3600;
delim = 40000;
test_sz = 10000;
Kmax = 300;
Dmax = 3; %1,2,3
train_events = events(1:delim);
test_events = events(delim+1:delim+test_sz);

tr = [];
tr.e = train_events;
tr.ind = ind_events(1:delim,:);
[par, child] = locate_driving_candidate_hybrid(tr.e, Dmax, Kmax);
tr.par = par;
tr.child = child;
data = tr;
data.T = tr.e(end);
data.Dmax = Dmax;
data.Kmax = Kmax;
file_name_tr = strcat('../911-train-hybrid-', num2str(Dmax),'-',num2str(Kmax),'.mat');
save(file_name_tr, 'data');

te = [];
te.e = test_events;
te.ind = ind_events(delim+1:delim+test_sz,:);
[par, child] = locate_driving_candidate_hybrid(te.e, Dmax, Kmax);
te.par = par;
te.child = child;
data = te;
data.T1 = te.e(1);
data.T2 = te.e(end);
file_name_te = strcat('../911-test-hybrid-', num2str(Dmax),'-',num2str(Kmax),'.mat');
save(file_name_te, 'data');
fprintf('train: max # parents = %d\n', max_par_size(file_name_tr));
fprintf('test: max # parents = %d\n', max_par_size(file_name_te));


