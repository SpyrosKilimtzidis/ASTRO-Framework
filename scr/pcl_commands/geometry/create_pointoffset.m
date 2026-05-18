function [pointid,key1,key2]=create_pointoffset(pointid,dist,p1,p2,c1)
pointid=[pointid pointid(end)+1]  ;
key1='STRING asm_create_grid_off_created_ids[VIRTUAL]';
key2=sprintf('asm_const_grid_offset( "%d", %f, "Point %d", "Construct PointCurveUOnCurve(Evaluate Geometry(Point %d))(Evaluate Geometry(Curve %d))", asm_create_grid_off_created_ids )',pointid(end),dist,p2,p1,c1);