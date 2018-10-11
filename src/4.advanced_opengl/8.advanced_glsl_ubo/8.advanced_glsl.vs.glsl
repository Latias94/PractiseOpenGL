#version 330 core
layout (location = 0) in vec3 aPos;

// 声明了一个叫做Matrices的Uniform块，它储存了两个4x4矩阵。
// Uniform块中的变量可以直接访问，不需要加块名作为前缀。接下来
// 我们在OpenGL代码中将这些矩阵值存入缓冲中，每个声明了这个Uniform块的着色器都能够访问这些矩阵
// layout (std140) 代表当前定义的Uniform块对它的内容使用一个特定的内存布局
// 这个语句设置了Uniform块布局(Uniform Block Layout)
// Uniform块的内容是储存在一个缓冲对象中的，它实际上只是一块预留内存
// std140布局声明了每个变量的偏移量都是由一系列规则所决定的，这显式地声明了每个变量类型的内存布局
// 由于这是显式提及的，我们可以手动计算出每个变量的偏移量
layout (std140) uniform Matrices
{
    mat4 projection;
    mat4 view;
};
// 因为模型矩阵在不同的着色器中会不断改变，所以使用Uniform缓冲对象并不会带来什么好处
uniform mat4 model;

void main()
{
    gl_Position = projection * view * model * vec4(aPos, 1.0);
}  