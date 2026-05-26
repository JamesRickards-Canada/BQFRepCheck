# BQFRepCheck
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.1003149.svg)](https://doi.org/10.5281/zenodo.18089403)

This repository contains code to computationally check which integers can be represented by a shifted binary quadratic form, comparing it to the theoretical statement in Theorems 2 and 3 of "Primes of the type ϕ(x,y)+A where ϕ is a quadratic form", by Iwaniec, which can be found [here](http://matwbn.icm.edu.pl/ksiazki/aa/aa21/aa21118.pdf).

Ensuring the correctness of the tables and correcting the minor errors was critical for the proofs in the paper [Primes represented by shifted quadratic forms: on primitivity and congruence classes](https://doi.org/10.4064/aa250502-24-10) (Arxiv [link](https://doi.org/10.48550/arXiv.2504.20289)), by Fuchs, Hsu, Rickards, Schindler, and Stange.

## Bibtex
If you use this code in a project, please let me know! Here is a Bibtex entry that points to the latest version. You may wish to update the version number to the one you used.
```
@software{BQFRepCheckCode,
	AUTHOR = {Rickards, James},
	DOI = {10.5281/zenodo.18089403},
	LICENSE = {GPL-3.0},
	TITLE = {{BQFRepCheck}},
	URL = {https://github.com/JamesRickards-Canada/BQFRepCheck},
	YEAR = {2026},
	VERSION = {1.0.2},
}
```

## Using the code
Start gp and load the files with ```gp quadratic bqfcheck```. The tests we claim in our paper can be accomplished with
```
dl = disclist(-1000, 1000);
for (i = 1, #dl, test_thm2(dl[i], -100000, 100000));
```
Any contradictions to the tables will produce an output. If the method does not print anything and finishes, all tests were passed.

## Installation Instructions

### Downloading the code
Call ```git clone https://github.com/JamesRickards-Canada/BQFRepCheck.git```. If you are on Windows, be sure to git clone from WSL (see below), as Windows line endings (carriage returns) may be added to files, causing issues.

### Prerequisites
* PARI/GP, but _not_ the downloaded ready-to-go binary. The PARI/GP website has binaries for Windows and Mac avaliable, but these will not work with the package. See below for OS specific instructions.
* You should have a guess as to the location of the ```pari.cfg``` file for the version of PARI/GP you are running. Suggestions on how to do this can be found below.
* This package has been tested on versions:
<p align="center"> 2.15.3 - 2.15.5, &emsp; 2.17.0 - 2.17.3, &emsp; 2.18.1</p>
If you try to use it on a different version, be aware that it may not work.

### Operating systems
* **Linux** - No further requirements
* **Windows** - You need to use Windows Subsytem for Linux. See the [guide](https://pari.math.u-bordeaux.fr/PDF/PARIGP-Windows.pdf) I wrote for additional instructions.
* **Mac** - You need to have [Homebrew](https://brew.sh/) installed. This is also an easy way to install PARI/GP: ```brew install pari```

### Configuring and building the package
* From inside the project folder, call ```./configure``` to initialize the project. This helps you search for ```pari.cfg```, and stores the location to a file. You should supply it with a folder to search in!
* The script displays the corresponding versions of the found files, so if you have multiple versions, you can choose the correct one. This can be useful if you keep multiple copies of PARI/GP around.
* If the location of the installation of PARI/GP does not change, you do not need to reconfigure. If when you update PARI/GP there is a new location (e.g. if the version number is in the file path of ```pari.cfg```), you should call ```./configure``` again.
* Call ```make``` to build the project, and ```make clean``` to remove all .o object files. If you update to a new version of PARI/GP, you must ```make clean``` and then ```make``` again.

### Where is pari.cfg?
* The configuration file will search for this, but it is preferrable to not search your entire hard drive (as this can be very slow). So, you should at least supply a guess as to the location of ```pari.cfg```. Often only the top-level folder (e.g. ```/usr``` or ```/opt```) suffices.
* On Linux or WSL, if you build PARI/GP from source, it should be located in ```/usr/local/lib/pari/pari.cfg```, or at least somewhere in the ```/usr``` folder.
* On a Mac, if you install PARI/GP with Homebrew, it may be found in a folder like ```/opt/homebrew/Cellar/pari/VERSION/lib/pari```. Searching ```/opt/homebrew``` should be fine.
* If you are obtaining it through SageMath, it might be found where the library files of SageMath are
* Assuming you open PARI/GP with the command ```gp```, try ```type -a gp```, which will display where this command lives. The corresponding file(s) are likely symbolic links, and you can call ```readlink -f LOCATION``` on each of them to see where it lives. This can provide a clue as to the place to search for ```pari.cfg```.
* Another clue comes from gp itself. Open gp, and type ```default()```. Look for the entries ```datadir``` and ```help```. It is _often_ the case that ```datadir``` is in ```X/share/pari```, ```help``` is in ```X/bin/gphelp```, and ```pari.cfg``` is in ```X/lib/pari/pari.cfg```.

### Troubleshooting
* If you are encoutering unexpected errors or warnings when building, ensure you found the correct ```pari.cfg``` file. You need to configure the project with the same installation of PARI/GP that you will run it with.
* If you change versions of PARI/GP, the package needs to be rebuilt: ```make clean``` to reset the object files, reconfigure with ```./configure```, and then run ```make``` again.
* When in doubt, rebuild the project as above to troubleshoot.
* If you have any further issues with installation or using the code, please let me know!
