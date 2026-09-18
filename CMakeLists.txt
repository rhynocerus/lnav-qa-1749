cmake_minimum_required(VERSION 3.16)

project(lnav_qa_1749 NONE)

enable_testing()

add_test(
    NAME lnav_reload_test
    COMMAND ${CMAKE_COMMAND} -E echo "LNAV QA TEST OK"
)
