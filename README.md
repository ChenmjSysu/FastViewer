# FastViewer
MacOS 图片浏览工具

## 开发环境
Swift 5<br/>
Xcode 11.3.1

## 图像窗口编辑
每个图像窗口对应一个WindowController和ViewController

在storyboard设置视图
1. 在View Controller Scene中将默认的View替换成Scroll View
2. 将Scroll View的view的class设置为CenteringClipView
3. 拖动一个ImageView到ClipView的View里面
4. 设置Constraint
- Ctrl-clik: View -> ClipView, Leading Sapce to Container && Top Space to Container
- Ctrl-click: View -> View, Width && Height
- Ctrl-click: View ImageView -> View, Center Horizontoally in Container && Center Vertically in Container && Equal Widths && Equal Heights
5. 添加Toolbar item，绑定事件

## TODO LIST
- ~~搭建整体框架~~ 2020.03.10
- 在collectionview显示文件夹，双击进入文件夹
- collectionview多选并显示图片
- 支持YUV
- 支持RAW图
- 支持视频