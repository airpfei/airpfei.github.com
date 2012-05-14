---
layout: post
title: 'windows via c/c++ 笔记 （八）'
date: 2011-12-9
comments: true
categories: [tech, windows]
---
<h2>第19章 DLL基础</h2>
<span style="display:block;text-indent:2em;">一般在dll中分配的内存，都需要通过dll释放</span>
<span style="display:block;text-indent:2em;">DLL若连接的是静态版本，那么DLL的代码里面就会有一份free和malloc的代码，若EXE也使用的是静态版本的C/C++运行库，那么也会有另一份代码。当然你使用DLL代码里申请的内存不能在EXE的free代码中释放。原因是因为有两个不通的堆管理，在EXE中查不到相应申请的内存，自然释放会失败。</span>
<span style="display:block;text-indent:2em;">导出函数或变量，链接器生成lib文件。</span>
<span style="display:block;text-indent:2em;">dumpbin -exports \*.dll</span>
<span style="display:block;text-indent:2em;">dumpbin -imports \*.exe</span>
<span style="display:block;text-indent:2em;">避免MS VC++的名字粉碎(Name Mangling)：.def文件EXPORTS段导出函数名；extern "C"；#pragma comment (linker, "/export:MyFunc=_MyFunc@8")</span>
<span style="display:block;text-indent:2em;">导入：__declspec(dllimport)或使用extern</span>
<span style="display:block;text-indent:2em;">运行可执行模块：操作系统加载程序为进程创建虚拟地址空间，把可执行模块映射到进程的地址空间中。之后加载程序会检查可执行模块的导入段(不同版本的dll可能在这个步骤出问题)，对所需的DLL进行定位并将其映射到进程的地址空间中。</span>
<span style="display:block;text-indent:2em;">基址重定位和绑定可以加快应用程序初始化速度。</span>
<h2>第20章 DLL高级技术</h2>
<span style="display:block;text-indent:2em;">LoadLibrary(Ex)、FreeLibrary、FreeLibraryAndExitThread、GetModuleHandle、GetModuleFileName</span>
<span style="display:block;text-indent:2em;">GetProcAddress</span>
<span style="display:block;text-indent:2em;">DllMain的序列化调用。DisableThreadLibraryCalls</span>
<span style="display:block;text-indent:2em;">延迟载入DLL：当我们的代码试图引用DLL包含的符号时载入DLL。加快初始化速度；解决老版本DLL没有一些函数的问题。</span>
<span style="display:block;text-indent:2em;">一个导出全局变量的DLL、Kernel32.dll无法延迟加载。不应在DllMain中调用延迟加载的函数。</span>
<span style="display:block;text-indent:2em;">VcppException延迟载入DLL异常处理，DelayLoadInfo</span>
<span style="display:block;text-indent:2em;">函数转发器：#pragma comment (linker, "/export:SomeFunc=Dllwork.SomeOtherFunc")</span>
<span style="display:block;text-indent:2em;">模块的基地址重定位，显著提高整个系统的性能。/FIXED不包含重定位段。</span>
<span style="display:block;text-indent:2em;">模块的绑定，提高性能，不必再对模块重新定位，不必查看导入函数的虚拟地址。</span>
<h2>第21章 线程局部存储区</h2>
<span style="display:block;text-indent:2em;">动态TSL：TlsAlloc、TlsSetValue、TlsGetValue、TlsFree</span>
<span style="display:block;text-indent:2em;">静态TLS：__declspec(thread)</span>
<h2>第22章 DLL注入和API拦截</h2>
<span style="display:block;text-indent:2em;"><a href="http://www.codeproject.com/KB/system/inject2it.aspx" target="_blank">Demo</a></span>
<span style="display:block;text-indent:2em;">SetWindowLongPtr。从根本上将，DLL注入是目标进程中的一个线程调用LoadLibrary载入我们想要的DLL。</span>
<span style="display:block;text-indent:2em;">使用注册表注入DLL：只会映射到使用Use32.dll的进程中</span>
<span style="display:block;text-indent:2em;">使用Windows挂钩注入DLL：SetWindowsHookEx、UnhookWindowsHookEx。使用PostThreadMessage线程同步。</span>
<span style="display:block;text-indent:2em;">使用远程线程注入DLL：CreateRemoteThread、VirtualAllocEx、VirtualFreeEx、ReadProcessMemory、WriteProcessMemory</span>

<h2>结构化异常处理</h2>
<span style="display:block;text-indent:2em;">__try中使用return、goto、longjump，__finally中的代码也会被执行。</span>
<span style="display:block;text-indent:2em;">__try, __finally 框架会使finally中的代码执行</span>
<span style="display:block;text-indent:2em;">__leave关键字会使执行代码跳转到try块的结尾。</span>
