
使用方法：修改需求里的内容，将需求和步骤内容作为指令让cursor进行执行。



需求：
1. 更新iOS MTPush SDK 到 x.x.x 版本
2. 更新Android MTPush SDK 到 x.x.x 版本
3. 将原生iOS、Android SDK 新增的方法，封装在插件中。
   原生SDK新增方法一：
   iOS ：
   
   ```
   ```
   
   Android:
   
   ```
   ```
   
    统一封装为 方法名为 "" 的对外方法。
    

请按照以下步骤完成：

1. 在ios/flutter_plugin_engagelab.podspec.podspec 中更新 iOS MTPush SDK 的版本依赖.
2. 在android/build.gradle 中 更新 Android MTPush SDK 的版本依赖
3. 在插件中封装需求中需要封装的SDK方法，并在插件示例demo中提供示例调用代码，在documents/APIs.md 补充新增的插件方法(英文)，并在cn-document/APIs.md中补充新增的插件方法(中文)（如果没有需求中没有需要新增的方法，则跳过该步骤）
4. 在pubspec.yaml中更新插件版本号，在现有版本号上 + 0.0.1。 版本号的命名规则为：插件版本号+安卓SDK版本号iosSDK版本号。
5. 在README.md 中 修改示例 插件的集成版本号。 改为最新的插件版本号。涉及到更改的代码

    ```
    dependencies:
       flutter_plugin_engagelab: x.x.x
    ```

6. 在CHANGELOG.md 中 更新 该插件本次的变更内容。
