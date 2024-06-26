// Author: Isak Andersson 2016 bitpuffin dot com

#define CATCH_CONFIG_MAIN
#include "catch.hh"

#include <sexpresso.hh>
#include <sstream>

TEST_CASE("<< operator") {
	auto err = std::string{};

	auto s = sexpresso::parse("wow (hello everybody (we will (shortly do) (some (stuff))) \"\")", err);
	REQUIRE(s.value.sexp[1].childCount() == 4);
	auto ss = std::ostringstream{};
	ss << s;
	REQUIRE(ss.str() == "wow (hello everybody (we will (shortly do) (some (stuff))) \"\")");
	
}
