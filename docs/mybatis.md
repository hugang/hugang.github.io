# Mybatis

## ORM持久层框架

## 安装

```xml
        <dependency>
            <groupId>org.mybatis</groupId>
            <artifactId>mybatis</artifactId>
            <version>3.5.5</version>
        </dependency>
```

## 主配置文件

```xml
<!-- mybatis-config.xml -->
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE configuration
        PUBLIC "-//mybatis.org//DTD Config 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-config.dtd">

<configuration>
    <environments default="dev">
        <environment id="dev">
            <transactionManager type="JDBC"/>
            <dataSource type="POOLED">
                <property name="driver" value="org.postgresql.Driver"/>
                <property name="url" value="jdbc:postgresql://localhost:5432/gitea"/>
                <property name="username" value="gitea"/>
                <property name="password" value="gitea"/>
            </dataSource>
        </environment>
    </environments>

    <mappers>
        <mapper resource="xml/users.xml"/>
    </mappers>

</configuration>

```



## Mapper接口和xml文件

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE mapper
        PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.hugang.UserMapper">
    <select id="selectOne" resultType="com.hugang.Users">
        select id,name,salary from users where id=1
    </select>
</mapper>

```

```java
package com.hugang;

public interface UserMapper {
    //定义接口，和xml设定名称一致
    Users selectOne();
}

```

## 使用

```java
    @Test
    public void test01() throws IOException {
        //程序主配置文件
        String resource = "mybatis-config.xml";
        //通过InputStream流 读入配置文件，生成sqlSessionFactory
        InputStream is = Resources.getResourceAsStream(resource);
        SqlSessionFactory sqlSessionFactory = new SqlSessionFactoryBuilder().build(is);
        //开启sql会话
        SqlSession sqlSession = sqlSessionFactory.openSession();
        //获取对象接口 xml-> interface -> sqlSession.getMapper
        UserMapper userMapper = sqlSession.getMapper(UserMapper.class);
        //执行sql
        Users users = userMapper.selectOne();
        System.out.println(users);
    }
```