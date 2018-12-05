clear
close all;
% hyperparameter
k = 10;
bandit_mean = 4;
bandit_var = 3;
bandit_var_each = 2;
steps = 1000;
reward_list = normrnd(bandit_mean, bandit_var, k, 1);
epsilon = 0.1;
alpha = 0.1;
c = 2;
[~, optimal_action_index] = max(reward_list);
% greedy
% init 
rewards = ones(size(reward_list)) * bandit_mean ;
Ns = ones(size(reward_list));
average_reward = 0;
average_optimal_action = 0;
greedy_algorithm_record = zeros(steps, 1);
greedy_algorithm_optimal_action = zeros(steps, 1);
for step = 1 : steps
    [~, select_bandit] = max(rewards);
    Ns(select_bandit) = Ns(select_bandit) + 1;
    temprary_reward = normrnd(reward_list(select_bandit), bandit_var_each);
    rewards(select_bandit) = rewards(select_bandit) + 1/Ns(select_bandit)...
        * (temprary_reward - rewards(select_bandit));
    average_reward = average_reward + 1/step * (temprary_reward - average_reward);
    average_optimal_action = average_optimal_action + 1/step * ...
        ((select_bandit == optimal_action_index) - average_optimal_action);
    greedy_algorithm_record(step) = average_reward;
    greedy_algorithm_optimal_action(step) = average_optimal_action;
end

% epsilon-greedy
% init 
rewards = ones(size(reward_list)) * bandit_mean;
Ns = ones(size(reward_list));
average_reward = 0;
average_optimal_action = 0;
epsilon_greedy_algorithm_record = zeros(steps, 1);
epsilon_greedy_algorithm_optimal_action = zeros(steps, 1);
for step = 1 : steps
    if (rand < epsilon)
        select_bandit = randi(k);
    else
        [~, select_bandit] = max(rewards);
    end
    Ns(select_bandit) = Ns(select_bandit) + 1;
    temprary_reward = normrnd(reward_list(select_bandit), bandit_var_each);
    rewards(select_bandit) = rewards(select_bandit) + 1/Ns(select_bandit)...
        * (temprary_reward - rewards(select_bandit));
    average_optimal_action = average_optimal_action + 1/step * ...
        ((select_bandit == optimal_action_index) - average_optimal_action);
    average_reward = average_reward + 1/step * (temprary_reward - average_reward);
    epsilon_greedy_algorithm_record(step) = average_reward;
    epsilon_greedy_algorithm_optimal_action(step) = average_optimal_action;
end

% upper confidence bound
% init 
rewards = ones(size(reward_list)) * bandit_mean;
Ns = ones(size(reward_list));
average_reward = 0;
average_optimal_action = 0;
UCB_algorithm_record = zeros(steps, 1);
UCB_algorithm_optimal_action = zeros(steps, 1);
for step = 1 : steps
    [~, select_bandit] = max(rewards + c * sqrt(log(step) ./ Ns));
    Ns(select_bandit) = Ns(select_bandit) + 1;
    temprary_reward = normrnd(reward_list(select_bandit), bandit_var_each);
    rewards(select_bandit) = rewards(select_bandit) + 1/Ns(select_bandit)...
        * (temprary_reward - rewards(select_bandit));
    average_reward = average_reward + 1/step * (temprary_reward - average_reward);
    UCB_algorithm_record(step) = average_reward;
    average_optimal_action = average_optimal_action + 1/step * ...
        ((select_bandit == optimal_action_index) - average_optimal_action);
    UCB_algorithm_optimal_action(step) = average_optimal_action;
end

% gradient Bandit Algorithm
average_reward = 0;
average_optimal_action = 0;
GBA_algorithm_record = zeros(steps, 1);
GBA_algorithm_optimal_action = zeros(steps, 1);
H = zeros(k,1);
for step = 1 : steps
    pi_k = exp(H) / sum(exp(H));
    select_bandit = GetDecreteDistribution(pi_k);
    temprary_reward = normrnd(reward_list(select_bandit), bandit_var_each);
    for i = 1 : k
        if i == select_bandit
            H(i) = H(i) + alpha * (temprary_reward - average_reward) * (1 - pi_k(i));
        else
            H(i) = H(i) - alpha * (temprary_reward - average_reward) * pi_k(i);
        end
    end
    average_reward = average_reward + 1/step * (temprary_reward - average_reward);
    GBA_algorithm_record(step) = average_reward;
    average_optimal_action = average_optimal_action + 1/step * ...
        ((select_bandit == optimal_action_index) - average_optimal_action);
    GBA_algorithm_optimal_action(step) = average_optimal_action;
end


% draw result
figure;
hold on;

plot(greedy_algorithm_optimal_action,'--');
plot(epsilon_greedy_algorithm_optimal_action,'-');
plot(UCB_algorithm_optimal_action,'-');
plot(GBA_algorithm_optimal_action)
legend('greedy',['epsilon-greedy \epsilon = ',num2str(epsilon)],...
    ['UCB c = ', num2str(c)], ['GBA \alpha = ', num2str(alpha)]);
ylim([0,inf])
xlabel('times')
ylabel('average rewards')
figure
hold on
plot(ones(steps,1) * max(reward_list));
plot(greedy_algorithm_record,'--');
plot(epsilon_greedy_algorithm_record,'-');
plot(UCB_algorithm_record,'-');
plot(GBA_algorithm_record)
legend('best','greedy',['epsilon-greedy \epsilon = ',num2str(epsilon)],...
    ['UCB c = ', num2str(c)], ['GBA \alpha = ', num2str(alpha)]);
ylim([0,inf])
xlabel('times')
ylabel('average rewards')

function index_ = GetDecreteDistribution(pi_k)
    for i = 2 : length(pi_k)
        pi_k(i) = pi_k(i-1)+pi_k(i);
    end
    t = rand ./ pi_k - 1;
    if all(t(length(pi_k))==0)
        index_ = length(pi_k);
    else
        t(t>=0) = -10;
        [~,index_] = max(t);
    end
end
