const std = @import("std");
const glfw = @import("zglfw");
const gl = @import("gl");

const triangle = [_]f32{
    0.0, 0.5, 0.0, // top
    -0.5, -0.5, 0.0, // bottom left
    0.5, -0.5, 0.0, // bottom right
};

const vertex_shader = @embedFile("vertex.glsl");
const fragment_shader = @embedFile("fragment.glsl");

pub fn main() void {
    // init glfw and window
    glfw.init() catch {
        std.io.getStdErr().writer().print("Failed to init GLFW", .{}) catch {};
        return;
    };
    defer glfw.terminate();
    glfw.windowHint(glfw.ContextVersionMajor, 3);
    glfw.windowHint(glfw.ContextVersionMinor, 3);
    glfw.windowHint(glfw.OpenGLProfile, glfw.OpenGLCoreProfile);
    const window = glfw.createWindow(800, 600, "LearnOpenGL", null, null) catch {
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
    gl.Viewport(0, 0, 800, 600);
    // ----- PREPARE SHADER -------
    // vertex shader
    const vshader: c_uint = gl.CreateShader(gl.VERTEX_SHADER);
    gl.ShaderSource(vshader, 1, @ptrCast(&vertex_shader), null);
    gl.CompileShader(vshader);
    var success: c_int = undefined;
    var info_log: [512]u8 = undefined;
    gl.GetShaderiv(vshader, gl.COMPILE_STATUS, &success);
    if (success == 0) {
        gl.GetShaderInfoLog(vshader, 512, null, &info_log);
        std.io.getStdErr().writer().print("Failed to compile Vertex shader\n{s}", .{info_log}) catch {};
        return;
    }
    // fragment shader
    const fshader: c_uint = gl.CreateShader(gl.FRAGMENT_SHADER);
    gl.ShaderSource(fshader, 1, @ptrCast(&fragment_shader), null);
    gl.CompileShader(fshader);
    gl.GetShaderiv(fshader, gl.COMPILE_STATUS, &success);
    if (success == 0) {
        gl.GetShaderInfoLog(fshader, 512, null, &info_log);
        std.io.getStdErr().writer().print("Failed to compile Fragment shader\n{s}", .{info_log}) catch {};
        return;
    }
    // shader program for triangle
    const shader_prog = gl.CreateProgram();
    gl.AttachShader(shader_prog, vshader);
    gl.AttachShader(shader_prog, fshader);
    gl.LinkProgram(shader_prog);
    gl.GetProgramiv(shader_prog, gl.LINK_STATUS, &success);
    if (success == 0) {
        gl.GetProgramInfoLog(shader_prog, 512, null, &info_log);
        std.io.getStdErr().writer().print("Failed to create shader program\n{s}", .{info_log}) catch {};
        return;
    }
    gl.DeleteShader(vshader);
    gl.DeleteShader(fshader);
    // -- vao and vbo --
    // generate vao and vbo
    var vao: c_uint = undefined;
    var vbo: c_uint = undefined;
    gl.GenBuffers(1, @ptrCast(&vbo));
    gl.GenVertexArrays(1, @ptrCast(&vao));
    // bind vertex array object first to configure vertex attributes (gl.VertexAttribPointer)
    gl.BindVertexArray(vao);
    // fill vbo
    gl.BindBuffer(gl.ARRAY_BUFFER, vbo);
    gl.BufferData(gl.ARRAY_BUFFER, @sizeOf(@TypeOf(triangle)), @ptrCast(&triangle), gl.STATIC_DRAW);
    // set vertex attributes
    gl.VertexAttribPointer(0, 3, gl.FLOAT, gl.FALSE, 3 * @sizeOf(f32), 0); // pointer = 0 = (*void)0
    gl.EnableVertexAttribArray(0);

    // "unbind" buffers (not directly needed)
    gl.BindBuffer(gl.ARRAY_BUFFER, 0);
    gl.BindVertexArray(0);

    // ---------------------------
    // LOOP
    // with just `swapBuffers` and `pollEvents` the window will flicker... idk why that is... but after the first draw call its gone
    // gl.PolygonMode(gl.FRONT_AND_BACK, gl.LINE);
    while (!glfw.windowShouldClose(window)) {
        process_input(window);
        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);
        // DRAW triangle
        gl.UseProgram(shader_prog);
        gl.BindVertexArray(vao);
        gl.DrawArrays(gl.TRIANGLES, 0, 3);
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
