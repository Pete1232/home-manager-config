let
  version = "86df4da217ce4821809b449a2559e16856a95e0d";
  url = "https://raw.githubusercontent.com/antonbabenko/awsp/${version}/awsp_functions.sh";
in
builtins.fetchurl {
  inherit url;
  sha256 = "055k0m8v6spvvlhz06xav7n00ap9ykdrh9axj2ipyc088dr3v90n";
}
