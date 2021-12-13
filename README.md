# BASH_Procesos_Usuarios_userProc
BASH script to show the number of processes of the system users

1. Basic function 

The basic operation is that if no option is specified, it shows a list with all the users who have at least a process with a 
consumed CPU time greater than N, where if no parameter N is passed it will be 1 second, with the parameter -t N we will 
indicate the time from which the processes will be displayed. The list is ordered by username.

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/Default.png)

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/time_option.png)

2. Only users with conexion

With the option -usr it will only show users who are currently logged in to the system.

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/usr_option.png)

3. Filter by user

With the option -u you can select the users to display:

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/u_option.png)

only if these users exist on your system:

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/user_no_existe.png)

4. Number of processes per user

With the -count option, the number of processes per user that meet the runtime conditions will be obtained

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/count_option.png)

5. Changes in ordering

With the following options, the behavior of the sort can be modified:
  -inv: Sorting will be done in reverse.
  -pid: Sorting will be done by pid.
  
![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/inv_option.png)

![alt text](https://raw.githubusercontent.com/feichay10/BASH_Procesos_Usuarios_userProc/master/assets/pid_option.png)

All options can be used simultaneously and combine their performance






