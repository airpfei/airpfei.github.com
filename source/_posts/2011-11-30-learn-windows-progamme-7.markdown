---
layout: post
title: 'windows via c/c++ 笔记 （七）'
date: 2011-11-30
comments: true
categories: [tech, windows]
---
<h2>第13章 Windows内存体系结构</h2>
<span style="display:block;text-indent:2em;">need reread</span>
<span style="display:block;text-indent:2em;">空指针赋值分区、用户模式分区、64KB禁入分区、内核模式分区</span>
<span style="display:block;text-indent:2em;">32位App运行在64位Windows分配的0x00000000'7FFFFFFF以下的地址空间，64位App默认在0x00000000'80000000以上的地址空间</span>
<span style="display:block;text-indent:2em;">系统会确保VirtualAlloc预订的地址区域的起始地址是分配粒度(allocation granularity)的整数倍</span>
<span style="display:block;text-indent:2em;">一个块是一些连续的页面</span>

<h2>第14章 探索虚拟内存</h2>
<span style="display:block;text-indent:2em;">系统信息：GetSystemInfo、GetLogicalProcessorInformation、IsWow64Process、GetCurrentProcess</span>
<span style="display:block;text-indent:2em;">虚拟内存状态：GlobalMemoryStatus(Ex)</span>
<span style="display:block;text-indent:2em;">NUMA机器中的内存管理：GetNumaAvailableMemoryNode、GetNumaProcessNode、GetNumaHighestNodeNumber、GetNumaNodeProcessorMask</span>
地址空间的状态：VirtualQuery(Ex)
<span style="display:block;text-indent:2em;">/dynamicbase  进程共享ASLR基址重定向的页面</span>
<h2>第15章 在应用程序中使用虚拟内存</h2>
<span style="display:block;text-indent:2em;">虚拟内存：管理大型对象数组或大型数据结构数组</span>
<span style="display:block;text-indent:2em;">内存映射文件：管理大型数据流，多进程共享数据</span>
<span style="display:block;text-indent:2em;">堆：管理大量小型对象</span>
<span style="display:block;text-indent:2em;">VirtualAlloc、VirtualFree、VirtualQuery、VirtualProtect</span>
地址窗口扩展(AWE)(使用物理内存，提高性能)：AllocateUserPhysicalPages、MapUserPhysicalPages、FreeUserPhysicalPages

<h2>第16章 线程栈</h2>
<span style="display:block;text-indent:2em;">SetThreadStackGuarante</span>

<!--more-->

<h2>第17章 内存映射文件</h2>
<span style="display:block;text-indent:2em;">映射到内存的EXE和DLL</span>
<span style="display:block;text-indent:2em;">一个应用程序的多个实例共享内存中的代码和数据，避免一个实例修改全局变量导致错误，系统通过内存管理的写时复制特性防止此发生。数据写写入时，系统会为其开辟一块新的内存。</span>
<span style="display:block;text-indent:2em;">#pragma data_seg("name") 用来创建名为"name"的段，该段内的数据必须初始化，否则数据不属于该段</span>
<span style="display:block;text-indent:2em;">allocate允许将未初始化的数据放入莫个段中</span>
<span style="display:block;text-indent:2em;">为数据创建单独的段是为了多个实例共享数据。编译选项/SECTION:name,attributes。#pragma comment(linker, "SECTION:Shared, RWS")</span>
<span style="display:block;text-indent:2em;">_tscrev颠倒文件数据(0结尾)</span>
<span style="display:block;text-indent:2em;">CreateFile(失败为NULL或INVALID_HANDLE_VALUE) --> CreateFileMapping (告诉系统映射文件需要多大的物理内存) --> MapViewOfFile --> UnmapViewOfFile --> FlushViewOfFile --> CloseHandle</span>
<span style="display:block;text-indent:2em;">MoveMemory</span>
<span style="display:block;text-indent:2em;">只读文件适合用于内存映射文件。可写文件不适合(无法保证一致性)，应独占文件(dwShareMode = 0)。</span>
<span style="display:block;text-indent:2em;">以页交换文件为后备存储器的内存映射文件：CreateFileMapping时hFile = INVALID_HANDLE_VALUE</span>
<span style="display:block;text-indent:2em;">稀疏调拨的内存映射文件：CreateMapping时传入SEC_RESERVE标志，系统不会从页交换文件中调拨物理存储器。然后使用VirtualAlloc调拨物理内存</span>
<h2>第18章 堆</h2>
<span style="display:block;text-indent:2em;">GetProcessHeap获取进程默认堆句柄。默认堆只允许一个线程访问。</span>
<span style="display:block;text-indent:2em;">HeapCreate、HeapAlloc、HeapSize、HeapFree、HeapDestroy</span>
<span style="display:block;text-indent:2em;">GetProcessHeaps、HeapValidate、HeapCompact、HeapLock、HeapUnlock、HeapWalk</span>
