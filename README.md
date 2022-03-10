# BASH_Procesos_Usuarios_userProc
BASH script to show the number of processes of the system users

## Table of Contents
1. [Basic function](#basic-function).
2. [Only users with connection](#only-users-with-connection)
3. [Filter by user](#filter-by-user)
4. [Number of processes per user](#number-of-processes-per-user)
5. [Changes in ordering](#changes-in-ordering)

### 1. Basic function 

The basic operation is that if no option is specified, it shows a list with all the users who have at least a process with a 
consumed CPU time greater than N, where if no parameter N is passed it will be 1 second, with the parameter `-t N` we will 
indicate the time from which the processes will be displayed. The list is ordered by username.

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/Default.png" />
</p>

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/time_option.png" />
</p>

### 2. Only users with connection

With the option `-usr` it will only show users who are currently logged in to the system.

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/usr_option.png" />
</p>

### 3. Filter by user

With the option `-u` you can select the users to display:

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/u_option.png" />
</p>

only if these users exist on your system:

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/user_no_existe.png" />
</p>

### 4. Number of processes per user

With the `-count` option, the number of processes per user that meet the runtime conditions will be obtained:

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/count_option.png" />
</p>

### 5. Changes in ordering

With the following options, the behavior of the sort can be modified:

  `-inv`: Sorting will be done in reverse.
  
  `-pid`: Sorting will be done by pid.
  
<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/inv_option.png" />
</p>

<p align="center">
  <img src="https://github.com/feichay10/BASH_Procesos_Usuarios_userProc/blob/38c24f2c2c6ab0a0e902210d8c4dd453ed261fe5/assets/pid_option.png" />
</p>

All options can be used simultaneously and combine their performance






