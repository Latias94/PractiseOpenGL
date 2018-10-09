#version 330 core
out vec4 FragColor;

in vec2 TexCoords;

uniform sampler2D screenTexture;

// 核效果 卷积用的 offset
const float offset = 1.0 / 300.0;  

void main()
{
    // vec3 col = texture(screenTexture, TexCoords).rgb;
    // 不加屏幕后处理
    // FragColor = vec4(col, 1.0);
    
    // 后期处理
    // 既然整个场景都被渲染到了一个纹理上，我们可以简单地通过修改纹理数据创建出一些非常有意思的效果
    
    // 1. 反相
    // FragColor = vec4(1.0 - col, 1.0);
    
    // 2. 灰度 移除场景中除了黑白灰以外所有的颜色，让整个图像灰度化(Grayscale)。
    // 很简单的实现方式是，取所有的颜色分量，将它们平均化
//    float average = (col.r + col.g + col.b) / 3.0;
    // 人眼会对绿色更加敏感一些，而对蓝色不那么敏感，所以为了获取物理上更精确的效果，我们需要使用加权的(Weighted)通道
    // 在更复杂的场景中，这样的加权灰度效果会更真实一点
//    float average = 0.2126 * col.r + 0.7152 * col.g + 0.0722 * col.b;
//    FragColor = vec4(average, average, average, 1.0);
    
    // 3. 核效果
    vec2 offsets[9] = vec2[](
        vec2(-offset,  offset), // 左上
        vec2( 0.0f,    offset), // 正上
        vec2( offset,  offset), // 右上
        vec2(-offset,  0.0f),   // 左
        vec2( 0.0f,    0.0f),   // 中
        vec2( offset,  0.0f),   // 右
        vec2(-offset, -offset), // 左下
        vec2( 0.0f,   -offset), // 正下
        vec2( offset, -offset)  // 右下
    );

    // 3.1 锐化(Sharpen)核，它会采样周围的所有像素，锐化每个颜色值。
//    float kernel[9] = float[](
//        -1, -1, -1,
//        -1,  9, -1,
//        -1, -1, -1
//    );

    // 3.2 模糊(Blur)效果的核
    // 由于所有值的和是16，所以直接返回合并的采样颜色将产生非常亮的颜色，所以我们需要将核的每个值都除以16
    // 我们可以随着时间修改模糊的量，创造出玩家醉酒时的效果，或者在主角没带眼镜的时候增加模糊。模糊也能够让我们来平滑颜色值，我们将在之后教程中使用到。
//    float kernel[9] = float[](
//        1.0 / 16, 2.0 / 16, 1.0 / 16,
//        2.0 / 16, 4.0 / 16, 2.0 / 16,
//        1.0 / 16, 2.0 / 16, 1.0 / 16  
//    );

    // 3.3 边缘检测
    float kernel[9] = float[](
        1, 1, 1,
        1, -8, 1,
        1, 1, 1
    );

    // 在采样时我们将每个偏移量加到当前纹理坐标上，获取需要采样的纹理
    // 之后将这些纹理值乘以加权的核值，并将它们加到一起。
    vec3 sampleTex[9];
    for(int i = 0; i < 9; i++)
    {
        sampleTex[i] = vec3(texture(screenTexture, TexCoords.st + offsets[i]));
    }
    vec3 col = vec3(0.0);
    for(int i = 0; i < 9; i++)
        col += sampleTex[i] * kernel[i];

    FragColor = vec4(col, 1.0);

} 