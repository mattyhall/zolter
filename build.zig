const std = @import("std");
const builtin = @import("builtin");
const pkgs = @import("deps.zig").pkgs;

const sqlite_dir = std.fs.path.dirname(pkgs.sqlite.path).? ++ "/c";

const sqlite_source_file = sqlite_dir ++ "/sqlite3.c";

pub fn build(b: *std.build.Builder) !void {
    var target = b.standardTargetOptions(.{});
    target.setGnuLibCVersion(2, 28, 0);
    const mode = b.standardReleaseOptions();

    const sqlite = b.addStaticLibrary("sqlite", null);
    sqlite.addCSourceFile(sqlite_source_file, &[_][]const u8{"-std=c99"});
    sqlite.addIncludeDir(sqlite_dir);
    sqlite.linkLibC();
    sqlite.setTarget(target);
    sqlite.setBuildMode(mode);

    const exe = b.addExecutable("zolt", "src/main.zig");
    exe.setTarget(target);
    exe.setBuildMode(mode);
    pkgs.addAllTo(exe);
    exe.install();

    const run_cmd = exe.run();
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    const dump_exe = b.addExecutable("dump", "src/dump.zig");
    dump_exe.setTarget(target);
    dump_exe.setBuildMode(mode);
    dump_exe.install();

    const importer_exe = b.addExecutable("import", "src/importer.zig");
    importer_exe.setTarget(target);
    importer_exe.setBuildMode(mode);
    importer_exe.addIncludeDir(sqlite_dir);
    pkgs.addAllTo(importer_exe);
    importer_exe.linkLibrary(sqlite);
    importer_exe.install();
}
