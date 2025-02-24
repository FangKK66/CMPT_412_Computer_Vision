function [pts3d,e1,e2] = triangulate(P1, pts1, P2, pts2 )
% triangulate estimate the 3D positions of points from 2d correspondence
%   Args:
%       P1:     projection matrix with shape 3 x 4 for image 1
%       pts1:   coordinates of points with shape N x 2 on image 1
%       P2:     projection matrix with shape 3 x 4 for image 2
%       pts2:   coordinates of points with shape N x 2 on image 2
%
%   Returns:
%       Pts3d:  coordinates of 3D points with shape N x 3
%


pointNum = size(pts1,1);

total_err1 = 0;
total_err2 = 0;

for idx = 1:pointNum
%     
%     A = [pts1(idx,2)*P1(3,:)-P1(2,:);      % y*p3 - p2
%         P1(1,:)-pts1(idx,1)*P1(3,:);       % p1 - x*p3
%         pts2(idx,2)*P2(3,:)-P2(2,:);       % y*p3 - p2
%         P2(1,:)-pts2(idx,1)*P2(3,:);];     % p1 - x*p3
    A = [pts1(idx,2)*P1(3,:)-P1(2,:); P1(1,:)-pts1(idx,1)*P1(3,:); pts2(idx,2)*P2(3,:)-P2(2,:); P2(1,:)-pts2(idx,1)*P2(3,:);];
    [U,S,V]=svd(A);
    X = V(:,end)';
    pts3d(idx,:)=X/X(4);
    

    pts1_pj= P1*(pts3d(idx,:)');
    pts1_pj= pts1_pj/pts1_pj(3);
    pts2_pj= P2*(pts3d(idx,:)');
    pts2_pj= pts2_pj/pts2_pj(3);
    total_err1 = total_err1 + sqrt( (pts1_pj(1,1)-pts1(idx,1)).^2 + (pts1_pj(2,1)-pts1(idx,2)).^2 );
    total_err2 = total_err2 + sqrt( (pts2_pj(1,1)-pts2(idx,1)).^2 + (pts2_pj(2,1)-pts2(idx,2)).^2 );
    
end

e1=total_err1/pointNum;
e2=total_err2/pointNum;