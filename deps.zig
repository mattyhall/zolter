const std = @import("std");
pub const pkgs = struct {
    pub const zbox = std.build.Pkg{
        .name = "zbox",
        .path = ".gyro/zbox-jessrud-8445cc3c287b517406c3d595cf9c8646c562c9e6/pkg/src/box.zig",
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
