# Maven

## 什么是maven

管理依赖的工具，编译打包发布工具。pom.xml文件



## 怎么创建一个maven工程

```shell
mvn archetype:generate 
```

idea创建maven工程

groupId, artifactId, version设置



## 怎么引用maven依赖

```xml
    <dependencies>
        <dependency>
            <groupId>com.heroku</groupId>
            <artifactId>webapp-runner</artifactId>
            <version>9.0.36.1</version>
        </dependency>
        
        
        ......
    </dependencies>
```



本地 .m2/repository/**com/heroku/webapp-runner/9.0.36.1/** 里面有jar包

本地没有，去maven中央仓库下载

https://repo1.maven.org/maven2/**com/heroku/webapp-runner/9.0.36.1/**



## 怎么运行maven的task

指定编译版本和编码规则

```xml
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.8.1</version>
                <configuration>
                    <target>11</target>
                    <source>11</source>
                    <encoding>UTF-8</encoding>
                </configuration>
            </plugin>
        </plugins>
    </build>

```

编译打包命令

```shell
mvn compile
mvn package

mvn compile package

# 先清除旧的class，然后在编译打包，package自带编译功能
mvn clean package

# install将本地工程打包放入repository
mvn install
```

指定打包类型

```xml
<!--    只能打一个-->

<!--    打jar包-->
    <packaging>jar</packaging>
<!--    打war包-->
    <packaging>war</packaging>
```





## Tomcat怎么运行一个web程序



创建 webapp/WEB-INF/web.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<web-app>
    
</web-app>
```



## 第一个Servlet程序

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<web-app xmlns="http://java.sun.com/xml/ns/j2ee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://java.sun.com/xml/ns/j2ee
   http://java.sun.com/xml/ns/j2ee/web-app_2_4.xsd"
         version="2.4">

    <!--    定义servlet名和class-->
    <servlet>
        <servlet-name>helloServlet</servlet-name>
        <servlet-class>com.hugang.HelloServlet</servlet-class>
    </servlet>
    <!--    定义servlet使用范围-->
    <servlet-mapping>
        <servlet-name>helloServlet</servlet-name>
        <url-pattern>/</url-pattern>
    </servlet-mapping>

</web-app>
```

```java
package com.hugang;

import javax.servlet.*;
import java.io.IOException;
import java.io.PrintWriter;

public class HelloServlet implements Servlet {
    static int count;

    @Override
    public void init(ServletConfig servletConfig) throws ServletException {
        //初期化是调用一次
    }

    @Override
    public ServletConfig getServletConfig() {
        return null;
    }

    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        //每次调用执行
        PrintWriter writer = servletResponse.getWriter();

        writer.println("<h1>");
        writer.println("you click "+(++count)+" times");
        writer.println("</h1>");

        writer.close();
    }

    @Override
    public String getServletInfo() {
        return null;
    }

    @Override
    public void destroy() {
        //停止服务时执行一次
    }
}
```



## Spring入门

web.xml追加listener

```xml
    <listener>
        <listener-class>org.springframework.web.context.ContextLoaderListener</listener-class>
    </listener>
    <context-param>
        <param-name>contextConfigLocation</param-name>
        <param-value>classpath*:beans.xml</param-value>
    </context-param>
```

beans.xml定义spring组件

```xml
<beans xmlns="http://www.springframework.org/schema/beans"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
       xsi:schemaLocation="http://www.springframework.org/schema/beans
           http://www.springframework.org/schema/beans/spring-beans-2.5.xsd">

    <bean id="userMysqlDao" class="com.hugang.service.UserMyssqlDao"/>
    <bean id="userServiceImpl" class="com.hugang.service.UserServiceImpl" name="user1,user2,user3">
        <property name="name" value="hugang"/>
        <property name="userDao" ref="userMysqlDao"/>
    </bean>
    <bean id="applicationContextProvider" class="com.hugang.ApplicationContextProvider"/>

    <bean id="xiaoming" class="com.hugang.service.Student">
        <constructor-arg name="id" value="1001"/>
        <constructor-arg name="name" value="小明"/>
    </bean>
    <bean id="xiaohong" class="com.hugang.service.Student">
        <constructor-arg name="id" value="1002"/>
        <constructor-arg name="name" value="小红"/>
        <property name="description" value="xiao hong is a girl"/>
    </bean>

</beans>
```

ApplicationContextProvider继承ApplicationContextAware获取Spring容器

```java
package com.hugang;

import org.springframework.beans.BeansException;
import org.springframework.context.ApplicationContext;
import org.springframework.context.ApplicationContextAware;

public class ApplicationContextProvider implements ApplicationContextAware {
    public static ApplicationContext context;

    @Override
    public void setApplicationContext(ApplicationContext applicationContext) throws BeansException {
        context = applicationContext;
    }

    public static ApplicationContext getContext() {
        return context;
    }
}
```

获取对象

```java
    @Override
    public void service(ServletRequest servletRequest, ServletResponse servletResponse) throws ServletException, IOException {
        ApplicationContext context = ApplicationContextProvider.getContext();
        UserServiceImpl userServiceImp = (UserServiceImpl) context.getBean("userServiceImpl");
        userServiceImp.getUser();
    }
```