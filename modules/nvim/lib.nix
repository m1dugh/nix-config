{
  lib,
  ...
}:
with lib;
{
  debuggerType = types.submodule (
    {
      name,
      ...
    }:
    {
      options = {
        enable = mkEnableOption ''${name} debugger'';
        package = mkOption {
          type = types.package;
          description = ''The package to add for the debugger'';
        };
      };
    }
  );
}
