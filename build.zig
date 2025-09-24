const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    inline for (scripts) |script| {
        const exe = b.addExecutable(.{
            .name = script.name,
            .root_module = b.createModule(.{
                .target = target,
                .optimize = optimize,
                .link_libc = true,
            }),
        });
        exe.addCSourceFiles(.{
            .root = b.path(script.root),
            .files = script.sources,
        });
        exe.root_module.addCMacro("NO_YAML", "1");
        exe.addIncludePath(b.path("include"));
        exe.addIncludePath(b.path("tools/include"));
        exe.addIncludePath(b.path("scripts/include"));
        exe.addIncludePath(b.path("scripts/dtc/libfdt"));
        b.getInstallStep().dependOn(&b.addInstallArtifact(exe, .{
            .dest_dir = .{ .override = script.install_dir },
        }).step);
    }
}

const Scripts = struct {
    name: []const u8,
    root: []const u8,
    sources: []const []const u8,
    install_dir: std.Build.InstallDir = .prefix,
};

const scripts: []const Scripts = &.{
    .{
        .name = "fixdep",
        .root = "scripts/basic",
        .sources = &.{
            "fixdep.c",
        },
        .install_dir = .{ .custom = "basic" },
    },
    .{
        .name = "modpost",
        .root = "scripts/mod",
        .sources = &.{
            "modpost.c",
            "file2alias.c",
            "sumversion.c",
            "symsearch.c",
        },
        .install_dir = .{ .custom = "mod" },
    },
    .{
        .name = "fdtoverlay",
        .root = "scripts/dtc",
        .sources = &.{
            "libfdt/fdt.c",
            "libfdt/fdt_ro.c",
            "libfdt/fdt_wip.c",
            "libfdt/fdt_sw.c",
            "libfdt/fdt_rw.c",
            "libfdt/fdt_strerror.c",
            "libfdt/fdt_empty_tree.c",
            "libfdt/fdt_addresses.c",
            "libfdt/fdt_overlay.c",
            "fdtoverlay.c",
            "util.c",
        },
        .install_dir = .{ .custom = "dtc" },
    },
    .{
        .name = "dtc",
        .root = "scripts/dtc",
        .sources = &.{
            "dtc.c",
            "flattree.c",
            "fstree.c",
            "data.c",
            "livetree.c",
            "treesource.c",
            "srcpos.c",
            "checks.c",
            "util.c",
            "dtc-lexer.lex.c",
            "dtc-parser.tab.c",
        },
        .install_dir = .{ .custom = "dtc" },
    },
    .{
        .name = "conf",
        .root = "scripts/kconfig",
        .sources = &.{
            "conf.c",
            "confdata.c",
            "expr.c",
            "lexer.lex.c",
            "menu.c",
            "parser.tab.c",
            "preprocess.c",
            "symbol.c",
            "util.c",
        },
        .install_dir = .{ .custom = "kconfig" },
    },
    .{
        .name = "modpost",
        .root = "scripts/mod",
        .sources = &.{
            "mk_elfconfig.c",
        },
        .install_dir = .{ .custom = "mod" },
    },
    .{
        .name = "sorttable",
        .root = "scripts",
        .sources = &.{
            "sorttable.c",
        },
    },
    .{
        .name = "kallsyms",
        .root = "scripts",
        .sources = &.{
            "kallsyms.c",
        },
    },
    .{
        .name = "kallsyms",
        .root = "scripts",
        .sources = &.{
            "kallsyms.c",
        },
    },
    .{
        .name = "asn1_compiler",
        .root = "scripts",
        .sources = &.{
            "asn1_compiler.c",
        },
    },
};
