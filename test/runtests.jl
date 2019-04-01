using CSSUtil
using WebIO
using Test

@testset "hbox" begin
    el1 = node(:div, "Hello world!")
    el2 = node(:div, "Goodbye world!")
    box = hbox(el1, el2)
    @test props(box)[:style]["display"] == "flex"
    @test props(box)[:style]["flex-direction"] == "row"
    @test el1 ∈ children(box)
    @test el2 ∈ children(box)
end

@testset "vbox" begin
    el1 = node(:div, "Hello world!")
    el2 = node(:div, "Goodbye world!")
    box = vbox(el1, el2)
    @test props(box)[:style]["display"] == "flex"
    @test props(box)[:style]["flex-direction"] == "column"
    @test el1 ∈ children(box)
    @test el2 ∈ children(box)
end

@testset "hline" begin
    line = hline()
    @test haskey(props(line)[:style], "borderBottom")
    @test props(line)[:style]["align-self"] == "stretch"
end

@testset "vline" begin
    line = vline()
    @test haskey(props(line)[:style], "borderLeft")
    @test props(line)[:style]["align-self"] == "stretch"
end
