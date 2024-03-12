#指定要执行的优化遍数
-optimizationpasses 5

#混淆时不生成大小写混合的类名，即全部小写
-dontusemixedcaseclassnames

#指定不忽略非公共的库的类
-dontskipnonpubliclibraryclasses

#指定不忽略包可见的库类成员（字段和方法）。
-dontskipnonpubliclibraryclassmembers

#把混淆类中的方法名也混淆了，为需要混淆的类生成唯一的混淆名称
-useuniqueclassmembernames

#关闭预验证
-dontpreverify

# 打印过程日志，在处理期间输出更多信息
-verbose

#指定优化算法
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*

#关闭优化
-dontoptimize

#扩大类和类成员的访问权限，使优化时允许访问并修改有修饰符的类和类的成员
-allowaccessmodification

#保留那些需要被保留的方法的参数名字
-keepparameternames

#四大组件不被混淆
-keep public class * extends android.app.Activity
-keep public class * extends android.app.Service
-keep public class * extends android.content.BroadcastReceiver
-keep public class * extends android.content.ContentProvider

#将混淆堆栈跟踪文件来源重命名为“SourceFile”
-renamesourcefileattribute SourceFile

#保护注解。如果代码依赖注释，则可能需要保留注释
-keepattributes *Annotation*

#保留源文件名，变量名和行号，以产生有用的混淆堆栈跟踪
-keepattributes SourceFile,LineNumberTable

#保留异常，内部类/接口，泛型，Deprecated不推荐的方法
-keepattributes Exceptions,InnerClasses,Signature,Deprecated,EnclosingMethod

#保留R文件的静态成员，以使调用代码通过自省访问这些字段
-keepclassmembers class **.R$* {
   public static <fields>;
}

#Engagelab
-keep class com.engagelab.** {*;}
-dontwarn com.engagelab.**

#google
-keep class com.google.**{*;}
-dontwarn com.google.**

#huawei
-keep class com.huawei.**{*;}
-dontwarn com.huawei.**

#xiaomi
-keep class com.xiaomi.** {*;}
-dontwarn com.xiaomi.**

#meizu，如果使用R8混淆，可能会导致拿不到token
-keep class com.meizu.** {*;}
-dontwarn com.meizu.**

#oppo
-keep class com.heytap.** {*;}
-dontwarn com.heytap.**

#vivo
-keep class com.vivo.** {*;}
-dontwarn com.vivo.**

-ignorewarnings
-keepattributes *Annotation*
-keepattributes Exceptions
-keepattributes InnerClasses
-keepattributes Signature
-keepattributes SourceFile,LineNumberTable
-keep class com.huawei.hianalytics.**{*;}
-keep class com.huawei.updatesdk.**{*;}
-keep class com.huawei.hms.**{*;}
-keep class com.hihonor.push.**{*; }
