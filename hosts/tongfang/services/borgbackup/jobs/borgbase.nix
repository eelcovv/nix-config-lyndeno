{
  config,
  super,
}:
with config.age.secrets; {
  inherit (super.common) paths exclude;
}
