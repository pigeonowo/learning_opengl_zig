#version 330 core
layout (location = 0) in vec3 aPos;
layout (location = 1) in vec3 aColor;

out vec3 myColor;

void main()
{
    gl_Position = vec4(aPos.x * -1.0, aPos.y * -1.0, aPos.z, 1.0);
    myColor = aColor;
}
