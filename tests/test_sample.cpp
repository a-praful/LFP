
#include <gtest/gtest.h>

int add(int a, int b);

TEST(AdditionTest, Basic) {
    EXPECT_EQ(add(2, 3), 5);
    EXPECT_EQ(add(-1, 1), 0);
}

TEST(AdditionTest, Zero) {
    EXPECT_EQ(add(0, 0), 0);
}
