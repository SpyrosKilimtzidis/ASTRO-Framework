# ASTRO

**Aircraft Surrogate-Based Structural Optimization Framework**

ASTRO is a MATLAB-based computational framework for the surrogate-assisted structural optimization of full-aircraft configurations. The framework supports parametric geometry generation and component-wise thickness sizing for wing, fuselage, and tail structures. It couples MATLAB-driven preprocessing with Patran/NASTRAN finite element models, SDPM aerodynamic load generation, static and buckling analyses, flutter constraints, and surrogate-based optimization.

<p align="center">
  <img src="aircraft_struct_symm.png" width="800">
</p>

<p align="center">
  <em>Symmetric full-aircraft structural model used in the ASTRO framework.</em>
</p>

This repository accompanies the work:

*A Novel Surrogate-Assisted Structural Optimization Framework for Full-Aircraft Configurations*  
Featured at **AIAA SciTech 2026**.

## Overview

ASTRO provides an automated workflow for full-aircraft structural sizing and optimization. The framework is designed to support multidisciplinary structural design studies involving geometry parametrization, finite element model generation, aerodynamic loading, structural analysis, aeroelastic constraints, surrogate modeling, and optimization.

The general workflow is:

```text
Design variables
      ↓
Parametric geometry generation
      ↓
Patran/NASTRAN finite element model generation
      ↓
Boundary conditions and load case definition
      ↓
SDPM aerodynamic load generation
      ↓
Static, buckling, and flutter analyses
      ↓
Surrogate model construction
      ↓
Surrogate-based optimization
      ↓
Post-processing and optimized aircraft sizing
