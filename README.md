# WndAndMenuHook
This was a try to intercept windows from 1S7 applications.

Project consist of two parts. Sorry for the "My" prefix...:
1. MyHookDLL1 - Win32 DLL to hook CBT events in all applications of the session it runs on;
2. Project1 - the application itself. It can search for visible and unvisible windows and their system menus.
Also it can wait for windows activation events using MyHookDLL1.
Additionaly it has some functions to run 1S:Enterprise v7.7 (local file DB version for now, at it just doesen't
know file names for "network" and "SQL" version...) in "designer" mode and save it's configuration tructure description into
a text file.

It was started when I didn't knew anything about OLE server of 1S, and tried to teach my program to pull database structure
in such way to read data from DBase files directly. This remained unfinished.
