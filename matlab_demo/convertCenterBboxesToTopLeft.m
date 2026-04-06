function bboxes = convertCenterBboxesToTopLeft(bboxes)

bboxes(:,1) = bboxes(:,1)- bboxes(:,3)/2 + 0.5; 
bboxes(:,2) = bboxes(:,2)- bboxes(:,4)/2 + 0.5;
bboxes = floor(bboxes);
bboxes(bboxes<1)=1; 

end