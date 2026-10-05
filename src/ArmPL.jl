module ArmPL

import LinearAlgebra.BLAS

function __init__()
    # check if <LD_LIBRARY_PATH> is set AND
    # check if <libarmpl_ilp64_mp.so> is present in <LD_LIBRARY_PATH>:
  if "LD_LIBRARY_PATH" in keys(ENV) && 
    any(x -> isfile(joinpath(x, "libarmpl_ilp64_mp.so")), split(ENV["LD_LIBRARY_PATH"], ":"))
    
    # link <libarmpl_ilp64_mp.so> instead of default libblas.so; AND
    # clear out all previous mappings before setting new ones 
      # (change to false if layering of libraries is required); AND
    # verbose output:
    println("Linking => ", joinpath(ENV["LD_LIBRARY_PATH"], "libarmpl_ilp64_mp.so"))
    BLAS.lbt_forward("libarmpl_ilp64_mp.so", clear=true, verbose=true)

    # print current BLAS configuration:
        # Note: BLAS.set_num_threads() and BLAS.get_num_threads() are vendor-specific APIs
        # and in this case are not supported by libblastrampoline;
        # <libarmpl_ilp64_mp.so> sets number of BLAS threads based on <OMP_NUM_THREADS> 
        # environmental variable.
    println("BLAS configuration => ", BLAS.get_config())

    # inform if all is fine:
    println("ArmPL ready.")
  
  else
    # if all is not fine, provide info about potential solutions:
    @error "
    Basic requirements to use <ArmPL> are not met.
    Please check if:
    - Arm Performance Libraries are present on the system
      (for details about installation procedure please see:
      https://developer.arm.com/downloads/-/arm-performance-libraries);
    and / or if
    - <LD_LIBRARY_PATH> environmental variable is set to
      a directory containing <libarmpl_ilp64_mp.so>
      i.e. LD_LIBRARY_PATH=/opt/arm/armpl_22.0.2_gcc-11.2/lib julia."
  end
end

end # module
