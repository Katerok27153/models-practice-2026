# ## Анимация процесса (классическая сеть)

using Pkg
Pkg.activate("../project")
using DrWatson
@quickactivate"project"
using DrWatson
@quickactivate "project"
include(srcdir("DiningPhilosophers.jl"))
using .DiningPhilosophers
using Plots, Random

N = 3
tmax = 30.0
net, u0, names = build_classical_network(N)

Random.seed!(123)
df = simulate_stochastic(net, u0, tmax)

anim = @animate for row in eachrow(df)
    u = [row[col] for col in propertynames(row) if col != :time]
    bar(
        1:length(u),
        u,
        legend = false,
        ylims = (0, maximum(u0) + 1),
        xlabel = "Позиция",
        ylabel = "Фишки",
        title = "Время = $(round(row.time, digits=2))",
    )
    xticks!(1:length(u), string.(names), rotation = 45)
end

gif(anim, plotsdir("philosophers_simulation_classic.gif"), fps = 2)
println("Анимация сохранена в plots/philosophers_simulation_classic.gif")


# Сохраняем последний кадр как статическое изображение
last_row = df[end, :]
u_last = [last_row[col] for col in propertynames(last_row) if col != :time]
p = bar(
    1:length(u_last),
    u_last,
    legend = false,
    ylims = (0, maximum(u0) + 1),
    xlabel = "Позиция",
    ylabel = "Фишки",
    title = "Конечное состояние (t = $(round(last_row.time, digits=2)))",
)
xticks!(1:length(u_last), string.(names), rotation = 45)
savefig(plotsdir("philosophers_simulation_classic_frame.png"))
println("Кадр сохранён в plots/philosophers_simulation_classic_frame.png")

# Отображаем последний кадр
p
