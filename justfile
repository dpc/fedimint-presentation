default:
  just mermaid-render-all
  presenterm presentation.md

mermaid-render-all:
  just mermaid-render top-level

mermaid-render NAME:
  mmdc -i {{NAME}}.mmd -o {{NAME}}.mmd.png -b transparent -t neutral
