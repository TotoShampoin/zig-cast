# Zig cast

Yet another Zig casting library that should make your life with casting easier.

To add it:

```sh
zig fetch --save git+https://github.com/TotoShampoin/zig-cast
```

And in build.zig, add:

```zig
// const exe = ...

const cast = b.dependency("cast", .{
    .target = target,
    .optimize = optimize,
});
exe_mod.addImport("cast", cast.module("cast"));

// b.installArtifact ...
```
