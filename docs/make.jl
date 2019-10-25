using Documenter,DiffEqBase,DiffEqProblemLibrary


"""
	pkgdir(m::Module, paths...)
	pkgdir(pkgname::String, paths...)

Get the absolute path to the directory of an installed package, specified by
either its name `pkgname` or its root module `m`. Optionally join the result
with `paths`.

# Returns

Absolute path to package directory if found, `nothing` otherwise.
"""
function pkgdir(p::Union{String, Module}, paths...)
	pdir = p isa String ? Base.locate_package(p) : pathof(p)
	pdir === nothing && return nothing
	return joinpath(dirname(dirname(pdir)), paths...)
end


"""
	joinpages(srcdir::String, pages)

Recursively prepend `srcdir` to all paths in `pages`, where `pages` is the argument to
`Documenter.makedocs`.
"""

joinpages(srcdir::String, pages::Array) = [joinpages(srcdir, p) for p in pages]
joinpages(srcdir::String, path::String) = joinpath(srcdir, path)
joinpages(srcdir::String, pair::Pair) = pair.first => joinpages(srcdir, pair.second)


"""
	locate_pages(pkg[, srcdir::String], pages)

Locate the documentation source files in `pages` within the directory for
package `pkg`, where `pages` is the argument to `Documeter.makedocs`.
`pkg` may be either the name of the package or its root module. `srcdir`
is the subdirectory containing the package's documentation files and
defaults to `docs/src/`.

# Returns

Updated version of `pages` where all file paths are absolute. Returns an
empty array and emits a warning if the package directory could not be
found. Either result can be passed to `Documenter.makedocs`.
"""
function locate_pages(pkg, srcdir::String, pages)
	abspath = pkgdir(pkg, srcdir)
@show abspath
	if abspath === nothing
		@warn "Unable to find directory for package $pkg"
		return []
	end
	return joinpages(abspath, pages)
end

locate_pages(pkg, pages) = locate_pages(pkg, "docs/src", pages)



makedocs(modules=[DiffEqBase,DiffEqProblemLibrary],
         doctest=false, clean=true,
         format = :html,
         assets = ["assets/favicon.ico"],
         sitename="DifferentialEquations.jl",
         authors="Chris Rackauckas",
         pages = Any[
         "Home" => "index.md",
         "Tutorials" => Any[
           "tutorials/ode_example.md",
           "tutorials/sde_example.md",
           "tutorials/rode_example.md",
           "tutorials/dde_example.md",
           "tutorials/dae_example.md",
           "tutorials/discrete_stochastic_example.md",
           "tutorials/jump_diffusion.md",
           "tutorials/bvp_example.md",
           "tutorials/additional.md"
         ],
         "Basics" => Any[
           "basics/overview.md",
           "basics/common_solver_opts.md",
           "basics/solution.md",
           "basics/plot.md",
           "basics/integrator.md",
           "basics/problem.md",
           "basics/faq.md",
           "basics/compatibility_chart.md"
         ],
         "Problem Types" => Any[
           "types/discrete_types.md",
           "types/ode_types.md",
           "types/dynamical_types.md",
           "types/split_ode_types.md",
           "types/steady_state_types.md",
           "types/bvp_types.md",
           "types/sde_types.md",
           "types/rode_types.md",
           "types/dde_types.md",
           "types/dae_types.md",
           "types/jump_types.md",
         ],
         "Solver Algorithms" => Any[
           "solvers/discrete_solve.md",
           "solvers/ode_solve.md",
           "solvers/dynamical_solve.md",
           "solvers/split_ode_solve.md",
           "solvers/steady_state_solve.md",
           "solvers/bvp_solve.md",
           "solvers/jump_solve.md",
           "solvers/sde_solve.md",
           "solvers/rode_solve.md",
           "solvers/dde_solve.md",
           "solvers/dae_solve.md",
           "solvers/benchmarks.md"
         ],
         "Additional Features" => Any[
           "features/performance_overloads.md",
           "features/diffeq_arrays.md",
           "features/diffeq_operator.md",
           "features/noise_process.md",
           "features/linear_nonlinear.md",
           "features/callback_functions.md",
           "features/callback_library.md",
           "features/ensemble.md",
           "features/io.md",
           "features/low_dep.md",
           "features/progress_bar.md"
         ],
         "Analysis Tools" => Any[
           "analysis/parameterized_functions.md",
           "analysis/parameter_estimation.md",
           "analysis/bifurcation.md",
           "analysis/sensitivity.md",
           "analysis/global_sensitivity.md",
           "analysis/uncertainty_quantification.md",
           "analysis/neural_networks.md",
           "analysis/dev_and_test.md"
         ],
         "Domain Modeling Tools" => Any[
             "models/multiscale.md",
             "models/physical.md",
             "models/financial.md",
#             "models/biological.md",
             "models/external_modeling.md"
         ],
         "APIs" => Any[
#             "apis/diffeqbio.md"
			 "DiffEqBase.jl" => @show(locate_pages(DiffEqBase, DiffEqBase.API_DOC_PAGES)),
         ],
         "Extra Details" => Any[
             "extras/timestepping.md",
         ]
         ])

deploydocs(
   repo = "github.com/JuliaDiffEq/DiffEqDocs.jl.git",
   target = "build",
   osname = "linux",
   julia = "1.1",
   deps = nothing,
   make = nothing)
