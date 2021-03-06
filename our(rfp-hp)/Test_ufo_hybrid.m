clear all;
close all;

addpath_recurse('./util');
addpath_recurse('./tensor_toolbox_2.6');
addpath_recurse('./lightspeed');
addpath_recurse('./minFunc_2012');

rng('default');
%core inputs that need to be tuned/changed
%1,3,5
train_file = '../data/ufo-train-hybrid-1-300.mat';
test_file = '../data/ufo-test-hybrid-1-300.mat';
res_file = './rfp-hp-ufo-hybrid-1-300.mat';
decay = 0.97;
R = 1; %1,2,5,8
nepoch = 100;


%load training & testing running
load(train_file);
data.e = data.e';
model = [];
model.R = R;
nvec = max(data.ind);
nmod = size(nvec,2);
for k=1:nmod
    model.U{k} = rand(nvec(k), model.R);
end
model.oldU = model.U;
model.lam = 0.01;
model.nepoch = nepoch;
model.dim = model.R*ones(1,nmod);
model.np = 100;
model.decay = decay;
model.batch_size = 100;
model.a = 0.1;
model.b = 0.1;
model.a0 = 1e-3;
model.a1 = 1e-3;
model.b0 = 1e-3;
model.b1 = 1e-3;
model.tau = 1;
model.T = data.T;
model.init_opt = 'random';

%truncated triggering kernel
model.triggering_strategy = 'hybrid';
model.Kmax = data.Kmax;
model.Dmax = data.Dmax;

%load testing data
test = load(test_file);
test = test.data;
test.e = test.e';

tic,
[model, test_LL_approx, test_LL_ELBO, models] = online_inference_TensorHPGP_doubly_sgd_dp_v4(data, model, 1, test, (1:length(test.e))', res_file);
toc


