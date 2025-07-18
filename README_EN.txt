* README_EN.txt
* 2025.07.17
* userbin

1. DESCRIPTION
2. REPOSITORIES
3. PREREQUISITES
4. DEPENDENCIES
5. USAGE
6. PROJECT CONFIGURATION VARIABLES
7. AUTHOR

-------------------------------------------------------------------------------
1. DESCRIPTION
-------------------------------------------------------------------------------
User scripts accessible from the `PATH` variable.

-------------------------------------------------------------------------------
2. REPOSITORIES
-------------------------------------------------------------------------------
Primary:
  * https://github.com/andry81/userbin/branches
    https://github.com/andry81/userbin.git
First mirror:
  * https://sf.net/p/userbin/userbin/ci/master/tree
    https://git.code.sf.net/p/userbin/userbin
Second mirror:
  * https://gitlab.com/andry81/userbin/-/branches
    https://gitlab.com/andry81/userbin.git

-------------------------------------------------------------------------------
3. PREREQUISITES
-------------------------------------------------------------------------------
Currently used these set of OS platforms and repositories:

1. OS platforms:

* Windows XP+

2. Repositories:

* contools--admin
  You must put the repository working copy into the
  `$PROJECTS_ROOT/andry81/contools/contools--admin` directory.

-------------------------------------------------------------------------------
4. DEPENDENCIES
-------------------------------------------------------------------------------
* contools--admin

-------------------------------------------------------------------------------
5. USAGE
-------------------------------------------------------------------------------
Put `userbin` working copy into the directory of the root of your git
repositories directory:

<root>
 |
 +- andry81
 |   |
 |   +- userbin
 |       |
 |       +- userbin
 |

NOTE:
  Some scripts basically wrappers to scripts from a dependent project.
  To read the usage description you must open the corresponding dependent
  project script.

Put `contools--admin` a working copy root directory into the directory of
the root of your git repositories directory:

<root>
 |
 +- andry81
 |   |
 |   +- contools
 |       |
 |       +- contools--admin
 |

Create `PROJECTS_ROOT` environment variable with path to your git repositories
directory:

>
PROJECTS_ROOT=<root>

Put `userbin` a working copy scripts directory into the `PATH` variable:

>
set PATH=%PATH%;%PROJECTS_ROOT%\andry81\userbin\userbin\scripts\bat

-------------------------------------------------------------------------------
6. PROJECT CONFIGURATION VARIABLES
-------------------------------------------------------------------------------
To be able to use the scripts you have to declare the set of environment
variables. Here is described only a limited set of variables, you have to open
each corresponding script to find out which one variable you must to define.

* PROJECTS_ROOT

  Main environment variable to access a tree of repositories.

-------------------------------------------------------------------------------
7. AUTHOR
-------------------------------------------------------------------------------
Andrey Dibrov (andry at inbox dot ru)
