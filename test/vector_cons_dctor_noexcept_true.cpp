// rysv-test-type: compile
// rysv-description: デフォルトコンストラクタが noexcept(true) の場合

#include <rysv/check_regulation.hpp>

RYSV_CHECK_REGULATION(int, std::allocator<int>)
#include <vector.hpp>

static_assert(noexcept(re::vector<int, std::allocator<int> >()));
