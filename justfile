default:
  presenterm presentation.md

mermaid-render-all:
  just mermaid-render top-level 2

mermaid-render NAME SCALE="1":
  mmdc -i {{NAME}}.mmd -o {{NAME}}.mmd.png -b transparent -t neutral --scale {{SCALE}}
