# har 目录说明

本目录用于存放鸿蒙构建所需的 HAR 包（如 `flutter.har`）。

**`flutter.har` 由鸿蒙版 Flutter 的构建自动生成，请勿手动创建。**

## 首次构建 / 解决 "flutter.har does not exist" 的步骤

**注意**：`flutter build hap` 仅在 **鸿蒙版 Flutter**（OpenHarmony-SIG）中可用，标准 Flutter 无此命令，需先按 [鸿蒙版 Flutter 环境搭建](https://gitee.com/openharmony-sig/flutter_samples/blob/master/ohos/docs/03_environment/%E9%B8%BF%E8%92%99%E7%89%88Flutter%E7%8E%AF%E5%A2%83%E6%90%AD%E5%BB%BA%E6%8C%87%E5%AF%BC.md) 配置。

在 **example** 目录下先执行鸿蒙构建，生成 `har/flutter.har` 后，再在 `example/ohos` 下执行 `ohpm install`：

```bash
# 1. 进入 example 目录
cd example

# 2. 执行鸿蒙构建（需使用鸿蒙版 Flutter，会生成 ohos/har/flutter.har 等产物）
flutter build hap

# 3. 进入 ohos 目录并安装依赖
cd ohos
ohpm install
```

若已配置鸿蒙版 Flutter 环境，也可在 DevEco Studio 的 Terminal 中执行上述命令。

完成以上步骤后，再用 DevEco Studio 打开 `example/ohos` 进行开发或编译。
