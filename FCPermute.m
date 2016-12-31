function [output] = FCPermute(input, I, J, ROWS, COLS)
output = zeros(size(input));
for n = 1:COLS
    tmp = reshape(input(:, n), I, J, (ROWS / (I * J)));
    tmp = permute(tmp, [2 1 3]);
    output(:, n) = tmp(:);
end
% output = zeros(size(input));
% grps = ROWS / (I * J);
% for n = 1:COLS
%     counter = 0;
%     for g = 0:I*J:grps
%         for jj = 1:J
%             for ii = 0:(I - 1)
%                 counter = counter + 1;
%                 output(counter, n) = input(5 * ii + jj + g, n);
%             end
%         end
%     end
% end
end

