#version 330 core
out vec4 FragColor;

// 片段着色器会从顶点着色器接受颜色向量，并将其设置为它的颜色输出，来实现四边形的颜色
in vec3 fColor;

void main()
{   
    FragColor = vec4(fColor, 1.0);
}