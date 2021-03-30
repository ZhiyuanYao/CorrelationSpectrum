#==============================================================================#
# Description
# -----------
#
#
#   Version:  1.0
#   Created:
#    Author:  Zhiyuan Yao, zhiyuan.yao@icloud.com
# Institute:  Insitute for Advanced Study, Tsinghua University
#==============================================================================#
# Change Log:
#   *
#==============================================================================#
# todo:
#   *
#==============================================================================#
using Dash, DashHtmlComponents, DashCoreComponents
using PlotlyJS, DelimitedFiles
using Plots
# using Genie, Genie.Router

#------------------------------------------------------------------------------
#  read in data
#------------------------------------------------------------------------------
filename = "./corr_spectrum_L14.dat"
data = readdlm(filename)

app = dash()

app.layout = html_div() do
    # default value set to be 2
    dcc_input(id = "input-1", value = "1", type = "text"),
    html_div() do
        dcc_graph(id = "power")
    end
end

callback!(app, Output("power", "figure"), Input("input-1", "value")) do value
    n = parse(Int, value)
    if value == "" || value == nothing
       n = 1
       return Plot([1, 2, 3], [1, 2, 3])
    end
    ydat = data[n, :]
    xdat = [i for i in 1:length(ydat)]
    # alternatively, we can use Plot(xdat, ydat   on the first line
    return Plot(xdat, ydat,
                Layout(
                       xaxis_type = "linear",  # log
                       xaxis_title = "E_n",
                       yaxis_title = "λ_n",
                       # not updated though
                       # title = "correlation spectrum for $n-th eigenstate",
                       legend_x = 0,
                       legend_y = 1,
                       hovermode = "closest",
                       transition_duration = 500
                      ),
                mode = "markers+lines",
                marker_size = 8,
                line_color = "green",
                marker_color = palette(:tab10)[1]
               )
end

port = parse(Int64, ENV["PORT"]);
run_server(app, "0.0.0.0", port)
