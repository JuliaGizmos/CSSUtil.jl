using Markdown

WebIO.render(md::Markdown.MD) = blocknode(md)

blocknode(x) = wrapnode(x)
inlinenode(x) = wrapnode(x)

blocknode(md::Markdown.MD) = vbox(map(blocknode, md.content))
inlinenode(x::AbstractString) = x

blocknode(md::Markdown.Header{n}) where {n} =
     node("h$n", map(inlinenode, md.text)...)

inlinenode(md::Markdown.Code) = node("code", md.code)

blocknode(md::Markdown.Code)  =
    node("pre", md.code...)

blocknode(md::Markdown.BlockQuote) =
    blockquote(map(blocknode, md.content))

function blocknode(md::Markdown.List)
    el = md.ordered == -1 ? "ul" : "ol"
    node(el, map(x->node("li", inlinenode.(x)...), md.items)...)
end
blocknode(md::Markdown.Paragraph) =
    node("p", map(inlinenode, md.content)...)

inlinenode(md::Markdown.Paragraph) =
    node("div", map(inlinenode, md.content)...)

inlinenode(md::Markdown.Italic) = node("em", map(inlinenode, md.text)...)
inlinenode(md::Markdown.Bold) = node("span", map(inlinenode, md.text)...)(fontweight("bold"))
inlinenode(md::Markdown.Link) = node("a", map(inlinenode, md.text)..., href=md.url)

inlinenode(md::Markdown.Image) = node("img", src=md.url, alt=md.alt)
blocknode(md::Markdown.Image) = node("img", src=md.url, alt=md.alt)

function inlinenode(md::Markdown.LaTeX)
    imports = ["https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.js",
               "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.css"]
    w = Scope(imports=imports)
    w(node("span", className="katex", md.formula))(style=Dict("display"=>"inline"))
end
function blocknode(md::Markdown.LaTeX)
    imports = ["https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.js",
               "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.css"]
    w = Scope(imports=imports)
    w(node("div", className="katex", md.formula))
end
