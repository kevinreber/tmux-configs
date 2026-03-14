# TODO - Documentation Enhancements

Tracking enhancements for improving this documentation-focused repository.

## Documentation Content

- [ ] Expand Docusaurus docs into separate pages: installation, keybindings, plugins, troubleshooting, customization
- [ ] Simplify root README.md — link to `tmux.conf` instead of embedding the entire file inline
- [ ] Add a changelog or version history documenting when features/plugins were added

## Docusaurus Site Structure

- [ ] Add more doc pages to make the auto-generated sidebar useful
- [ ] Improve homepage (`src/pages/index.tsx`) with platform-specific quick starts or plugin showcase
- [ ] Add search functionality (Algolia or local search plugin)
- [ ] Add a custom 404 page

## Missing Documentation Topics

- [ ] Create a dedicated keybinding reference/cheat sheet (F-keys and arrow-key bindings)
- [ ] Document Catppuccin theme customization options in `tmux.conf`
- [ ] Document the Mariner font fallback logic (most complex part of the codebase)
- [ ] Add "uninstall" or "reset to defaults" instructions
- [ ] Add screenshots or visual examples of the configured tmux session

## Site Quality

- [ ] Diverge `docusaurus-docs/docs/tmux-setup/README.md` from root README to serve different audiences
- [ ] Remove or repurpose `src/pages/markdown-page.md` (Docusaurus boilerplate)
- [ ] Configure OpenGraph/social media meta tags for link previews

## Developer Experience

- [ ] Add a root `.gitignore` (`.DS_Store`, editor configs, etc.)
- [ ] Add a contributing guide for others who fork or adapt the configs
- [ ] Add Docusaurus build check to PR CI pipeline (prevent broken docs from merging)
