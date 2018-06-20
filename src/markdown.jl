using WebIO
using CSSUtil

class(cls) = Dict("className" => cls)
Base.convert(::Type{Node}, md::Markdown.MD) = blocknode(md)(class("webio-markdown"))

blocknode(x) = convert(Node, x)
inlinenode(x) = convert(Node, x)
blocknode(x::Node) = x
inlinenode(x::Node) = x

blocknode(md::Markdown.MD) = vbox(map(blocknode, md.content))
inlinenode(x::AbstractString) = x

blocknode(md::Markdown.Header{n}) where {n} =
     dom"h$n"(map(inlinenode, md.text))

inlinenode(md::Markdown.Code) = dom"code"(md.code)

blocknode(md::Markdown.Code)  =
    dom"pre"(md.code)

blocknode(md::Markdown.BlockQuote) =
    blockquote(map(blocknode, md.content))

function blocknode(md::Markdown.List)
    el = md.ordered == -1 ? "ul" : "ol"
    dom"$el"(map(x->dom"li"(inlinenode.(x)), md.items))
end
blocknode(md::Markdown.Paragraph) =
    dom"p"(map(inlinenode, md.content))

inlinenode(md::Markdown.Paragraph) =
    dom"div"(map(inlinenode, md.content))

inlinenode(md::Markdown.Italic) = dom"em"(map(inlinenode, md.text))
inlinenode(md::Markdown.Bold) = dom"span"(map(inlinenode, md.text))(fontweight("bold"))
inlinenode(md::Markdown.Link) = dom"a"(map(inlinenode, md.text), href=md.url)

inlinenode(md::Markdown.Image) = dom"img"(src=md.url, alt=md.alt)
blocknode(md::Markdown.Image) = dom"img"(src=md.url, alt=md.alt)

function inlinenode(md::Markdown.LaTeX)
    w = Widget(dependencies=["https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.js", "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.css"])
    w(dom"span.katex"(md.formula))(style=Dict("display"=>"inline"))
end
function blocknode(md::Markdown.LaTeX)
    w = Widget(dependencies=["https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.js", "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.9.0-alpha/katex.min.css"])
    w(dom"div.katex"(md.formula))
end
