const std = @import("std");

fn repl() !void {
    while (true) {
        std.debug.print("zlox>", .{});
        var buff: [1024]u8 = undefined;
        const reader = std.io.getStdIn().reader();
        const userInput = try reader.readUntilDelimiter(&buff, '\n');
        std.debug.print("{s}\n", .{userInput});
    }
}

pub fn main() !void {
    var args = std.process.args();

    _ = args.next();

    if (args.next()) |path| {
        _ = path;
    } else {
        std.log.info("no input file detected, launching interative mode", .{});
        try repl();
    }
}
