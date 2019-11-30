function x = clip(x, rangeValues)
% clip values to a given range
% x(x<rangeValues(1)) = rangeValues(1);
% x(x>rangeValues(2)) = rangeValues(2);
x = min(max(x,rangeValues(1)),rangeValues(2));
