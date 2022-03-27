# 设计模式

## 单例模式

```java
//饿汉模式，JVM加载该类时，直接生成对象
public class Singleton01 {
	// 设置构造函数为私有，避免直接new对象
	private Singleton01() {
	}

	// 生成对象
	private static final Singleton01 INSTANCE = new Singleton01();

	// 提供获取对象接口
	public static Singleton01 getInstance() {
		return INSTANCE;
	}
}


//懒汉模式 JVM加载类时不初始化，知道使用时才初始化实例
public class Singleton02 {
	// 禁止直接初始化
	private Singleton02() {
	}

	// 定義成員变量
	private static Singleton02 INSTANCE;

	// 提供获取接口
	public static Singleton02 getInstance() {
		//双重验证，提高效率
		if (null == INSTANCE) {
			//加把锁
			synchronized (Singleton02.class) {
				if (null == INSTANCE) {
					INSTANCE = new Singleton02();
				}
			}
		}
		
		return INSTANCE;
	}
}

//静态内部类方式 在调用时初始化静态内部类中的实例，兼顾效率和安全
public class Singleton03 {
	private Singleton03() {
	}

	public static Singleton03 getInstance() {
		return InstanceHolder.INSTANCE;
	}

	private static class InstanceHolder {
		private static final Singleton03 INSTANCE = new Singleton03();
	}
}


//枚举类型的单例
public enum Singleton04 {
	INSTANCE;

	public static Singleton04 getInstance() {
		return INSTANCE;
	}
}

```