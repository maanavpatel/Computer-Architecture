#include "cacheblock.h"

uint32_t Cache::Block::get_address() const {

  size_t offset = _cache_config.get_num_block_offset_bits();
	size_t i = _cache_config.get_num_index_bits();

	if(i + offset == 0){
		return _tag;
	}

	uint32_t address = (_tag << (offset + i)) + (_index << (offset));
  
  return address;
}
