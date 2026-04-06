function classes = createCOCOClasses(labelsNMS)
%#codegen
% labelsNMS: variable-size numeric vector
% classNames: cell array of strings (fixed-size or variable-size)

classNames = coder.const(@feval, 'getCOCOClassNames');
n = numel(labelsNMS);

% Preallocate and initialize all cells
classes = cell(n, 1);
for i = 1:n
    classes{i} = '';  % initialize with empty string
end

% Fill with actual class names
for i = 1:n
    idx = labelsNMS(i);
    classes{i} = classNames{idx};
end
