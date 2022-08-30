const std = @import("std");
const builtin = @import("builtin");

pub fn build(b: *std.build.Builder) void {
    // Standard release options allow the person running `zig build` to select
    // between Debug, ReleaseSafe, ReleaseFast, and ReleaseSmall.
    const target = b.standardTargetOptions(.{});
    const mode = b.standardReleaseOptions();

    const tb_client = b.addStaticLibrary("tb_client", "libs/tigerbeetle/src/c/tb_client.zig");
    tb_client.setMainPkgPath("libs/tigerbeetle/src");

    const lib = b.addSharedLibrary("tb_jniclient", "src/client.zig", .unversioned);
    lib.addPackagePath("jui", "libs/jui/src/jui.zig");
    lib.linkLibrary(tb_client);

    const os_tag = target.os_tag orelse builtin.target.os.tag;
    if (os_tag != .windows) {
        tb_client.linkLibC();
        lib.linkLibC();
    }

    lib.setTarget(target);
    lib.setBuildMode(mode);
    lib.install();
}