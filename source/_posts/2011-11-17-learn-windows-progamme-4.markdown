---
layout: post
title: 'windows via c/c++ 笔记 （四）'
date: 2011-11-17
comments: true
categories: [tech, windows]
---
<h2>第6章：线程基础</h2>
<span style="display:block;text-indent:2em;">线程由两部分组成：内核对象和线程栈</span>
<span style="display:block;text-indent:2em;">线程共享地址空间、共享内核对象句柄，因为句柄表是针对进程的</span>
<span style="display:block;text-indent:2em;">多线程时可以采用static变量防止对象被销毁，但这会使函数不可重入。（不能创建两个线程执行同一个函数，因为两个线程共享同一个静态变量）</span>
<span style="display:block;text-indent:2em;">ExitThread、TerminateThread、GetExitCodeThread</span>
<span style="display:block;text-indent:2em;">使用_beginthreadex而不要用CreateThread，CreateThread不是线程安全的，ExitThread没用释放_tiddata(_endthreadex释放了)。_endthread在调用ExitThread前会调用CloseHandle，而_endthreadex不会。</span>
<span style="display:block;text-indent:2em;">GetCurrentProcess、GetCurrentThread、GetCurrentProcessId、GetCurrentThreadId、DuplicateHandle用于把进程的伪句柄转换为真正的进程句柄</span>

<!--more-->
<h2>第7章：线程调度、优先级和关联性</h2>
<span style="display:block;text-indent:2em;">ResumeThread、SuspendThread，当挂起数为0时，线程可调度</span>
<span style="display:block;text-indent:2em;">WaitForDebugEvent挂起进程中所有线程，直至ContinueDebugEvent</span>
<span style="display:block;text-indent:2em;">SwitchToThread与Sleep(0)类似，SwitchToThread允许执行低优先级的线程而Sleep不可以</span>
<span style="display:block;text-indent:2em;">GetTickCount64、GetThreadTimes、GetProcessTimes、QueryThreadCycleTime、QueryProcessCycleTime、ReadTimeStampCounter、QueryPerformanceFrequency、QueryPerformanceCounter</span>
<span style="display:block;text-indent:2em;">调用GetThreadContext前应调用SuspendThread否则可能会导致Context信息不一致</span>
<span style="display:block;text-indent:2em;">SetPriorityClass、SetProcessPriorityBoost、SetThreadPriorityBoost</span>
<span style="display:block;text-indent:2em;">SetProcessAffinityMask、GetProcessAffinityMask、SetThreadIdealProcessor关联性</span>
