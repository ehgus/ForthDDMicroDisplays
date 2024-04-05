module Wrapper

using ..Preferences
import Libdl: dlopen, dlclose

# DLL directory

function get_library_path()
    default_dir = "C:/Program Files/Forth dimension display/Software/R11CommLib/examples/msvc/lib"
    lib_path = @load_preference("shared library path", default_dir)

    if !isdir(lib_path)
        @error("the library does not exists")
        lib_path = default_dir
    else
        R11_SDK_dll_path = joinpath(lib_path, "R11CommLib-1.8-x64.dll")
        if !isfile(R11_SDK_dll_path)
            @error("'R11CommLib-1.8-x64.dll' should exist at the library path")
            lib_path = default_dir
        end
    end

    return lib_path
end

const shared_lib_path = get_library_path()

function set_library_path!(lib_path; export_prefs::Bool = false)
    if isnothing(lib_path) || ismissing(lib_path)
        # supports `Preferences` sentinel values `nothing` and `missing`
    elseif !isa(lib_path,String)
        throw(ArgumentError("Invalid provider"))
    elseif !isdir(lib_path)
        throw(ArgumentError("the library does not exists"))
    else
        lib_path = abspath(lib_path)
        R11_SDK_dll_path = joinpath(lib_path, "R11CommLib-1.8-x64.dll")
        if !isfile(R11_SDK_dll_path)
            throw(ArgumentError("'R11CommLib-1.8-x64.dll' should exist at the library path"))
        end
    end
    set_preferences!(@__MODULE__, "shared library path" => lib_path;export_prefs, force = true)
    if !samefile(lib_path, shared_lib_path)
        # Re-fetch to get default values in the event that `nothing` or `missing` was passed in.
        lib_path = get_library_path()
        @info("The path of shared library is changed; restart Julia for this change to take effect", lib_path)
    end
end

const R11_SDK_DLL = Ref{Ptr{Cvoid}}()
function __init__()
    R11_SDK_DLL[] = dlopen(joinpath(shared_lib_path, "R11CommLib-1.8-x64.dll"))
    finalizer((x->dlclose(x[])),R11_SDK_DLL)
end

include("alias.jl")
include("fdd_struct.jl")
include("fdd_error.jl")
include("fdd_common_lib.jl")
include("fdd_r11_lib.jl")

using .TypeAlias
using .FDDstruct

function lib_version(target_lib::AbstractString)
    version_name = zeros(Cchar,MAX_TEXT_LEN)
    if target_lib == "common"
        FDD.LibGetVersion( version_name)
    elseif target_lib == "R11"
        R11.LibGetVersion( version_name, MAX_TEXT_LEN)
    else
        error("Supported target libraries are 'common' and 'R11'.")
    end
    unsafe_string(pointer(version_name))
end

end # module Wrapper