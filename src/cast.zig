/// Convenient function that calls the casting functions so you don't have to.
pub fn cast(comptime T: type, value: anytype) T {
    const in_type = @typeInfo(@TypeOf(value));
    const out_type = @typeInfo(T);
    if (in_type == .optional) {
        return cast(T, value.?);
    }
    return switch (out_type) {
        .int => switch (in_type) {
            .int => @intCast(value),
            .float => @intFromFloat(value),
            .bool => @intFromBool(value),
            .@"enum" => @intFromEnum(value),
            .pointer => @intFromPtr(value),
            else => unreachable,
        },
        .float => switch (in_type) {
            .int => @floatFromInt(value),
            .float => @floatCast(value),
            .bool => @floatFromInt(@intFromBool(value)),
            else => unreachable,
        },
        .bool => switch (in_type) {
            .int => value != 0,
            .float => value != 0,
            .bool => value,
            else => unreachable,
        },
        .@"enum" => switch (in_type) {
            .int => @enumFromInt(value),
            .@"enum" => @enumFromInt(@intFromEnum(value)),
            else => unreachable,
        },
        .pointer => switch (in_type) {
            .int => @ptrFromInt(value),
            .pointer => @ptrCast(value),
            else => unreachable,
        },
        else => unreachable,
    };
}

test "cast" {
    const std = @import("std");

    // Integer casting
    try std.testing.expectEqual(@as(i32, 36), cast(i32, @as(u64, 36)));
    try std.testing.expectEqual(@as(i32, -5), cast(i32, @as(i8, -5)));
    try std.testing.expectEqual(@as(u8, 255), cast(u8, @as(i32, 255)));

    // Float casting
    try std.testing.expectEqual(@as(f32, 36.0), cast(f32, @as(i32, 36)));
    try std.testing.expectEqual(@as(f64, 36.5), cast(f64, @as(f32, 36.5)));

    // Bool casting
    try std.testing.expectEqual(true, cast(bool, @as(i32, 1)));
    try std.testing.expectEqual(false, cast(bool, @as(i32, 0)));
    try std.testing.expectEqual(true, cast(bool, @as(f32, 1.0)));
    try std.testing.expectEqual(false, cast(bool, @as(f32, 0.0)));
    try std.testing.expectEqual(true, cast(bool, true));

    // Enum casting
    const Color = enum(u8) { red = 0, green = 1, blue = 2 };
    try std.testing.expectEqual(Color.red, cast(Color, @as(u8, 0)));
    try std.testing.expectEqual(Color.blue, cast(Color, @as(u8, 2)));

    // Enum to Enum casting
    const Direction = enum(u8) { north = 0, east = 1, south = 2, west = 3 };
    try std.testing.expectEqual(Direction.east, cast(Direction, Color.green));

    // Pointer casting
    var x: i32 = 42;
    const ptr_int = @intFromPtr(&x);
    const ptr_back = cast(*i32, ptr_int);
    try std.testing.expectEqual(@as(i32, 42), ptr_back.*);

    // Optional unwrapping
    try std.testing.expectEqual(@as(i32, 10), cast(i32, @as(?i32, 10)));

    // Float from bool
    try std.testing.expectEqual(@as(f32, 1.0), cast(f32, true));
    try std.testing.expectEqual(@as(f32, 0.0), cast(f32, false));

    // Integer from enum
    try std.testing.expectEqual(@as(u8, 1), cast(u8, Color.green));

    // Integer from bool
    try std.testing.expectEqual(@as(i32, 1), cast(i32, true));
    try std.testing.expectEqual(@as(i32, 0), cast(i32, false));

    // Nested optional unwrapping
    const nested_optional: ??i32 = 42;
    try std.testing.expectEqual(@as(i32, 42), cast(i32, nested_optional));

    // Boolean from larger integers
    try std.testing.expectEqual(true, cast(bool, @as(i64, 42)));
    try std.testing.expectEqual(false, cast(bool, @as(i64, 0)));
}
