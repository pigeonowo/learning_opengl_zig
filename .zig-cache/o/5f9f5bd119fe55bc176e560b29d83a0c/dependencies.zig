pub const packages = struct {
    pub const @"zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks" = struct {
        pub const build_root = "/home/jonas/.cache/zig/p/zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks";
        pub const build_zig = @import("zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
    pub const @"zigglgen-0.4.0-bmyqLX_gLQDFXilQ5VQ9fJeOHKU1RFrggOzRqTGBX79W" = struct {
        pub const build_root = "/home/jonas/.cache/zig/p/zigglgen-0.4.0-bmyqLX_gLQDFXilQ5VQ9fJeOHKU1RFrggOzRqTGBX79W";
        pub const build_zig = @import("zigglgen-0.4.0-bmyqLX_gLQDFXilQ5VQ9fJeOHKU1RFrggOzRqTGBX79W");
        pub const deps: []const struct { []const u8, []const u8 } = &.{
        };
    };
};

pub const root_deps: []const struct { []const u8, []const u8 } = &.{
    .{ "zglfw", "zglfw-0.1.0-BghZXfnRAACSrPga22je1XilEj1QNXrtv6w4HIUFqdks" },
    .{ "zigglgen", "zigglgen-0.4.0-bmyqLX_gLQDFXilQ5VQ9fJeOHKU1RFrggOzRqTGBX79W" },
};
