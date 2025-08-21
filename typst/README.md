# Typst and Pandoc: Modern Typesetting for Markdown

## What is Typst?

**Typst** is a modern, open-source typesetting system designed to be as powerful as LaTeX, but much easier to learn and use. Like Markdown or LaTeX, Typst uses a plain-text markup language—but with a simpler, more consistent syntax and excellent support for templates, custom layouts, and rapid iteration.

Typst is especially well suited for producing **beautiful, professional PDF documents** with lightning-fast render times. Its community and official templates allow users to quickly switch styles without rewriting their content, making it ideal for articles, books, scripts, and more[2][46][43].

Key features:
- Human-friendly syntax and quick learning curve.
- Real-time preview and instant re-rendering.
- Flexible templates and theme support.
- Professional-quality PDF output by default.

## What is Pandoc?

**Pandoc** is a universal document converter. It allows you to take documents written in one markup format (such as Markdown) and convert them into a wide range of output formats (including HTML, PDF, DOCX, Typst, etc.).

Pandoc is renowned for its flexibility and its robust metadata handling, template support, filters, and scripting extensions.

## How Do Typst and Pandoc Work Together?

Pandoc now supports **Typst as a PDF engine and as a native output format**. This means you can write your content in Markdown, use Pandoc to convert it to Typst code, and then use Typst itself to produce a polished PDF. The combination gives you:

- The ease and simplicity of Markdown for writing content.
- The beauty, speed, and flexibility of Typst for final PDF production.
- The rich document metadata infrastructure of Pandoc.
- The ability to apply Typst templates and themes for consistent formatting.

### Example Workflow

1. **Write your document in Markdown**.
2. **Convert to PDF using Typst as the engine**
3. **Apply Typst templates** using Pandoc arguments or modify the generated Typst for custom formatting.

This approach is especially powerful if you want to customize your document’s look with Typst templates (for articles, books, scripts, etc.) or take advantage of Typst's advanced typesetting capabilities[2][5][43][46].

## Resources

- [Typst Documentation](https://typst.app/docs/)
- [Pandoc Manual](https://pandoc.org/MANUAL.html)
- [Typst Universe Community Templates](https://typst.app/universe/search/?kind=templates)

A template name is part of the URL: <https://typst.app/universe/package/template-name-here>
E.g. template url: <https://typst.app/universe/package/xyznote>
