// rysv-test-type: compile
// rysv-description: デフォルトコンストラクタが noexcept(false) の場合

#include <rysv/check_regulation.hpp>

RYSV_CHECK_REGULATION(int, std::allocator<int>)
#include <vector.hpp>

static_assert(!noexcept(std::vector<int>()));
