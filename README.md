# Learning OpenGL
I am going through the learnopengl.com book with zig.
## Setting up
I used `zigglgen` for the opengl bindings for zig, `zglfw` for the glfw binding and `zstbi` for image/texture loading.
(There is also `zgl` but I had issues with loading proc adresses)
### zigglgen
`zig fetch --save git+https://github.com/ziglibs/zgl.git`
commit: f616514733b81e5b00cc2d839c83c8e529ff5c4f
### zglfw
You have to have the `libglfw3-dev` package installed.
`zig fetch --save git+https://github.com/ziglibs/zgl.git`
commit: f616514733b81e5b00cc2d839c83c8e529ff5c4f
### zstbi
The book uses the `stb_image.h` header but I found this zig version :)
`zig fetch --save git+https://github.com/zig-gamedev/zstbi`
commit:094c4bba5cdbec167d3f6aaa98cccccd5c99145f
