[![ru](https://img.shields.io/badge/lang-ru-green.svg)](https://github.com/OSPanel/SystemPreparationTool/blob/main/README.ru.md)

# System Preparation Tool

A tool for preparing the Windows operating system to work with an [Open Server Panel](https://ospanel.io).\
To compile the application yourself, you need to install [Inno Setup Compiler](https://jrsoftware.org/download.php/is.exe).

## Installations (required)

* Microsoft Visual C++ Redistributable packages

## Changes to access settings

* Removing access restrictions to the HOSTS file (+ restoring the file in case of its absence)

## Automatic optimizations (required, hidden, non-switchable)

* Setting the timeout after which the application is considered to be frozen, equal to 30 seconds
* Disabling the automatic shutdown of hung applications
* Disabling the 260-character path length limit
* Setting the following order of domain name resolution: local cache, HOSTS file, DNS, NetBT
* Setting standard DNS timeouts
* Setting IPv4 priority over IPv6 when resolving domain names
* Enabling Prefetcher (also enabled by default in Windows). In new operating systems, the SysMain service performs the function of optimizing memory consumption: page combining and memory compression.
* Disabling Large System Cache (also disabled by default in Windows). Prohibits the operating system from using all RAM for the cache of system files, which allows you to provide Open Server Panel modules with more available RAM.
* Disabling the cleanup of the swap file when the system is turned off (it is also turned off by default in Windows). When the computer is turned off, data is being intensively written to disk and the Open Server Panel requires as many resources as possible to correctly and quickly close running processes.

## Optimizations performed for SSD drives

* Disabling the creation of names in the outdated MS-DOS format (8.3)
* Enabling the TRIM command

##  System requirements

**Operating System:** Windows 7 SP1 x64 / Windows Server 2008 R2 SP1 x64 or later
