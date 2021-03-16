const std = @import("std");
pub const pkgs = struct {
    pub const zbox = std.build.Pkg{
        .name = "zbox",
        .path = ".gyro/zbox-jessrud-8445cc3c287b517406c3d595cf9c8646c562c9e6/pkg/src/box.zig",
    };

    pub const datetime = std.build.Pkg{
        .name = "datetime",
        .path = ".gyro/zig-datetime-frmdstryr-9b7e0ef8d23f4d54fae2fbe89f08ef9106a84308/pkg/datetime.zig",
    };

    pub fn addAllTo(artifact: *std.build.LibExeObjStep) void {
        @setEvalBranchQuota(1_000_000);
        inline for (std.meta.declarations(pkgs)) |decl| {
            if (decl.is_pub and decl.data == .Var) {
                artifact.addPackage(@field(pkgs, decl.name));
            }
        }
    }
};
