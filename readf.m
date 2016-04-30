function data=readf(fname,n)
    fid = fopen(fname, 'rt');
    if (n==2)
        data = textscan(fid,'%s  %f ', 'headerlines', 0, 'delimiter', ',');
    end
    if (n==3)
        data = textscan(fid,'%s %d %f ', 'headerlines', 0, 'delimiter', ',');
    end
    fclose(fid);
end