#version 330 core
out vec4 FragColor;

uniform vec4 myColor; // set this in opengl code
void main()
{
    FragColor = myColor;
} 
