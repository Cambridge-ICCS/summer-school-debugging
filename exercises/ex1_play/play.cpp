#include <iostream>
#include <array>

void multiply_by_two(int &var) {
    var = 2 * var;
}

int main() {
    std::array<int, 10> data;
    int int_var;
    float real_var;
    double double_var;
    bool logical_var;

    // Populate the array with values from 1 to 10
    for (int i = 0; i < 10; ++i) {
        data[i] = i + 1;
    }

    // Assign values to variables
    int_var = 5;
    real_var = 3.14f;
    double_var = 2.718281828459045;
    logical_var = true;

    multiply_by_two(int_var);

    // Check the logical variable and print if true
    if (logical_var) {
        std::cout << "The logical variable is true." << std::endl;
    }

    // Print all variables
    std::cout << "Data array: ";
    for (const auto &val : data) {
        std::cout << val << " ";
    }
    std::cout << std::endl;
    std::cout << "Integer variable: " << int_var << std::endl;
    std::cout << "Real variable: " << real_var << std::endl;
    std::cout << "Double precision variable: " << double_var << std::endl;
    std::cout << "Logical variable: " << std::boolalpha << logical_var << std::endl;

    return 0;
}
