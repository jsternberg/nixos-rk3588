FROM nixos/nix AS nix-base
RUN echo "experimental-features = nix-command flakes" >> /etc/nix/nix.conf

FROM nix-base AS nix-store
COPY --link --from=nix-base /nix/store /

FROM nix-base AS nix-builder
WORKDIR /workdir

FROM nix-builder AS sdimage-openpi5plus
RUN --mount=type=bind \
    --mount=type=cache,from=nix-store,target=/nix/store \
  nix build .#sdImage-opi5plus
