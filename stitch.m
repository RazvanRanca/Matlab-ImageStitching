function stitch (im2,im1)

[r,nr] = match(im1,im2);

if (size(r,1) < nr/100)
    fprintf('There are not enough matching keypoints\n');
else
    % set RANSAC path
    cd RANSAC-Toolbox
    SetPathLocal
    cd ..
    % set RANSAC options
    options.epsilon = 1e-6;
    options.P_inlier = 1-1e-4;
    options.sigma = 1;
    options.validateMSS_fun = @validateMSS_homography;
    options.est_fun = @estimate_homography;
    options.man_fun = @error_homography;
    options.mode = 'RANSAC';
    options.Ps = [];
    options.notify_iters = [];
    options.min_iters = 1000;
    options.fix_seed = false;
    options.reestimate = true;
    options.stabilize = false;

    [results, options] = RANSAC(r', options);

    H = (reshape(results.Theta, 3, 3))';

    T = maketform('projective', H)

    [rim1, xdata, ydata] = imtransform(imread(im1), T);

    rp = r(:,1:2);
    [NX,NY] = tformfwd(T,rp);


    OX = r(:,3);
    OY = r(:,4);    

    xdata
    ydata
    rim2 = imread(im2);
    s2 = size(rim2);
    s1 = size(rim1);

    if(ydata(1) < 0)
        rim2 = padarray(rim2, [round(-1*ydata(1)) 0],'pre');
        OY = OY - ydata(1);
        NY = NY - ydata(1);
        %rp(:,2) = rp(:,2) - ydata(1);
    end

    if(xdata(1) < 0)
        rim2 = padarray(rim2, [0 round(-1*xdata(1))],'pre');
        OX = OX - xdata(1);
        NX = NX - xdata(1);
        %rp(:,1) = rp(:,1) - xdata(1);
    end

    if(ydata(2) > s2(2))
        rim2 = padarray(rim2, [round(ydata(2)-s2(2)) 0],'post');
        %rp(:,2) = rp(:,2) + (ydata(2)-s(2));
    end

    if(xdata(2) > s2(1))
        rim2 = padarray(rim2, [0 round(xdata(2)-s2(2))],'post');
        %rp(:,1) = rp(:,1) + (xdata(2)-s(2));

    end

    s2 = size(rim2);

    %np(:,2) = np(:,2) + s2(2)-s1(2);
    %op(:,1) = op(:,1) + ss(1);


    if(ydata(1) > 0)
       rim1 = padarray(rim1, [round(ydata(1)) 0],'pre');
    end

    if(xdata(1) > 0)
        rim1 = padarray(rim1, [0 round(xdata(1))],'pre');
    end

    s1 = size(rim1);

    s1
    s2

    if(s1(2) < s2(2))
        rim1 = padarray(rim1, [0 s2(2)-s1(2)],'post');
    end

    if(s1(1) < s2(1))
        rim1 = padarray(rim1, [s2(1)-s1(1) 0],'post');
    end

    for i=1:s2(1)
        for j=1:s2(2)
            if (rim1(i,j) == 0)
                rim1(i,j) = rim2(i,j);
            end
        end
    end

    imshow(rim1);
    hold on;

    s = size(NX)

    for i=1:s(1)
        plot(NX(i),NY(i),'bo');
        plot(OX(i),OY(i),'gx');
    end

    hold off;
    delete('tmp.key', 'tmp.pgm')
end
