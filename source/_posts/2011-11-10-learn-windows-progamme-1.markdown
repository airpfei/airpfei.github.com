---
layout: post
title: 'windows via c/c++ 笔记 （一）'
date: 2011-11-10
comments: true
categories: [tech, windows]
---
<h2>第1章：错误处理</h2>
<span style="display:block;text-indent:2em;">调用GetLastError() 查看错误信息；</span>
<span style="display:block;text-indent:2em;">$err,hr 在watch窗口查看错误信息</span>

<h2>第2章：字符和字符串的处理</h2>
<span style="display:block;text-indent:2em;">字符串前的“L”告诉编译器该字符串为Unicode字符串；</span>
<span style="display:block;text-indent:2em;">windows内部由Unicode字符构建，优先使用Unicode编码；</span>
<span style="display:block;text-indent:2em;">CreateWindowExW (wide)接受Unicode编码，CreateWindowExA接受ANSI编码</span>
<span style="display:block;text-indent:2em;">使用CompareStringOrdinal、CompareString(Ex)比较字符串；</span>
<span style="display:block;text-indent:2em;">使用MultiByteToWideChar、WideCharToMultiByte进行Unicode、ANSI编码转换</span>
