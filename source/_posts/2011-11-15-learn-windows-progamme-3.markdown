---
layout: post
title: 'windows via c/c++ 笔记 （三）'
date: 2011-11-15
comments: true
categories: [tech, windows]
---
<h2>第4章：进程</h2>
<span style="display:block;text-indent:2em;">进程由内核对象和地址空间组成</span>
<span style="display:block;text-indent:2em;">(w)WinMain的hInstanceExe参数是可执行文件的映像加载到内存的基址；</span>
<span style="display:block;text-indent:2em;">HMODULE和HINSTANCE是一样的，由于win16导致函数名不同；</span>
<span style="display:block;text-indent:2em;">__ImageBase连接器提供的伪变量，指向当前运行模块的基地址</span>
span style="display:block;text-indent:2em;">GetModuleHandle(NULL)返回进程地址空间中可执行文件的基地址，而非DLL的基地址</span>
```
//使用HeapFree释放内存
PWSTR *ppArgv = CommandLineToArgvW(GetCommandLineW(), &amp;nNumArgs);
// Use the arguments…
if (*ppArgv[1] == L'x') {
   ...
}
// Free the memory block
HeapFree(GetProcessHeap(), 0, ppArgv);
```
<span style="display:block;text-indent:2em;">GetEnvironmentStrings、FreeEnvironmentStrings，环境变量，读注册表HKEY_CURRENT_USER_ENVIRONMENT</span>
<span style="display:block;text-indent:2em;">SetErrorMode告诉系统如何处理错误</span>
<span style="display:block;text-indent:2em;">目录名、文件名MAX_PATH=260</span>
<span style="display:block;text-indent:2em;">GetCurrrentDirectory、SetCurrentDirectory、GetFullPathName</span>
```
PROCESS_INFORMATION pi;
DWORD dwExitCode;
// Spawn the child process.
BOOL fSuccess = CreateProcess(..., &amp;pi);
if (fSuccess) {
   // Close the thread handle as soon as it is no longer needed!
   //！！！递减子进程的主线程内核对象使用计数。使系统能够正常释放子进程
   CloseHandle(pi.hThread);
   // Suspend our execution until the child has terminated.
   WaitForSingleObject(pi.hProcess, INFINITE);
   // The child process terminated; get its exit code.
   GetExitCodeProcess(pi.hProcess, &amp;dwExitCode);
   // Close the process handle as soon as it is no longer needed.
   CloseHandle(pi.hProcess);
}
// 运行独立的子进程
BOOL fSuccess = CreateProcess(..., &amp;pi);
if (fSuccess) {
   // Allow the system to destroy the process &amp; thread kernel
   // objects as soon as the child process terminates.
   CloseHandle(pi.hThread);
   CloseHandle(pi.hProcess);
}
```
<!--more-->
<br />
<h2>第5章：作业</h2>
<span style="display:block;text-indent:2em;">Windows提供了作业（Job）内核对象，将进城组合在一起并创建一个“沙箱”来限制进程</span>
<span style="display:block;text-indent:2em;">如果未定义manifest或debug，windows资源管理器会将进程同“PCA”前缀的作业关联，可以从cmd启动进程</span>
<span style="display:block;text-indent:2em;">CreateJobObject、OpenJobObject、UserHandleGrantAccess、SetInformationJobObject、AssignProcessToJobObject、TerminateJobObject、QueryInformationJobObject、GetQueuedCompletionStatus</span>
