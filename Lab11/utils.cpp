#include "utils.h"

uint32_t extract_tag(uint32_t address, const CacheConfig& cache_config) {
  size_t i = cache_config.get_num_index_bits();
	size_t ofs = cache_config.get_num_block_offset_bits();

	if (i + ofs == 32){
		return 0;
	}

	address = address >> (i + ofs);

	return address;
}

uint32_t extract_index(uint32_t address, const CacheConfig& cache_config) {
  size_t t = cache_config.get_num_tag_bits();
	size_t ofs = cache_config.get_num_block_offset_bits();

	if (t + ofs == 32){
		return 0;
	}

	address = address << t;
	address = address >> (t + ofs);
	return address;
}

uint32_t extract_block_offset(uint32_t address, const CacheConfig& cache_config) {
  size_t t = cache_config.get_num_tag_bits();
	size_t i = cache_config.get_num_index_bits();

	if (t + i == 32){
		return 0;
	}

	address = address << (t + i);
	address = address >> (t + i);

  return address;
}
