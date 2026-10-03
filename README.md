# cgit-container

A lightweight Docker container for [CGit](https://git.zx2c4.com/cgit/about/), built from source on Alpine Linux and powered by Nginx. Designed for a minimal footprint, this image uses Alpine Linux and always tracks the latest stable release of Nginx.

## Quick Start

Run the container locally by mounting your repositories:

```sh
docker run --rm -it -p 8080:8080 -v /my/repos/:/srv/git/:ro cgit-container:latest
```

## Volumes & Paths

| Path | Description |
|------|-------------|
| `/etc/cgitrc` | CGit configuration file (dynamically generated at startup) |
| `/srv/git` | Mount your Git repositories here |
| `/var/cache/cgit` | HTML cache (mount as `tmpfs` for optimal performance) |

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `CGIT_TITLE` | `CGit` | Main page title |
| `CGIT_DESC` | `The hyperfast web frontend for Git repositories` | Main page description |
| `CGIT_WORKERS` | `1` | Number of `fcgiwrap` workers (max 4) |

## Theme Features

This image ships with a modernized, [GitHub-inspired dark theme](https://www.hackitu.de/cgithub/) out of the box. Key features include:

- A consistent, modern dark UI across all pages
- Improved readability with an updated system font stack
- Integration of [Octicon](https://primer.style/foundations/icons) SVG tab icons
- GitHub-style diff styling, responsive layouts, and branch/tag decorations
- Fast, client-side syntax highlighting via bundled [highlight.js](https://highlightjs.org/) (zero external requests)

*Note: To disable the custom theme, override the `head-include` directive by mounting a custom `cgitrc`.*

## Credits

- Theme adapted from [cgithub](https://www.hackitu.de/cgithub/) by hackitu.de
- Container architecture inspired by [joseluisq/alpine-cgit](https://github.com/joseluisq/alpine-cgit)

## License

This project is licensed under the [MIT License](LICENSE).  
*Note: CGit and Git (compiled within the container) are distributed under the GPLv2 license.*
