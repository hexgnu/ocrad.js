# Define your emscripten path. Change it you don't use emscripten portable
# PATH="$HOME/emsdk_portable:$HOME/emsdk_portable/clang/fastcomp/build_master_64/bin:$HOME/emsdk_portable/node/4.1.1_64bit/bin:$HOME/emsdk_portable/emscripten/master:/usr/local/bin:/usr/bin:/bin:/usr/local/games:/usr/games"
# EMSCRIPTEN="$HOME/emsdk_portable/emscripten/master"

# autogenerate some parts of the postcode
python3 src/generate.py

OUTPUTS="arg_parser.o bitmap.o blob.o character.o character_r11.o character_r12.o character_r13.o common.o feats.o feats_test0.o feats_test1.o iso_8859.o mask.o ocradlib.o page_image.o page_image_io.o profile.o rational.o rectangle.o segment.o textblock.o textline.o textline_r2.o textpage.o track.o ucs.o user_filter.o"

# compile ocrad
mkdir -p pkg
cd ocrad-*
emconfigure ./configure
emmake make
emcc -02 --memory-init-file 0 -v -s 'EXTRA_EXPORTED_RUNTIME_METHODS=["cwrap"]' -s EXTRA_EXPORTED_RUNTIME_METHODS=['addOnInit','ccall','cwrap'] -s TOTAL_MEMORY=33554432 -s EXPORTED_FUNCTIONS="['_OCRAD_set_exportfile', '_OCRAD_transform', '_OCRAD_add_filter', '_OCRAD_version', '_OCRAD_open', '_OCRAD_close', '_OCRAD_get_errno', '_OCRAD_set_image', '_OCRAD_set_image_from_file', '_OCRAD_set_utf8_format', '_OCRAD_set_threshold', '_OCRAD_scale', '_OCRAD_recognize', '_OCRAD_result_blocks', '_OCRAD_result_lines', '_OCRAD_result_chars_total', '_OCRAD_result_chars_block', '_OCRAD_result_chars_line', '_OCRAD_result_line', '_OCRAD_result_first_character']" $OUTPUTS -o ../pkg/ocrad.js
# emcc -02 --memory-init-file 0 -v -s 'EXTRA_EXPORTED_RUNTIME_METHODS=["cwrap"]' -s TOTAL_MEMORY=33554432 -s EXPORTED_FUNCTIONS="['_OCRAD_set_exportfile', '_OCRAD_transform', '_OCRAD_add_filter', '_OCRAD_version', '_OCRAD_open', '_OCRAD_close', '_OCRAD_get_errno', '_OCRAD_set_image', '_OCRAD_set_image_from_file', '_OCRAD_set_utf8_format', '_OCRAD_set_threshold', '_OCRAD_scale', '_OCRAD_recognize', '_OCRAD_result_blocks', '_OCRAD_result_lines', '_OCRAD_result_chars_total', '_OCRAD_result_chars_block', '_OCRAD_result_chars_line', '_OCRAD_result_line', '_OCRAD_result_first_character']" $OUTPUTS -o ../pkg/ocrad.js --pre-js ../src/pre.js --post-js ../src/post.js
make clean
