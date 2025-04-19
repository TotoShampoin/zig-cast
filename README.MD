# Zig cast

Yet another Zig casting library that should make your life with casting easier.

To add it:

```sh
zig fetch --save git+https://github.com/TotoShampoin/zig-cast
```

in build.zig, add:

```zig
// const exe_mod = ...

const cast = b.dependency("cast", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("cast", cast.module("cast"));

// b.installArtifact ...
```

and in your project:
```zig
const cast = @import("cast").cast;

// ...

const x = cast(f32, y);
```

## Will work with
- int to int
- int to float
- int to enum
- int to book
- int to ptr
- float to int
- float to float
- float to bool
- bool to int
- bool to float
- bool to bool (lmao)
- enum to int
- enum to enum
- ptr to int
- ptr to ptr
- optional to non optional, of any of the above
