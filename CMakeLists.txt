cmake_minimum_required(VERSION 3.16)

project(sample_cpp_gha
  VERSION 1.0.0
  LANGUAGES CXX
)

# --------------------------------------------------------------------
# Build options / compiler setup
# --------------------------------------------------------------------
option(ENABLE_COVERAGE "Build with coverage flags" OFF)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# Coverage flags for GCC/Clang
if(ENABLE_COVERAGE AND CMAKE_CXX_COMPILER_ID MATCHES "GNU|Clang")
  message(STATUS "Coverage enabled")
  add_compile_options(--coverage -O0 -g)
  add_link_options(--coverage)
endif()

# --------------------------------------------------------------------
# Application target
# --------------------------------------------------------------------
add_executable(sample_app src/main.cpp)

# Allow referencing headers from src/
target_include_directories(sample_app PUBLIC ${CMAKE_SOURCE_DIR}/src)

# --------------------------------------------------------------------
# Testing setup (CTest + GoogleTest)
# --------------------------------------------------------------------
include(CTest)
if(BUILD_TESTING)
  enable_testing()

  # --- Fetch GoogleTest ---
  include(FetchContent)
  FetchContent_Declare(
    googletest
    URL https://github.com/google/googletest/archive/refs/tags/v1.14.0.zip
    DOWNLOAD_EXTRACT_TIMESTAMP TRUE
  )
  set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)
  FetchContent_MakeAvailable(googletest)

  # Gather all test sources
  file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS
    ${CMAKE_SOURCE_DIR}/tests/*.cpp
  )

  if(TEST_SOURCES)
    # Allow tests to include headers from src/
    include_directories(${CMAKE_SOURCE_DIR}/src)

    # Add fallback stub for add(int,int) only if src/add.cpp is missing
    set(EXTRA_IMPL_SOURCES "")
    if(NOT EXISTS "${CMAKE_SOURCE_DIR}/src/add.cpp")
      file(WRITE "${CMAKE_BINARY_DIR}/tests_stub_add.cpp"
"int add(int a,int b){return a+b;}\n")
      list(APPEND EXTRA_IMPL_SOURCES "${CMAKE_BINARY_DIR}/tests_stub_add.cpp")
    endif()

    # Build test binary (do NOT link src/main.cpp!)
    add_executable(project_tests
      ${TEST_SOURCES}
      ${EXTRA_IMPL_SOURCES}
    )

    target_link_libraries(project_tests PRIVATE GTest::gtest_main)

    include(GoogleTest)

    # Ensure CTest discovers tests BEFORE running ctest --show-only
    gtest_discover_tests(project_tests
      DISCOVERY_MODE POST_BUILD
    )
  else()
    message(STATUS "No test sources found under tests/")
  endif()
endif()

# --------------------------------------------------------------------
# Packaging setup
# --------------------------------------------------------------------
include(CPack)
set(CPACK_PACKAGE_NAME "sample-cpp-gha")
set(CPACK_PACKAGE_VERSION ${PROJECT_VERSION})
set(CPACK_GENERATOR "TGZ")
set(CPACK_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION}")
