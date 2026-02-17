#include <gtest/gtest.h>

// Prefer the real header if you add it later; otherwise, fall back to a decl.
// This avoids include errors today and switches automatically when you commit src/add.hpp.
#if __has_include("../src/add.hpp")
  #include "../src/add.hpp"
#elif __has_include("add.hpp")
  #include "add.hpp"
#else
  // Fallback declaration; the implementation comes either from src/add.cpp
  // (when you add it) or from the scaffold stub injected by CMake.
  int add(int a, int b);
#endif

TEST(AdditionTest, Basic) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
    EXPECT_EQ(add(-2, -3), -5);
}

TEST(AdditionTest, Zero) {
    EXPECT_EQ(add(0, 0), 0);
    EXPECT_EQ(add(5, 0), 5);
    EXPECT_EQ(add(0, 7), 7);
}

// (No main() here; GTest provides it via gtest_main linked in CMake.)}
