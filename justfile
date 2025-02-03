default:
    @just --list

# Build the Test Virtualmachine with singer
[group('main')]
singertest:
    nixos-rebuild build-vm --flake .#singer

