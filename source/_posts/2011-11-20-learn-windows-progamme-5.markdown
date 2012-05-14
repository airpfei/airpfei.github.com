---
layout: post
title: 'windows via c/c++ 笔记 （五）'
date: 2011-11-20
comments: true
categories: [tech, windows]
---
<h2>第8章：用户模式下的线程同步</h2>
<span style="display:block;text-indent:2em;">Interlocked系列函数，原子操作，使用时保证传给函数的变量是对齐的，否则可能会失效。_aligned_malloc</span>
<span style="display:block;text-indent:2em;">当一个CPU修改了Cache中一个字节时，其他收到通知，并使自己的Cache作废。应该把只读（不经常读）与可读写的数据分别存放。GetLogicalProcessorInformation,__declspec(align(#))对齐</span>
<span style="display:block;text-indent:2em;">volatile，优化器在用到这个变量时必须每次都小心地重新读取这个变量的值，而不是使用保存在寄存器里的备份。指针不受编译器的优化影响，必须从内存读取。</span>
<span style="display:block;text-indent:2em;">关键段：EnterCriticalSection、LeaveCriticalSection、InitializeCriticalSection、DeleteCriticalSection、CriticalSectionTimeout、TryEnterCriticalSection</span>
<span style="display:block;text-indent:2em;">当线程试图进入被占用的关键段，线程切换到等待状态。这意味着线程从用户模式切换到内核模式（大约 1000 个CPU；周期）。InitializeCriticalSectionAndSpinCount</span>
<span style="display:block;text-indent:2em;">条件变量：SleepConditionVariable*、WakeConditionVariable、WakeAllConditiongVariable</span>
<span style="display:block;text-indent:2em;">以原子方式操作一组对象时使用一个锁；同时访问多个逻辑资源，以相同的顺序获得锁的资源；不长时间占用锁</span>
<table linktabletoexcel="yes">
<caption class="table-title">
<span class="table-title">Comparison of Synchronization Mechanism Performance</span>
<br>
</caption>
<thead>
<tr valign="top">
<th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Threads\milliseconds</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Volatile Read</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Volatile Write</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Interlocked Increment</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Critical Section</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">SRWLock Shared</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">SRWLock Exclusive</b>
</p>
</th><th class="th" scope="col" align="left">
<p class="table-para">
<b class="bold">Mutex</b>
</p>
</th>
</tr>
</thead>
<tbody>
<tr valign="top">
<td class="td" align="left">
<p class="table-para">1</p>
</td><td class="td" align="left">
<p class="table-para">8</p>
</td><td class="td" align="left">
<p class="table-para">8</p>
</td><td class="td" align="left">
<p class="table-para">35</p>
</td><td class="td" align="left">
<p class="table-para">66</p>
</td><td class="td" align="left">
<p class="table-para">66</p>
</td><td class="td" align="left">
<p class="table-para">67</p>
</td><td class="td" align="left">
<p class="table-para">1060</p>
</td>
</tr>
<tr valign="top">
<td class="td" align="left">
<p class="table-para">2</p>
</td><td class="td" align="left">
<p class="table-para">8</p>
</td><td class="td" align="left">
<p class="table-para">76</p>
</td><td class="td" align="left">
<p class="table-para">153</p>
</td><td class="td" align="left">
<p class="table-para">268</p>
</td><td class="td" align="left">
<p class="table-para">134</p>
</td><td class="td" align="left">
<p class="table-para">148</p>
</td><td class="td" align="left">
<p class="table-para">11082</p>
</td>
</tr>
<tr valign="top">
<td class="td" align="left">
<p class="table-para">4</p>
</td><td class="td" align="left">
<p class="table-para">9</p>
</td><td class="td" align="left">
<p class="table-para">145</p>
</td><td class="td" align="left">
<p class="table-para">361</p>
</td><td class="td" align="left">
<p class="table-para">768</p>
</td><td class="td" align="left">
<p class="table-para">244</p>
</td><td class="td" align="left">
<p class="table-para">307</p>
</td><td class="td" align="left">
<p class="table-para">23785</p>
</td>
</tr>
</tbody>
</table>

<!--more-->
<h2>第9章：用内核对象进行线程同步</h2>

<span style="display:block;text-indent:2em;">WaitForSingleObject、WaitForMultipleObjects，内核对象被触发返回。等待成功引起的副作用，由于事件对象触发时，在返回WAIT_OBJECT_0前会使对象变为非触发状态</span>
```
HANDLE h[2];
h[0] = hAutoResetEvent1;   // Initially nonsignaled
h[1] = hAutoResetEvent2;   // Initially nonsignaled
WaitForMultipleObjects(2, h, TRUE, INFINITE);
```
<span style="display:block;text-indent:2em;">hAutoResetEvent1先触发，hAutoResetEvent2触发，两线程的一个检测到触发，系统把两个事件对象都设为未触发</span>
<span style="display:block;text-indent:2em;">事件内核对象：CreateEvent(Ex)、SetEvent、ResetEvent、PulseEvent(不经常使用)、OpenEvent(DuplicateHandle)。使用自动重置的对象，当对象被触发，系统只会让次要线程中的一个变为可调度状态，所以要在每个次要线程调用时使用SetEvent，否则其他次要线程将等待。</span>
<span style="display:block;text-indent:2em;">可等待的计时器内核对象：CreateWaitableTimer、SetWaitableTimer、CancelWaitableTimer、OpenWaitableTimer</span>
```
void SomeFunc() {
   // Create a timer. (It doesn't matter whether it's manual-reset
   // or auto-reset.)
   HANDLE hTimer = CreateWaitableTimer(NULL, TRUE, NULL);

   // Set timer to go off in 5 seconds.
   LARGE_INTEGER li = { 0 };
   SetWaitableTimer(hTimer, &amp;li, 5000, TimerAPCRoutine, NULL, FALSE);

   //APC异步函数被插入线程，线程恢复
   // Wait in an alertable state for the timer to go off.
   SleepEx(INFINITE, TRUE);

   CloseHandle(hTimer);
}
```
<span style="display:block;text-indent:2em;">信号量内核对象：CreateSemaphore、OpenSemaphore、ReleaseSemaphore</span>
<span style="display:block;text-indent:2em;">互斥量内核对象：CreateMutex、OpenMutex、RleaseMutex</span>
<span style="display:block;text-indent:2em;">WaitForInputIdle、MsgWaitForMultipleObjects(Ex)(用户界面相关的线程使用)、WaitForDebugEvent、SignalObjectAndWait(通过原子操作让一个内核对象等待另一个内核对象)</span>
<span style="display:block;text-indent:2em;">等待链遍历API检测死锁：ParseThreads、OpenThreadWaitChainSession、GetThreadChain</span>
