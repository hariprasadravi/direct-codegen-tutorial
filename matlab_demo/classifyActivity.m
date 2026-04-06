function activity = classifyActivity(pred)
    % pred is [1, 75, 5] — take last timestep, find argmax
    lastStep = pred(1, end, :);       % [1, 1, 5]
    scores = squeeze(lastStep);        % [5, 1]
    [~, idx] = max(scores);
    activity = ActivityLabel(idx);
end
