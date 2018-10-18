#version 330 core
in vec4 FragPos;

uniform vec3 lightPos;
uniform float far_plane;

// 我们将计算自己的深度，这个深度就是每个fragment位置和光源位置之间的线性距离
// 计算自己的深度值使得之后的阴影计算更加直观
void main()
{
    // 像素着色器将来自几何着色器的FragPos、光的位置向量和视锥的远平面值作为输入
    float lightDistance = length(FragPos.xyz - lightPos);
    
    // map to [0;1] range by dividing by far_plane
    // 这里我们把fragment和光源之间的距离，映射到0到1的范围，把它写入为fragment的深度值
    lightDistance = lightDistance / far_plane;
    
    // write this as modified depth
    // 使用这些着色器渲染场景，立方体贴图附加的帧缓冲对象激活以后，你会得到一个完全填充的深度立方体贴图，以便于进行第二阶段的阴影计算
    gl_FragDepth = lightDistance;
}