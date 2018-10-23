#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D hdrBuffer;
uniform bool hdr;
uniform float exposure;

// 渲染至浮点帧缓冲和渲染至一个普通的帧缓冲是一样的
// 新的东西就是这个的hdrShader的片段着色器，用来渲染最终拥有浮点颜色缓冲纹理的2D四边形
void main()
{             
    const float gamma = 2.2;
    vec3 hdrColor = texture(hdrBuffer, TexCoords).rgb;
    if(hdr)
    {
        // 色调映射(Tone Mapping)是一个损失很小的转换浮点颜色值至我们所需的LDR[0.0, 1.0]范围内的过程
        // 通常会伴有特定的风格的色平衡(Stylistic Color Balance)
        // 有了Reinhard色调映射的应用，我们不再会在场景明亮的地方损失细节
        // 当然，这个算法是倾向明亮的区域的，暗的区域会不那么精细也不那么有区分度
        // reinhard
        // vec3 result = hdrColor / (hdrColor + vec3(1.0));
        
        // 另一个有趣的色调映射应用是曝光(Exposure)参数的使用
        // 你可能还记得之前我们在介绍里讲到的，HDR图片包含在不同曝光等级的细节
        // 如果我们有一个场景要展现日夜交替，我们当然会在白天使用低曝光，在夜间使用高曝光，就像人眼调节方式一样
        // 有了这个曝光参数，我们可以去设置可以同时在白天和夜晚不同光照条件工作的光照参数，我们只需要调整曝光参数就行了
        // 举例来说，高曝光值会使隧道的黑暗部分显示更多的细节，然而低曝光值会显著减少黑暗区域的细节，但允许我们看到更多明亮区域的细节
        // 曝光色调映射
        vec3 result = vec3(1.0) - exp(-hdrColor * exposure);
        // also gamma correct while we're at it  
        // Gamma校正      
        result = pow(result, vec3(1.0 / gamma));
        FragColor = vec4(result, 1.0);
    }
    else
    {
        vec3 result = pow(hdrColor, vec3(1.0 / gamma));
        FragColor = vec4(result, 1.0);
    }
}