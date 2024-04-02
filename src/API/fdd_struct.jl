module FDDStruct

export Dev

"""
Dev

Note: It should immutable in julia execution scope.
It is only editable in C library.
"""
struct Dev
    id::Ref{Cchar}
    next::Ptr{Dev}
end

end