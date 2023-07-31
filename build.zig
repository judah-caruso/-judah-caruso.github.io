const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const exe = b.addExecutable(.{
        .name = "wiki",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    const rivit = b.addModule("rivit", .{
        .source_file = .{ .path = "src/lib/rivit/src/rivit.zig" },
    });

    exe.addModule("rivit", rivit);

    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());

    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Generate the wiki");
    run_step.dependOn(&run_cmd.step);
}
