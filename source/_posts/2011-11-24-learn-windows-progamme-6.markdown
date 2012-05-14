---
layout: post
title: 'windows via c/c++ 笔记 （六）'
date: 2011-11-24
comments: true
categories: [tech, windows]
---
<h2>第10章 同步设备I/O与异步设备I/O</h2>
<span style="display:block;text-indent:2em;">打开设备：CreateFile(文件、目录、逻辑磁盘驱动器、物理磁盘驱动器、串口、并口、邮件槽[一对多数据传输]客户端、命名管道[一对一数据传输]客户端)、CreateMailslot、CreateNamedPipe、CreatePipe、Socket、CreateConsoleScreenBuffer,GetFileType</span>
<span style="display:block;text-indent:2em;">CreateFile 的高速缓存标志：FILE_FLAG_NO_BUFFERING(GetDiskFreeSpace扇区的整数倍)，FILE_FLAG_SEQUENTIAL_SCAN，FILE_FLAG_RANDOM_ACCESS，FILE_FLAG_WRITE_THROUGH</span>
<span style="display:block;text-indent:2em;">FILE_FLAG_DELETE_ON_CLOSE、FILE_FLAG_BACKUP_SEMANTICS、FILE_FLAG_OPEN_REPARSE_POINT、FILE_FLAG_OPEN_NO_RECALL、FILE_FLAG_OVERLAPPED</span>
``` cpp
HANDLE hFile = CreateFile(...);
if (hFile == NULL) {
   // We'll never get in here
} else {
   // File might or might not be created OK
}

//Here's the correct way to check for an invalid file handle:
HANDLE hFile = CreateFile(...);
if (hFile == INVALID_HANDLE_VALUE) {
   // File not created
} else {
   // File created OK
}
```
<span style="display:block;text-indent:2em;">GetFileSizeEx、GetCompressedFileSize、SetFilePointerEx、SetEndOfFile</span>
<span style="display:block;text-indent:2em;">执行同步设备I/O：ReadFile、WriteFile、FlushFileBuffers、CancelSynchronousIo</span>
<span style="display:block;text-indent:2em;">异步：OVERLAPPED结构、CancelIoEx</span>
<span style="display:block;text-indent:2em;">可提醒I/O：QueueUserApc(手动将一项添加到APC队列)、SleepEx、WaitForSingleObjectEx、WaitForMultipleObjectsEx、SignalObjectAndWait、GetQueuedCompletionStatusEx、MsgWaitForMultipleObjectsEx</span>
<span style="display:block;text-indent:2em;">I/O完成端口：CreateCompletionPort、GetQueuedCompletionStatus、PostQueuedCompletionStatus</span>
``` cpp
//为了只创建I/O完成端口，只需要设置第四个参数。dwNumberOfConcurrentThreads (并发线程数量) = 0，系统默认为CPU的数量
HANDLE CreateNewCompletionPort(DWORD dwNumberOfConcurrentThreads) {
   return(CreateIoCompletionPort(INVALID_HANDLE_VALUE, NULL, 0,
      dwNumberOfConcurrentThreads));
}
```
<span style="display:block;text-indent:2em;">FILE_FLAG_NO_BUFFERING标志要求：缓存的起始位置必须是扇区大小的整数倍，VirtualAlloc函数可以确保内存块的起始位置位于分配粒度的边界</span>

<!--more-->
<h2>第11章 Windows线程池</h2>
<span style="display:block;text-indent:2em;">异步调用函数：CreateThreadpoolWork、TrySubmitThreadpoolWork、SubmitThreadpoolWork、WaitForThreadpoolWorkCallbacks、CloseThreadpoolWork</span>
<span style="display:block;text-indent:2em;">每隔一段时间调用函数：CreateThreadpoolTimer、SetThreadpoolTimer、WaitForThreadpoolTimerCallbacks、IsThreadpoolTimerSet、CloseThreadpoolTimer</span>
<span style="display:block;text-indent:2em;">内核对象出发时调用函数：CreateThreadpoolWait、SetThreadpoolWait、CloseThreadpoolWait</span>
<span style="display:block;text-indent:2em;">异步I/O请求完成时调用函数：CreateThreadpoolIo、StartThreadpoolIo、CancelThreadpoolIo、CloseThreadpoolIo</span>
<span style="display:block;text-indent:2em;">the default thread pool has the minimum number of threads set to 1 and its maximum number of threads set to 500</span>

<h2>第12章 纤程</h2>
<span style="display:block;text-indent:2em;">尽量避免使用纤程</span>
<span style="display:block;text-indent:2em;">ConvertThreadToFiber(Ex)、CreateFiber(Ex)、SwitchToFiber、DeleteFiber、GetCurrentFiber、GetFiberData</span>
