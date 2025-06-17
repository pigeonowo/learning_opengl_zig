const std = @import("std");
const glfw = @import("zglfw");
const gl = @import("gl");

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
    // load opengl proc_addresses
    // this is very different from the book
    var gl_procs: gl.ProcTable = undefined;
    if (!gl_procs.init(glfw.getProcAddress)) {
        //     std.io.getStdErr().writer().print("Failed to load proc address", .{}) catch {};
        //     return;
    }
    gl.makeProcTableCurrent(&gl_procs);
    defer gl.makeProcTableCurrent(null);
    // set viewport
    gl.Viewport(0, 0, 800, 600);
    // set viewport everytime it resizes (why does this return a function????)
    _ = glfw.setFramebufferSizeCallback(window, framebuffer_size_callback);
    // LOOP
    // with just `swapBuffers` and `pollEvents` the window will flicker... idk why that is... but after the first draw call its gone
    while (!glfw.windowShouldClose(window)) {
        process_input(window);
        gl.ClearColor(0.2, 0.3, 0.3, 1.0);
        gl.Clear(gl.COLOR_BUFFER_BIT);
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
