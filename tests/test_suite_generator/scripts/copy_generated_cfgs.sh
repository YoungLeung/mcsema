#!/usr/bin/env bash
set -e

ARCHS=("x86" "amd64")
PLATFORMS=("linux")

main() {
  if [ $# -ne 1 ] ; then
    printf "Usage:\n\tcopy_generated_cfgs.sh <test directory>\n"
    return 1
  fi

  local test_dir="$1"
  if [ ! -d "${test_dir}" ]; then
    printf "could not find test directory: ${test_dir}\n"
    exit 1
  fi

  local generated_dir="$(realpath $(dirname $(readlink -f $0))/../generated/prebuilt_cfg/)"
  if [ ! -d "${generated_dir}" ]; then
    printf "could not destination directory: ${generated_dir}\n"
    exit 1
  fi

  printf "> using test directory: ${test_dir}\n"
  printf "> copying tests to generated directory: ${generated_dir}\n"

  for arch in "${ARCHS[@]}"; do
    for plat in "${PLATFORMS[@]}"; do
      local this_cfg_dir="${test_dir}/${arch}/${plat}/cfg"
      if [ -d "${this_cfg_dir}" ]; then
        printf "> Processing ${arch} / ${plat} \n"
        if [ -d "${generated_dir}/${arch}/${plat}" ]; then
          rm -rf "${generated_dir}/${arch}/${plat}"
        fi

        mkdir -p "${generated_dir}/${arch}/${plat}"
        cp -R -v "${this_cfg_dir}" "${generated_dir}/${arch}/${plat}/"
      else
        printf "! Could not find CFGs for ${arch} / ${plat} \n"
        printf "  ! Looked in: ${this_cfg_dir}"
      fi
    done
  done

}

main $@
