default:
  just mermaid top-level
  presenterm presentation.md

mermaid NAME:
  mmdc -i {{NAME}}.mmd -o {{NAME}}.mmd.png -b transparent -t neutral
