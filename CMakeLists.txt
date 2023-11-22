cmake_minimum_required(VERSION 3.26)

find_package(Git REQUIRED)

set(PROJECT_NAME utils_cpp)
set(CMAKE_CXX_STANDARD 11)

project(${PROJECT_NAME} LANGUAGES CXX DESCRIPTION "Various CPP based utilities from different sources")

add_custom_target(version_hpp_generator
        ${CMAKE_COMMAND}
        -D NAME=${PROJECT_NAME}
        -D SRC=${CMAKE_SOURCE_DIR}/project_config.hpp.in
        -D DST=${CMAKE_CURRENT_BINARY_DIR}/include/ProjectConfig.hpp
        -D GIT_EXECUTABLE=${GIT_EXECUTABLE}
        -P ${CMAKE_SOURCE_DIR}/GenerateConfigHeader.cmake
)


set(INCLUDE_DIRECTORIES
        ${CMAKE_CURRENT_BINARY_DIR}/include
        includes/
)

set(SOURCE_FILES
        src/cpp/main.cpp
)

add_executable(${PROJECT_NAME}
        ${SOURCE_FILES})
target_include_directories(${PROJECT_NAME}
        PUBLIC ${INCLUDE_DIRECTORIES})
add_dependencies(${PROJECT_NAME} version_hpp_generator)
