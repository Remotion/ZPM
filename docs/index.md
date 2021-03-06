# Welcome to ZPM
ZPM is the C++ package manager built for everyone who uses [premake](http://premake.github.io/)!  
We designed it to make it easy to use **libraries**, **modules** and **assets**.

# Status
OS          | Status
----------- | -------
Linux & OSX | [![Build Status](https://travis-ci.org/Zefiros-Software/ZPM.svg?branch=master)](https://travis-ci.org/Zefiros-Software/ZPM)
Windows     | [![Build status](https://ci.appveyor.com/api/projects/status/88je1aj7pbb0un0y?svg=true)](https://ci.appveyor.com/project/PaulVisscher/zpm)

## Why ZPM?

* **Easy, cross-platform** package manager
* Integrates with [premake5](http://premake.github.io/)
* Both for using and publishing packages.
* All Git repositories supported, even **private** repositories.
* For packages, premake5 modules, and assets.
* Assets may be hosted using [Git LFS](https://git-lfs.github.com/), and from urls.
* Optionally separating the ZPM package and build files.
* Git tags for versioning.

----

## Installation
ZPM installs in your path and makes it easy to use and update premake.  
To install, pick your os and execute the command!

### Prerequisites
ZPM has a few dependencies:

* Git: Download [here](https://git-scm.com/downloads).
* Git LFS: Check install instructions [here](https://git-lfs.github.com/).


!!! alert-warning "Warning"
    Note that both Git and Git LFS need to be available from the command line, and thus need to be installed in your path variable. You can check by typing `git --version` in your shell.

### Windows
Execute:
```
powershell -command "Invoke-WebRequest -Uri https://raw.githubusercontent.com/Zefiros-Software/ZPM/master/script/install-zpm.bat -OutFile %TEMP%/install-zpm.bat" && %TEMP%/install-zpm.bat && set PATH=%PATH%;%ALLUSERSPROFILE%/zpm
```

!!! alert-danger "Note"
    A restart may be required since the `path` variable has changed.

### Linux
Execute:
```
wget -O - https://raw.githubusercontent.com/Zefiros-Software/ZPM/master/script/install-zpm.sh | bash
```

### OSX
Execute:
```
wget -O - https://raw.githubusercontent.com/Zefiros-Software/ZPM/master/script/install-zpm-osx.sh | bash
```

### Travis
Execute:
```
install:
    - wget -O - https://raw.githubusercontent.com/Zefiros-Software/ZPM/master/script/install-zpm-travis.sh | bash
```

### AppVeyor
Execute:
```
install:
    - powershell -command "Invoke-WebRequest -Uri https://goo.gl/1Zcf72 -OutFile %TEMP%/install-zpm.bat" && %TEMP%/install-zpm.bat 
    - "SET PATH=%PATH%;%ALLUSERSPROFILE%/zpm"
```

## Testing
Test whether you get output similar to underneath when you run `premake5 --version`.
<p align="center"><img src="images/version-check.gif" alt="ZPM Install Check"></p>

##

----

## Bugs
When a bug is found, please insert it in the issue tracker, so we can resolve it as quickly as we can.

## Contributing
1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## Authors
* Mick van Duijn <m.vanduijn@zefiros.eu>
* Paul Visscher <p.e.visscher@zefiros.eu>
* Koen Visscher <k.m.visscher@zefiros.eu>

----

## Citing ZPM
When you use ZPM as part of a scientific publication, we would love you to cite this project so the word gets spread. This BibTex snippet can be used:

```
@misc{zpm2016,
  author    = {Mick van Duijn and Koen Visscher and Paul Visscher},
  title     = {{ZPM}: the {C++} package manager built for everyone who uses \url{(http://premake.github.io/}.},
  abstract  = {{ZPM} is the {C++} package manager built for everyone who uses \url{http://premake.github.io/}! {ZPM} is designed to make it easy to use libraries, modules and assets.},
  howpublished = {\url{http://zpm.zefiros.eu/}}
}
```

## License
This project is licensed under the MIT license by [Zefiros Software](https://zefiros.eu).

```
Copyright (c) 2017 Zefiros Software.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```