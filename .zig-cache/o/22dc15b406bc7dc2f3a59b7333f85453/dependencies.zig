pub const packages = struct {
    pub const @"zgl-1.1.0-p_NpABvCCgCJPOcp11QHacU02b1rVdXkWR9Xvjv68y9R" = struct {
        pub const build_root = "/home/jonas/.cache/zig/p/zgl-1.1.0-p_NpABvCCgCJPOcp11QHacU02b1rVdXkWR9Xvjv68y9R";
        pub const build_zig = @import("zgl-1.1.0-p_NpABvCCgCJPOcp11QHacU02b1rVdXkWR9Xvjv68y9R");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks" = struct {
        pub const build_root = "/home/jonas/.cache/zig/p/zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks";
        pub const build_zig = @import("zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "zglfw", "zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks" },
    .{ "zgl", "zgl-1.1.0-p_NpABvCCgCJPOcp11QHacU02b1rVdXkWR9Xvjv68y9R" },
};
