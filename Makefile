all: build

configure:
	cmake -S llvm -B build -G 'Unix Makefiles' \
		-DCMAKE_BUILD_TYPE="Debug" \
		-DLLVM_ENABLE_PROJECTS="clang" \
		-DLLVM_TARGETS_TO_BUILD="RISCV" \
		-DLLVM_DEFAULT_TARGET_TRIPLE="riscv64-unknown-elf"

build:
	make -C build -j 8 clang llvm-objdump

.PHONY: configure build
