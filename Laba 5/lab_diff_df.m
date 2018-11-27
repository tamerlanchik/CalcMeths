function df = lab_diff_df(t)
    w = 2*pi*4;
    df = 1.16 + 0.13*w*cos(w*t) - 1.78*t;
end