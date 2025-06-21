const std = @import("std");
const glfw = @import("zglfw");
const gl = @import("gl");
const shader = @import("shader.zig");
const stb = @import("zstbi");

const WINDOW_WIDTH = 800;
const WINDOW_HEIGHT = 800;

const vertecies = [_]f32{
    0.5, 0.5, 0.0, 1.0, 0.0, 0.0, 1.0, 1.0, // top right
    0.5, -0.5, 0.0, 0.0, 1.0, 0.0, 1.0, 0.0, // bottom right
    -0.5, -0.5, 0.0, 0.0, 0.0, 1.0, 0.0, 0.0, // bottom left
    -0.5, 0.5, 0.0, 1.0, 1.0, 0.0, 0.0, 1.0, // top left
};

const indices = [_]u32{
    0, 1, 3, // first triangle
    1, 2, 3, // second triangle
};

pub fn main() void {
    const ally = std.heap.page_allocator;
    // init stb
    stb.init(ally);
    defer stb.deinit();
    // init glfw and window
    glfw.init() catch {
        std.io.getStdErr().writer().print("Failed to init GLFW", .{}) catch {};
        return;
    };
    defer glfw.terminate();
    glfw.windowHint(glfw.ContextVersionMajor, 3);
    glfw.windowHint(glfw.ContextVersionMinor, 3);
    glfw.windowHint(glfw.OpenGLProfile, glfw.OpenGLCoreProfile);
    const window = glfw.createWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "LearnOpenGL", null, null) catch {
        std.io.getStdErr().writer().print("Failed to create GLFW window", .{}) catch {};
        return;
    };
    glfw.makeContextCurrent(window);
    defer glfw.makeContextCurrent(null);
    // set viewport everytime it resizes (why does this return a function????)
    _ = glfw.setFramebufferSizeCallback(window, framebuffer_size_callback);
    // load opengl proc_addresses
    // this is very different from the book
    var gl_procs: gl.ProcTable = undefined;
    if (!gl_procs.init(glfw.getProcAddress)) {
        std.io.getStdErr().writer().print("Failed to load proc address", .{}) catch {};
        return;
    }
    gl.makeProcTableCurrent(&gl_procs);
    defer gl.makeProcTableCurrent(null);
    // set viewport
    gl.Viewport(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT);
    // shader :D
    var my_shader = shader.Shader.init("vertex.glsl", "fragment.glsl") catch {
        std.io.getStdOut().writer().print("Loading of shader failed", .{}) catch {};
        return;
    };
    // -- vao and vbo --
    // generate vao and vbo
    var vao: c_uint = undefined;
    var vbo: c_uint = undefined;
    var ebo: c_uint = undefined;
    gl.GenVertexArrays(1, @ptrCast(&vao));
    gl.GenBuffers(1, @ptrCast(&vbo));
    gl.GenBuffers(1, @ptrCast(&ebo));
    // bind vertex array object first
    gl.BindVertexArray(vao);
    // fill vbo
    gl.BindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(@TypeOf(vertecies)), @ptrCast(&vertecies), gl.STATIC_DRAW);
    // fill ebo
    gl.BindBuffer(gl.ELEMENT_ARRAY_BUFFER, ebo);
    gl.BufferData(gl.ELEMENT_ARRAY_BUFFER, @sizeOf(@TypeOf(indices)), @ptrCast(&indices), gl.STATIC_DRAW);
    // set vertex attributes
    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 8 * @sizeOf(f32), 0); // pointer = 0 = (*void)0
    gl.EnableVertexAttribArray(0);
    // set color attribute
    gl.VertexAttribPointer(1, 3, gl.FLOAT, gl.FALSE, 8 * @sizeOf(f32), 3 * @sizeOf(f32));
    gl.EnableVertexAttribArray(1);
    // set texture cord attribute
    gl.VertexAttribPointer(2, 2, gl.FLOAT, gl.FALSE, 8 * @sizeOf(f32), 6 * @sizeOf(f32));
    gl.EnableVertexAttribArray(2);

    // textures
    var texture1: c_uint = undefined;
    var texture2: c_uint = undefined;
    // texture 1
    gl.GenTextures(1, @ptrCast(&texture1));
    gl.BindTexture(gl.TEXTURE_2D, texture1);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT); // set texture wrapping to GL_REPEAT (default wrapping method)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    stb.setFlipVerticallyOnLoad(true);
    var img1 = stb.Image.loadFromFile("container.jpg", 0) catch |e| {
        std.io.getStdOut().writer().print("Loading of image failed: {?}", .{e}) catch {};
        return;
    };
    gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, @intCast(img1.width), @intCast(img1.height), 0, gl.RGB, gl.UNSIGNED_BYTE, @ptrCast(img1.data));
    gl.GenerateMipmap(gl.TEXTURE_2D);
    img1.deinit();
    // texture 2
    gl.GenTextures(1, @ptrCast(&texture2));
    gl.BindTexture(gl.TEXTURE_2D, texture2);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.REPEAT); // set texture wrapping to GL_REPEAT (default wrapping method)
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.REPEAT);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
    gl.TexParameteri(gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
    var img2 = stb.Image.loadFromFile("awesomeface.png", 0) catch |e| {
        std.io.getStdOut().writer().print("Loading of image failed: {?}", .{e}) catch {};
        return;
    };
    // RGB**A** because its transparent
    gl.TexImage2D(gl.TEXTURE_2D, 0, gl.RGB, @intCast(img2.width), @intCast(img2.height), 0, gl.RGBA, gl.UNSIGNED_BYTE, @ptrCast(img2.data));
    gl.GenerateMipmap(gl.TEXTURE_2D);
    img2.deinit();

    // set texture uniforms
    my_shader.use();
    my_shader.setInt("texture1", 0);
    my_shader.setInt("texture2", 1);

    // ---------------------------
    // LOOP
    while (!glfw.windowShouldClose(window)) {
        process_input(window);
        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);
        // bind textures
        gl.ActiveTexture(gl.TEXTURE0);
        gl.BindTexture(gl.TEXTURE_2D, texture1);
        gl.ActiveTexture(gl.TEXTURE1);
        gl.BindTexture(gl.TEXTURE_2D, texture2);
        // draw
        my_shader.use();
        gl.BindVertexArray(vao);
        gl.DrawElements(gl.TRIANGLES, 6, gl.UNSIGNED_INT, 0);

        glfw.swapBuffers(window);
        glfw.pollEvents();
    }
}

fn process_input(window: *glfw.Window) void {
    if (glfw.getKey(window, glfw.KeyEscape) == glfw.Press) {
        glfw.setWindowShouldClose(window, true);
    }
}

fn framebuffer_size_callback(window: *glfw.Window, w: c_int, h: c_int) callconv(.c) void {
    _ = window;
    // make sure int != < 0
    if (w < 0 or h < 0) @panic("Resize set width or height to under 0??");
    gl.Viewport(0, 0, w, h);
}
