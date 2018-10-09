# Learn OpenGL by LearnOpenGL
通过 [https://learnopengl.com](https://learnopengl.com) 练习 OpenGL。  

## 注意
系统环境为 Windows 10 x64  
IDE: Clion  
有些库是在 win10 下编译的，所以在其他平台运行要注意依赖的问题。  
assimp 编译了几个版本，总是报错说找不到方法，因此放弃第三章内容...

编译生成的文件都会在根目录的bin文件夹下，如果你修改了shader文件后执行没效果，就在bin文件夹下找到对应的shader文件并将其删除，让程序重新复制新的shader文件过去编译。

官方的源代码在 src/backup 文件夹下，食用时可以对照参考代码实现。

运行依赖与环境基于教程官方的仓库 [LearnOpenGL](https://github.com/JoeyDeVries/LearnOpenGL)。