---
layout: post
title: 'java nio demo'
date: 2011-11-13
comments: true
categories: [tech, java]
---
<span style="display:block;text-indent:2em;">J2SE1.4中引入了新I/O库(NIO)来解决这个问题。NIO使用面向缓冲(buffer)的模型。这就是说，NIO主要处理大块的数据。这就避免了利用流模型处理所引起的问题，在有可能的情况下，它甚至可以为了得到最大的吞吐量而使用系统级的工具。</span>

<!--more-->
```
import java.io.IOException;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.nio.ByteBuffer;
import java.nio.channels.*;
import java.util.Set;

public class TestChannel {
    public static void main(String args[]) throws IOException{
        TestChannel tt=new TestChannel();
        //tt.initServerChannel(992);
        tt.initSelector(992);
    }

    //最初的java  socket实现方式，直接通过serversocket和socket通信
    public void initServerSocket(int port) throws IOException{
        ServerSocketChannel ssc=ServerSocketChannel.open();
        //ssc.configureBlocking(false);
        ServerSocket ss=new ServerSocket(port);
        while(true){
            Socket socket=ss.accept();
                System.out.println(&quot;socket accepted&quot;);
                byte[] buf=new byte[1024];
                try{
                socket.getInputStream().read(buf);
                }
                catch(Exception ex){
                    socket.close();
                }
                System.out.println(new String(buf));

        }
    }
    //通过Channel实现的non-blocking通信方式
    public void initServerChannel(int port) throws IOException{
        ServerSocketChannel ssc=ServerSocketChannel.open();
        ssc.configureBlocking(false);
        ServerSocket ss=ssc.socket();
        ss.bind(new InetSocketAddress(port));
        while(true){
            SocketChannel sc=ssc.accept();
            if(sc!=null){
                Socket socket=sc.socket();
                System.out.println(&quot;socket accepted&quot;);
                byte[] buf=new byte[1024];
                try{
                socket.getInputStream().read(buf);
                }
                catch(Exception ex){
                    socket.close();
                }
                System.out.println(new String(buf));
            }
        }
    }
    //通过selector和channel进行multiplexed通信,像mina就是通过这种方式实现的
    public void initSelector(int port) throws IOException{
        Selector selector=Selector.open();
        //register server channel
        ServerSocketChannel ssc=ServerSocketChannel.open();
        ssc.configureBlocking(false);
        ServerSocket ss=ssc.socket();
        ss.bind(new InetSocketAddress(port));
        ssc.register(selector, SelectionKey.OP_ACCEPT);
        while(true){
            int interestNo=selector.select();
            if(interestNo==0)
                continue;
            Set keys=selector.selectedKeys();
            for(SelectionKey key:keys){
                //接受Socket连接请求
                if(key.isAcceptable()){
                    SocketChannel sc=ssc.accept();
                    try{
                    sc.configureBlocking(false);
                    sc.register(selector, SelectionKey.OP_READ);
                    }
                    catch(Exception ex){
                        sc.close();
                    }
                    System.out.println(&quot;connection accepted&quot;);
                    keys.remove(key);
                }
                else if(key.isReadable()){
                    SocketChannel sc=(SocketChannel)key.channel();
                    ByteBuffer bbuf=ByteBuffer.allocate(1024);
                    try{
                    sc.read(bbuf);
                    }
                    catch(Exception ex){
                        sc.close();
                    }
                    System.out.println(new String(bbuf.array()));
                    keys.remove(key);
                }
                else
                    keys.remove(key);
                    continue;

                }
            }
        }
    }
// client:

//Java代码
public class TestChannelClient {
public static void main(String args[]) throws UnknownHostException, IOException{
    Socket sc=new Socket(&quot;127.0.0.1&quot;,992);
    OutputStream out=sc.getOutputStream();
    out.write(&quot;hello&quot;.getBytes());
    out.flush();
}
}
```
