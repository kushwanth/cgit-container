# cgit-container

## [CGit](https://git.zx2c4.com/cgit/about/) container built from source on Alpine running using Nginx with a GitHub-inspired theme.

Nginx is pinned to stable (1.28.x) and the image uses Alpine Linux for a small footprint.

## Quick Start

Run the locally built image:

```sh
docker run --rm -it -p 8080:8080 -v /my/repos/:/srv/git/:ro cgit-container:latest
```

## Container Paths

| Path | Description |
|------|-------------|
| `/etc/cgitrc` | CGit config file (dynamically generated at start) |
| `/srv/git` | Git repositories (mount yours here) |
| `/var/cache/cgit` | HTML cache (mount as `tmpfs` for maximum performance) |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CGIT_TITLE` | `CGit` | Page title |
| `CGIT_DESC` | `The hyperfast web frontend for Git repositories` | Page description |
| `CGIT_WORKERS` | `1` | Number of fcgiwrap workers (max 4) |

## Theme

Ships with a modernized [GitHub-inspired theme](https://www.hackitu.de/cgithub/) featuring:
- Consistent modern Dark Theme across the UI
- Modern system font stack and improved readability
- [Octicon](https://primer.style/foundations/icons) SVG tab icons
- GitHub-style diff colors, branch/tag decorations, and responsive layout
- Client-side syntax highlighting via vendored [highlight.js](https://highlightjs.org/) (bundled in the image, no external requests)

To disable, override `head-include` in a custom cgitrc.

## Credits

- Theme based on [cgithub](https://www.hackitu.de/cgithub/) by hackitu.de
- Docker setup inspired by [joseluisq/alpine-cgit](https://github.com/joseluisq/alpine-cgit)

## License

This project is licensed under the [MIT License](LICENSE). 
Note that CGit and Git (compiled within the container) are licensed under GPLv2.
