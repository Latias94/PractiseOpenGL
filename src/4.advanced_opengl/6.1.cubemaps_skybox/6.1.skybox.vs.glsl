#version 330 core
layout (location = 0) in vec3 aPos;

out vec3 TexCoords;

uniform mat4 projection;
uniform mat4 view;

void main()
{
    TexCoords = aPos;
    // 提前深度测试(Early Depth Testing) 轻松丢弃掉的片段能够节省我们很多宝贵的带宽
    // 天空盒只是一个1x1x1的立方体，它很可能会不通过大部分的深度测试，导致渲染失败。
    // 不用深度测试来进行渲染不是解决方案，因为天空盒将会复写场景中的其它物体。
    // 我们需要欺骗深度缓冲，让它认为天空盒有着最大的深度值1.0，只要它前面有一个物体，深度测试就会失败。
    // 透视除法是在顶点着色器运行之后执行的，将gl_Position的xyz坐标除以w分量。
    // 从深度测试小节中知道，相除结果的z分量等于顶点的深度值。使用这些信息，我们可以将输出位置的z分量等于它的w分量
    // 让z分量永远等于1.0，这样子的话，当透视除法执行之后，z分量会变为w / w = 1.0。
    // 最终的标准化设备坐标将永远会有一个等于1.0的z值：最大的深度值。
    vec4 pos = projection * view * vec4(aPos, 1.0);
    gl_Position = pos.xyww;
}  