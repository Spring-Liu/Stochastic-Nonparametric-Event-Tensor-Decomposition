clear all;
close all;

addpath_recurse('./util');
addpath_recurse('./tensor_toolbox_2.6');
addpath_recurse('./lightspeed');
addpath_recurse('./minFunc_2012');

rng('default');
%change the file name accordingly
%not-10k if reaming 
model_file = '../results/911/rfp-hp/1-300/rfp-hp-911-hybrid-1-300-R-8.mat';
test_file = '../data/911-test-hybrid-1-300.mat';
res_file = '../r/911-test-hybrid-1-300-all-R-8-RFP-HP.mat';

load(model_file);
load(test_file);
n_models = length(cur.models);
n_test = 5;

ll = zeros(n_models,2);
ll_all = zeros(n_models, 1);

for k=1:n_models
    model = cur.models{k};
    ll_all(k) = test_ll_approx_v3(model, data);
    cur_ll = test_ll_approx_v2_more(model, data, n_test);    
    ll(k,:) = [mean(cur_ll), std(cur_ll)/sqrt(n_test)];
    fprintf('model %d\n',k);
end
res = [];
res.all = ll_all;
res.test = ll;
save(res_file, 'res');
max(ll)
[v,i] = max(ll(:,1))
ll(i,:)

