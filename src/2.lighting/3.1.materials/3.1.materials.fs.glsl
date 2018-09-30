#version 330 core
out vec4 FragColor;

struct Material{
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
    float shininess;
};

struct Light{
    vec3 position;
    vec3 ambient;
    vec3 diffuse;
    vec3 specular;
};

in vec3 Normal;  
in vec3 FragPos;  
  
// uniform vec3 lightPos; 变成 Light Struct 里面的 position
uniform vec3 viewPos; 
// uniform vec3 lightColor;
// uniform vec3 objectColor;
uniform Material material;
uniform Light light;

// 冯氏光照
void main()
{
    // ambient
    // float ambientStrength = 0.1;
    // vec3 ambient = ambientStrength * lightColor;
    vec3 ambient = light.ambient * material.ambient;
  	
    // diffuse 
    vec3 norm = normalize(Normal);
    // vec3 lightDir = normalize(lightPos - FragPos);
    vec3 lightDir = normalize(light.position - FragPos);
    float diff = max(dot(norm, lightDir), 0.0);
    // vec3 diffuse = diff * lightColor;
    vec3 diffuse = light.diffuse * (diff * material.diffuse);
    
    // specular
    // float specularStrength = 0.5;
    vec3 viewDir = normalize(viewPos - FragPos);
    vec3 reflectDir = reflect(-lightDir, norm);  
    // float spec = pow(max(dot(viewDir, reflectDir), 0.0), 32);
    float spec = pow(max(dot(viewDir, reflectDir), 0.0), material.shininess);
    // vec3 specular = specularStrength * spec * lightColor;  
    vec3 specular = light.specular * (spec * material.specular);  
        
    // vec3 result = (ambient + diffuse + specular) * objectColor;
    vec3 result = ambient + diffuse + specular;
    FragColor = vec4(result, 1.0);
} 