function [key1,key2]=create_mat1(name,E,G,rho,Xt,Yt,S)

key1=sprintf('material.create( "Analysis code ID", 1, "Analysis type ID", 1, "%s", 0, "", "Isotropic", 1, "Directionality", 1, "Linearity", 1, "Homogeneous", 0, "Linear Elastic", 1, "Model Options & IDs", ["", "", "", "", ""], [0, 0, 0, 0, 0], "Active Flag", 1, "Create", 10, "External Flag", FALSE, "Property IDs", ["Elastic Modulus", "Shear Modulus", "Density"], [2, 8, 16, 0], "Property Values", ["%f", "%f", "%f", ""] )',...
    name,E,G,rho);

key2=sprintf('material.create( "Analysis code ID", 1, "Analysis type ID", 1, "%s", 0, "", "Isotropic", 1, "Directionality", 1, "Linearity", 0, "Homogeneous", 0, "Failure", 4, "Model Options & IDs", ["Tsai-Wu", "", "", "", ""], [4, 0, 0, 0, 0], "Active Flag", 1, "Create", 10, "External Flag", FALSE, "Property IDs", ["Tension Stress Limit", "Compression Stress Limit", "Shear Stress Limit"], [99, 100, 101, 0], "Property Values", ["%f", "%f", "%f", ""] )',name,Xt,Yt,S);