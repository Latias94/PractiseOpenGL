#version 330 core
layout (location = 0) in vec2 aPos;
layout (location = 1) in vec3 aColor;
layout (location = 2) in vec2 aOffset; // 实例化数组

out vec3 fColor;

void main()
{
    // cpp 文件中传进来偏移量
//    gl_Position = vec4(aPos + aOffset, 0.0, 1.0);
    // 为了更有趣一点，我们也可以使用gl_InstanceID，从右上到左下逐渐缩小四边形 
    // (注意OpenGL的渲染方向，OpenGL 把屏幕的左下角当成最小的窗口坐标值)
    vec2 pos = aPos * (gl_InstanceID / 100.0);
    gl_Position = vec4(pos + aOffset, 0.0, 1.0);
    fColor = aColor;
}