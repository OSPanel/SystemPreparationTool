[![ru](https://img.shields.io/badge/lang-ru-green.svg)](https://github.com/OSPanel/SystemPreparationTool/blob/main/README.ru.md)

# System Preparation Tool

A tool for preparing the Windows operating system to work with an [Open Server Panel](https://ospanel.io).\
To compile the application yourself, you need to install [Inno Setup Compiler](https://jrsoftware.org/download.php/is.exe).

## Installations (required)

* Microsoft Visual C++ Redistributable packages 2005-2022

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

***

# Инструмент подготовки системы

Инструмент для подготовки операционной системы Windows к работе с [Open Server Panel](https://ospanel.io).\
Для самостоятельной компиляции приложения необходимо установить [Inno Setup Compiler](https://jrsoftware.org/download.php/is.exe).

##  Выполняемые установки (обязательные)

* Microsoft Visual C++ Redistributable packages 2005-2022

##  Изменения настроек доступа

* Снятие ограничений доступа к файлу HOSTS (+ восстановление файла в случае его отсутствия)

##  Автоматические оптимизации (обязательные, скрытые, неотключаемые)

* Установка таймаута, после которого приложение считается зависшим, равным 30-ти секундам
* Отключение автоматического завершения зависших приложений
* Отключение ограничения на длину пути в 260 символов
* Установка следующего порядка разрешения доменных имён: локальный кэш, файл HOSTS, DNS, NetBT
* Установка стандартных таймаутов DNS
* Установка приоритета IPv4 над IPv6 при разрешении доменных имён
* Включение Prefetcher (по умолчанию в Windows также включено). В новых операционных системах служба SysMain выполняет функцию оптимизации потребления памяти: объединение страниц памяти (page combining) и сжатие памяти (memory compression).
* Отключение Large System Cache (по умолчанию в Windows также выключено). Запрещает операционной системе использовать всю оперативную память для кэша системных файлов, что позволяет предоставить модулям Open Server Panel больше доступной оперативной памяти.
* Отключение очистки файла подкачки при выключении системы (по умолчанию в Windows также выключено). В момент выключения компьютера идёт интенсивная запись данных на диск и Open Server Panel требуется как можно больше ресурсов для корректного и быстрого закрытия запущенных процессов.

##  Выполняемые оптимизации для SSD-накопителей

* Отключение создания имён в устаревшем формате MS-DOS (8.3)
* Включение команды TRIM

##  Системные требования

**Операционная система:** Windows 7 SP1 x64 / Windows Server 2008 R2 SP1 x64 или новее
