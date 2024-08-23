{ lib
, pkgs
, ...
}: {
    pkgs = {
        writeJSONText = name: content: pkgs.writeTextFile {
            name = "${name}.json";
            text = builtins.toJSON content;
        };
    };

    lib = {
        maintainers = {
            m1dugh = {
                github = "m1dugh";
                githubId = 42266017;
            };
        } // lib.maintainers;
    };
}
