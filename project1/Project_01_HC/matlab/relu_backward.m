function [input_od] = relu_backward(output, input, layer)

% Replace the following line with your implementation.
% init input_od then create mask
input_od = zeros(size(input.data));

    input_od(input.data > 0) = 1;

    input_od = input_od .* output.diff;
end
