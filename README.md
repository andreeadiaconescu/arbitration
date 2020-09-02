Wager Social Learning fMRI Study
================================

Master Thesis of Madeline Stecy (Sep 2015 - Feb 2016)
- Supervisor: Andreea Diaconescu
- Supervisor and Sponsor: Philippe Tobler
- Contributors: Lars Kasper, Christoph Mathys, Chris Burke, Zoltan Nagy
- Code Review: Lars Kasper

In total, 40 subjects were scanned and analyzed at the SNS lab in Zurich.

This repository contains the code for
- fMRI preprocessing of the data (SPM 12)
    - in particular, batch reporting of preprocessing quality
- behavioral modeling via the HGF
- physiological noise modeling via the PhysIO toolbox
- integration of behav/phys models into SPM GLM estimation

Installation
------------

Via GitHub:
- Clone this repository *recursively*, e.g., via `git clone --recursive https://github.com/andreeadiaconescu/arbitration`
    - This makes sure to have all the dependencies (external toolboxes) in place
    - If you don't have access to some of these dependencies, please proceed as described below manually
    
Manual Installation:
- Download this repository as a zip file
- Download all listed dependencies from the respective toolbox website and move them to the `Toolboxes` subdirectory of this code

Getting Started
---------------
Run `startup.m` in the main code folder to set up the environment and `wagad_main.m` to run the analysis.


Dependencies
------------

This code uses the following external toolboxes, all licensed under GPL.

- Hierarchical Gaussian Filter (HGF) for behavioral computational modeling of the wager task
- PhysIO Toolbox for physiological noise correction in fMRI
- SPM12 for fMRI Preprocessing and Statistical Parametric Mapping


License
-------

This code is licensed under GNU Public License Version 3 (GPLv3) or later, please see LICENSE file for details.

