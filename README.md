# Learning OpenGL
I am going through the learnopengl.com book with zig.
## Setting up
I used `zigglgen` for the opengl bindings for zig, `zglfw` for the glfw binding and `zstbi` for image/texture loading.
(There is also `zgl` but I had issues with loading proc adresses)
### zigglgen
`zig fetch --save git+https://github.com/castholm/zigglgen`
commit: d5f381759825ee0bac29bc294d47aa05be4ab7b5
### zglfw
You have to have the `libglfw3-dev` package installed.
`zig fetch --save git+https://github.com/IridescenceTech/zglfw`
commit: 5d25d66b3d4912c9cb66e4db9dfb80a6eecc84ad
### zstbi
The book uses the `stb_image.h` header but I found this zig version :)
`zig fetch --save git+https://github.com/zig-gamedev/zstbi`
commit:094c4bba5cdbec167d3f6aaa98cccccd5c99145f
