function [vecid,key1,key2]=create_vec2p(vecid,p1,p2)
if isempty(vecid)==0
vecid=[vecid vecid(end)+1];
else
 vecid=1;  
end
key1='STRING sgm_create_vector_2_created_ids[VIRTUAL]';
key2=sprintf('sgm_const_vector_2point_v1( "%d", "Point %d", "Point %d", FALSE, sgm_create_vector_2_created_ids )',vecid(end),p1,p2);