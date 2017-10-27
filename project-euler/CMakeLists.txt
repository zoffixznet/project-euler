CMAKE_MINIMUM_REQUIRED(VERSION 3.0)

INCLUDE ("${CMAKE_SOURCE_DIR}/cmake/shlomif_common_bootstrap.cmake")
SHLOMIF_COMMON_SETUP("${private_mod_path}")

CMAKE_POLICY(SET CMP0054 NEW)

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

FUNCTION(exe prob_id suffix src)
    ADD_EXECUTABLE(
        "euler-${prob_id}-${suffix}.exe"
        "${src}"
    )
ENDFUNCTION()

exe("238" "v1" "238/euler_238_v1.cpp")
exe("401" "v2" "401/euler_401_v2.cpp")
