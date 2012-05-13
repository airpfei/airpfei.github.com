---
layout: post
title: 'windows via c/c++ 笔记 （二）'
date: 2011-11-12
comments: true
categories: [tech, windows]
---
第3章：内核对象
<span style="padding-left: 30px;">每个内核对象是一个内存块，由操作系统分配，并只能由操作系统内核访问。</span>
<span style="padding-left: 30px;">调用函数创建内核对象时，调用失败句柄值通常为NULL，有几个函数返回值为-1 INVALID_HANDLE_VALUE。用于创建内核对象的函数检查返回值时要谨慎。</span>
<span style="padding-left: 30px;">调用CloseHandle关闭内核对象时，应将内核对象的变量设为NULL。 </span>
<span style="padding-left: 30px;">Creat*，Open*</span>
<span style="padding-left: 30px;">共享内核对象：对象句柄继承，为对象命名，复制对象句柄</span>
<span style="padding-left: 30px;">sample为专有命名空间的单实例进程,03-Singleton</span>
