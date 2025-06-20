const std = @import("std");
const gl = @import("gl");

pub const ShaderError = error{ CompileError, ProgramCreationError };

pub const Shader = struct {
    const Self = @This();
    id: c_uint,

    pub fn init(comptime vertex_path: []const u8, comptime fragment_path: []const u8) ShaderError!Self {
        const vertex_src = @embedFile(vertex_path);
        const fragment_src = @embedFile(fragment_path);
        // vertex shader
        const vshader: c_uint = gl.CreateShader(gl.VERTEX_SHADER);
        gl.ShaderSource(vshader, 1, @ptrCast(&vertex_src), null);
        gl.CompileShader(vshader);
        var success: c_int = undefined;
        var info_log: [512]u8 = undefined;
        gl.GetShaderiv(vshader, gl.COMPILE_STATUS, &success);
        if (success == 0) {
            gl.GetShaderInfoLog(vshader, 512, null, &info_log);
            std.io.getStdErr().writer().print("Failed to compile Vertex shader\n{s}", .{info_log}) catch {};
            return ShaderError.CompileError;
        }
        // fragment shader
        const fshader: c_uint = gl.CreateShader(gl.FRAGMENT_SHADER);
        gl.ShaderSource(fshader, 1, @ptrCast(&fragment_src), null);
        gl.CompileShader(fshader);
        gl.GetShaderiv(fshader, gl.COMPILE_STATUS, &success);
        if (success == 0) {
            gl.GetShaderInfoLog(fshader, 512, null, &info_log);
            std.io.getStdErr().writer().print("Failed to compile Fragment shader\n{s}", .{info_log}) catch {};
            return ShaderError.CompileError;
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
            return ShaderError.ProgramCreationError;
        }
        return Self{ .id = shader_prog };
    }

    pub fn use(self: *Self) void {
        gl.UseProgram(self.id);
    }

    pub fn setBool(self: *Self, name: [:0]const u8, b: bool) void {
        gl.Uniform1i(gl.GetUniformLocation(self.id, name), if (b) 1 else 0);
    }

    pub fn setInt(self: *Self, name: [:0]const u8, i: i32) void {
        gl.Uniform1i(gl.GetUniformLocation(self.id, name), @as(c_int, i));
    }

    pub fn setFloat(self: *Self, name: [:0]const u8, f: f32) void {
        gl.Uniform1f(gl.GetUniformLocation(self.id, name), f);
    }
};
