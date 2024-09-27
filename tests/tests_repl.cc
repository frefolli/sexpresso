#include <iostream>
#include <sexpresso.hh>

int main() {
  sexpresso::Sexp sexp;
  while (true) {
    std::cout << "|>";
    std::cin >> sexp;
    std::cout << std::endl << ":= " << sexp << std::endl;
  }
}
