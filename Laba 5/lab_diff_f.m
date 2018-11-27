function f = lab_diff_f(t)
    w = 2*pi*4;
    f = 1.16*t + 0.13*sin(w*t) - 0.89*t.^2;
end