
cmake_minimum_required(VERSION 3.16)
project(sample_cpp_gha VERSION 1.0.0 LANGUAGES CXX)

option(ENABLE_COVERAGE "Build with coverage flags" OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Coverage flags for GCC/Clang
if(ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  message(STATUS "Coverage enabled")
  add_compile_options(--coverage -O0 -g)
  add_link_options(--coverage)
endif()

# App
add_executable(sample_app src/main.cpp)

# Testing
include(CTest)
include(FetchContent)
FetchContent_Declare(
  googletest
  GIT_REPOSITORY https://github.com/google/googletest.git
  GIT_TAG v1.14.0
)
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
FetchContent_MakeAvailable(googletest)

# Link tests with app source so we can reuse add()
add_executable(sample_tests tests/test_sample.cpp src/main.cpp)
target_link_libraries(sample_tests GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(sample_tests)

# Packaging
include(CPack)
set(CPACK_PACKAGE_NAME "sample-cpp-gha")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
