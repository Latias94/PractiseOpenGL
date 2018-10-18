#version 330 core
layout (location = 0) in vec3 aPos;

uniform mat4 model;

// 几何着色器是负责将所有世界空间的顶点变换到6个不同的光空间的着色器
// 因此顶点着色器简单地将顶点变换到世界空间，然后直接发送到几何着色器
void main()
{
    gl_Position = model * vec4(aPos, 1.0);
}