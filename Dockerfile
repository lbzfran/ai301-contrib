# syntax=docker/dockerfile:1
#
# Builds the sorbet binary using the official CI build image.
#
# Usage:
#   docker build -t sorbet .
#   docker run --rm sorbet --version
#   docker run --rm -v $(pwd):/code sorbet /code
#
# To extract the binary from the image:
#   docker create --name tmp sorbet && docker cp tmp:/usr/local/bin/sorbet . && docker rm tmp
#
# For a faster (unoptimized) debug build, change --config=release-linux to --config=dbg

# ---------- build stage ----------
FROM sorbetruby/sorbet-build-image:latest AS builder

WORKDIR /sorbet

COPY . .

# Disable terminal control codes (Bazel uses \r rewrites that Docker's non-TTY
# stdout drops, making the build look frozen) and disable the Linux sandbox
# (it can silently hang inside Docker's namespaced environment).
RUN printf 'common --curses=no --color=no\nbuild --spawn_strategy=local\n' > .bazelrc.local

RUN ./bazel build //main:sorbet \
      --config=dbg \
      --strip=always \
    && cp bazel-bin/main/sorbet /tmp/sorbet

# ---------- test stage (issue #6031) ----------
# Reproduces: "Cannot use instance of Singleton as default prop value"
#
# The bug: sorbet reports "No errors! Great job." on this input, but it should
# report an error because Singleton instances can't be used as prop defaults
# (deep_clone_object calls .clone on them, which Ruby's Singleton forbids).
#
# Usage:
#   docker build --target test -t sorbet-test .
#   docker run --rm sorbet-test
#   # Current (buggy) output: "No errors! Great job."
#   # After fix: should report an error on the prop default
FROM builder AS test

RUN cat > /tmp/issue_6031.rb <<'RUBY'
# typed: true
require 'sorbet-runtime'
require 'singleton'

extend T::Sig

class A < T::Struct
  class Unset
    include Singleton
  end

  prop :foo, T.any(T.nilable(Integer), Unset), default: Unset.instance
end

A.new
RUBY

ENTRYPOINT ["/tmp/sorbet"]
CMD ["--quiet", "/tmp/issue_6031.rb"]

# ---------- runtime stage ----------
FROM ubuntu:22.04 AS runtime

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       libstdc++6 \
       ca-certificates \
    && rm -rf /var/lib/apt/lists/*

COPY --from=builder /tmp/sorbet /usr/local/bin/sorbet

ENTRYPOINT ["/usr/local/bin/sorbet"]
CMD ["--help"]
