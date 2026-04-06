function boxes = topLeftBboxToXYXY(boxes)
% Convert [x1 y1 x2 y2] boxes into [x y w h] format. Input and
% output boxes are in pixel coordinates. boxes is an M-by-4
% matrix.
boxes(:,3) = boxes(:,1) + boxes(:,3) + 0.5;
boxes(:,4) = boxes(:,2) + boxes(:,4) + 0.5;
boxes = floor(boxes);

end