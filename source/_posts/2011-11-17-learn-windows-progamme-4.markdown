---
layout: post
title: 'windows via c/c++ 笔记 （四）'
date: 2011-11-17
comments: true
categories: [tech, windows]
---
第6章：线程基础
<span style="padding-left: 30px;">线程由两部分组成：内核对象和线程栈</span>
<span style="padding-left: 30px;">线程共享地址空间、共享内核对象句柄，因为句柄表是针对进程的</span>
<span style="padding-left: 30px;">多线程时可以采用static变量防止对象被销毁，但这会使函数不可重入。（不能创建两个线程执行同一个函数，因为两个线程共享同一个静态变量）</span>
<span style="padding-left: 30px;">ExitThread、TerminateThread、GetExitCodeThread</span>
<span style="padding-left: 30px;">使用_beginthreadex而不要用CreateThread，CreateThread不是线程安全的，ExitThread没用释放_tiddata(_endthreadex释放了)。_endthread在调用ExitThread前会调用CloseHandle，而_endthreadex不会。</span>
<span style="padding-left: 30px;">GetCurrentProcess、GetCurrentThread、GetCurrentProcessId、GetCurrentThreadId、DuplicateHandle用于把进程的伪句柄转换为真正的进程句柄</span>

<!--more-->
第7章：线程调度、优先级和关联性
<span style="padding-left: 30px;">ResumeThread、SuspendThread，当挂起数为0时，线程可调度</span>
<span style="padding-left: 30px;">WaitForDebugEvent挂起进程中所有线程，直至ContinueDebugEvent</span>
<span style="padding-left: 30px;">SwitchToThread与Sleep(0)类似，SwitchToThread允许执行低优先级的线程而Sleep不可以</span>
<span style="padding-left: 30px;">GetTickCount64、GetThreadTimes、GetProcessTimes、QueryThreadCycleTime、QueryProcessCycleTime、ReadTimeStampCounter、QueryPerformanceFrequency、QueryPerformanceCounter</span>
<span style="padding-left: 30px;">调用GetThreadContext前应调用SuspendThread否则可能会导致Context信息不一致</span>
<span style="padding-left: 30px;">SetPriorityClass、SetProcessPriorityBoost、SetThreadPriorityBoost</span>
<span style="padding-left: 30px;">SetProcessAffinityMask、GetProcessAffinityMask、SetThreadIdealProcessor关联性</span>
