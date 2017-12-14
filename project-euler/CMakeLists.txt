# MIT/Expat License
#
# Copyright (c) 2017 Shlomi Fish
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

INCLUDE ("${CMAKE_SOURCE_DIR}/cmake/shlomif_common_bootstrap.cmake")
SHLOMIF_COMMON_SETUP("${private_mod_path}")

CMAKE_POLICY(SET CMP0054 NEW)

SHLOMIF_ADD_COMMON_C_FLAGS()
SHLOMIF_FINALIZE_FLAGS()

SET (PKGDATADIR_SUBDIR "freecell-solver")
SET (RELATIVE_PKGDATADIR "${RELATIVE_DATADIR}/${PKGDATADIR_SUBDIR}")
SET (PKGDATADIR "${DATADIR}/${PKGDATADIR_SUBDIR}")

# Introduces VERSION , CPACK_PACKAGE_VERSION_MAJOR,
# CPACK_PACKAGE_VERSION_MAJOR, and CPACK_PACKAGE_VERSION_PATCH
READ_VERSION_FROM_VER_TXT()

# This is the equivalent to perform a "make dist"/"make distdir" etc.
SET(CPACK_PACKAGE_NAME "freecell-solver")
SET(CPACK_PACKAGE_DESCRIPTION_SUMMARY "Freecell Solver")
SET(CPACK_PACKAGE_VENDOR "Shlomi Fish")
SET(CPACK_PACKAGE_DESCRIPTION_FILE "${CMAKE_CURRENT_SOURCE_DIR}/README.txt")
SET(CPACK_RESOURCE_FILE_LICENSE "${CMAKE_CURRENT_SOURCE_DIR}/COPYING.txt")

SET(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_DESCRIPTION_SUMMARY} ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

SET(CPACK_SOURCE_PACKAGE_FILE_NAME "${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}")

SET (base_with_ver "freecell-solver-[0-9]+\\\\.[0-9]+\\\\.[0-9]+")

SET(CPACK_SOURCE_IGNORE_FILES
    "/.deps/"
    "~$"
    "\\\\.pyc$"
    "/tags$"
    "fcs-freecell-24\\\\.txt$"
    "^${PROJECT_SOURCE_DIR}/ids\\\\.txt$"
    "^${PROJECT_SOURCE_DIR}/scripts/ids-whitelist(\\\\.txt)?"
    "/(build|BUILD|B)/"
    "/Presets/testing-presets"
    "^${PROJECT_SOURCE_DIR}/patsolve-shlomif/(\\\\.(git|hg)|appveyor|\\\\.travis|CI-testing)"
    "^${PROJECT_SOURCE_DIR}/patsolve-shlomif/patsolve/(OLD|Rejects|cmake|ga|patsolve-specific|t/)"
    "^${PROJECT_SOURCE_DIR}/patsolve-shlomif/patsolve/(CMakeLists\\\\.txt|COPYING|Manifest|Parameters|check_layout|config\\\\.h\\\\.in|convert_[a-z]+|fc-solve\\\\.ico|dondorf-king\\\\.bmp|threaded_main\\\\.c|patmain\\\\.c|run-tests\\\\.pl|read_layout\\\\.h|print_layout\\\\.h)$"
)

FIND_LIBM()
FUNCTION(exe prob_id suffix src)
    SET(_name "euler-${prob_id}-${suffix}.exe")
    ADD_EXECUTABLE( "${_name}" "${src}" )
    TARGET_LINK_LIBRARIES("${_name}" ${MATH_LIB_LIST})
ENDFUNCTION()

FUNCTION(gmp_exe prob_id suffix src)
    SET(_name "euler-${prob_id}-${suffix}.exe")
    ADD_EXECUTABLE( "${_name}" "${src}" )
    TARGET_LINK_LIBRARIES("${_name}" "gmp" "gmpxx")
ENDFUNCTION()

exe("10" "half" "10/10_half.c")
exe("10" "micro-opt" "10/10_micro_opt.c")
exe("10" "mine" "10/10.c")
exe("141" "v1" "141/euler_141_v1.c")
exe("141" "v2" "141/euler_141_v2.cpp")
exe("145" "v1" "145/euler_145_v1.c")
exe("146" "v1" "146/euler_146_v1.c")
exe("146" "v2" "146/euler_146_v2.c")
exe("153" "v1" "153/euler_153_v1.c")
exe("154" "v1" "154/euler_154_v1.c")
exe("167" "v1" "167/euler_167_v1.cpp")
exe("193" "v1" "193/euler_193_v1.cpp")
exe("212" "v1" "212/euler_212_v1.cpp")
exe("223" "v1" "223/euler_223_v1.cpp")
exe("229" "v1" "229/euler_229_v1.cpp")
exe("235" "v1" "235/euler_235_v1.cpp")
exe("238" "v1" "238/euler_238_v1.cpp")
exe("258" "v1" "258/euler_258_v1.cpp")
exe("261" "v1" "261/euler_261_v1.cpp")
exe("3" "mini-factor-cpp-v1" "3/mini_factor.cpp")
exe("301" "v1" "301/euler_301.c")
exe("305" "v1" "305/euler_305_v1.cpp")
exe("372" "v2" "372/euler_372_v2.cpp")
exe("401" "v2" "401/euler_401_v2.cpp")
exe("407" "v1" "407/euler_407_v1.cpp")
exe("423" "v1" "423/euler_423_v1.cpp")
exe("433" "v2" "433/euler_433_v2.cpp")
exe("443" "v1" "443/euler_443_v1.c")
exe("455" "v1" "455/euler_455_v1.c")
exe("455" "v2" "455/euler_455_v2.c")
exe("455" "v3" "455/euler_455_v3.c")
exe("455" "v4" "455/euler_455_v4.c")
exe("47" "v5" "47/euler_47_v5.c")
exe("485" "v1" "485/euler_485_v1.cpp")
exe("518" "v1" "518/euler_518_v1.cpp")
exe("518" "v2" "518/euler_518_v2.cpp")
exe("521" "v2" "521/euler_521_v2.cpp")
exe("521" "v3" "521/euler_521_v3.cpp")
exe("521" "v4" "521/euler_521_v4.cpp")
exe("521" "vpr" "521/gen-prime-divs.cpp")
exe("551" "v1" "551/euler_551_v1.cpp")
exe("551" "v2" "551/euler_551_v2.cpp")
exe("555" "v1" "555/euler_555_v1.cpp")
exe("578" "v1" "578/euler_578_v1.cpp")
exe("581" "v2" "581/euler_581_v2.cpp")
exe("611" "v1" "611/euler_611_v1.cpp")
exe("611" "v2" "611/euler_611_v2.cpp")
exe("611" "v3" "611/euler_611_v3.cpp")
exe("67" "v1" "67/euler_67_v1.cpp")
exe("75" "v1" "75/euler_75_v1.c")

gmp_exe("266" "muke" "266/euler_266.cpp")
gmp_exe("284" "v1" "284/euler_284_v1.cpp")
gmp_exe("320" "v1" "320/euler_320_v1.cpp")

# requires https://github.com/fjtapia/countertree_2.0
# exe("593" "F" "593/F.cpp")
