# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

cmake_minimum_required(VERSION 3.5)

file(MAKE_DIRECTORY
  "C:/Users/Asus/Desktop/GitHUB/3d-Printer-Calculator/3d Printer Calculator/build/windows/x64/pdfium-src"
  "C:/Users/Asus/Desktop/GitHUB/3d-Printer-Calculator/3d Printer Calculator/build/windows/x64/pdfium-build"
  "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix"
  "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/tmp"
  "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/src/pdfium-download-stamp"
  "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/src"
  "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/src/pdfium-download-stamp"
)

set(configSubDirs Debug;Release;MinSizeRel;RelWithDebInfo)
foreach(subDir IN LISTS configSubDirs)
    file(MAKE_DIRECTORY "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/src/pdfium-download-stamp/${subDir}")
endforeach()
if(cfgdir)
  file(MAKE_DIRECTORY "C:/GitHUB/3d-Printer-Calculator/build/pdfium-download-prefix/src/pdfium-download-stamp${cfgdir}") # cfgdir has leading slash
endif()
