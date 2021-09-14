{ pkgs ? import <nixpkgs> {} }:
let
  easy-ps = import (
    pkgs.fetchFromGitHub {
      owner = "justinwoo";
      repo = "easy-purescript-nix";
      rev = "598aea7973c25b0a3fa976dcac629c39f2e56680";
      sha256 = "04sg3ksy36g4xdrw4lk0kbmvyh3g7hrs9w6n9pfnyxv5rq30bdqb";
    }
  ) {
    inherit pkgs;
  };
in
pkgs.mkShell {
  buildInputs = [
    easy-ps.purs
    easy-ps.spago
  ];
}
