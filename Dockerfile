FROM ubuntu:24.04

# 対話モード防止
ENV DEBIAN_FRONTEND=noninteractive

# clang-formatのインストール
RUN apt-get update && \
    apt-get install -y clang-format git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY scripts/clang-format-check.sh /usr/local/bin/clang-format-check.sh
RUN chmod +x /usr/local/bin/clang-format-check.sh

ENTRYPOINT ["bash", "/usr/local/bin/clang-format-check.sh"]
