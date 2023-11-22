if (GIT_EXECUTABLE)
    get_filename_component(SRC_DIR ${SRC} DIRECTORY)
    # Generate a git-describe version string from Git repository tags
    message(STATUS "Trying to find available GIT Information")
    execute_process(
            COMMAND ${GIT_EXECUTABLE} describe --tags --dirty --match "v*"
            WORKING_DIRECTORY ${SRC_DIR}
            OUTPUT_VARIABLE GIT_DESCRIBE_VERSION
            RESULT_VARIABLE GIT_DESCRIBE_ERROR_CODE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    execute_process(
            COMMAND ${GIT_EXECUTABLE} log -1 --format=%h
            WORKING_DIRECTORY ${SRC_DIR}
            OUTPUT_VARIABLE GIT_HASH
            RESULT_VARIABLE GIT_HASH_ERROR_CODE
            OUTPUT_STRIP_TRAILING_WHITESPACE
    )

    if (NOT GIT_HASH_ERROR_CODE)
        if (NOT GIT_DESCRIBE_ERROR_CODE)
            set(PROJECT_VERSION ${GIT_DESCRIBE_VERSION}-${GIT_HASH})
        else ()
            message(WARNING "Unable to find any GIT TAGS, Error Code: ${GIT_DESCRIBE_ERROR_CODE}")
        endif ()
    else ()
        message(WARNING "Unable to find any HASH for HEAD, Error Code: ${GIT_HASH_ERROR_CODE}")
    endif ()

endif ()

# Final fallback: Just use a bogus version string that is semantically older
# than anything else and spit out a warning to the developer.
if (NOT DEFINED PROJECT_VERSION)
    if (DEFINED GIT_HASH)
        set(PROJECT_VERSION v0.0.0-${GIT_HASH})
    else ()
        set(PROJECT_VERSION v0.0.0-SNAPSHOT)
    endif ()
    message(WARNING "Failed to determine PROJECT_VERSION from Git. Using default version \"${PROJECT_VERSION}\".")
endif ()
set(PROJECT_NAME ${NAME})

configure_file(${SRC} ${DST} @ONLY)