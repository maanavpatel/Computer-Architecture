#include "simplecache.h"
 
int SimpleCache::find(int index, int tag, int block_offset)
{
  // read handout for implementation details
  std::map<int, std::vector<SimpleCacheBlock>>::iterator it;
  it = _cache.find(index);
  for (int i = 0; i < it->second.size(); i++)
  {
    if (it->second[i].valid() && tag == it->second[i].tag())
    {
      return it->second[i].get_byte(block_offset);
    }
  }
  return 0xdeadbeef;
}
 
void SimpleCache::insert(int index, int tag, char data[])
{
  // read handout for implementation details
  // keep in mind what happens when you assign (see "C++ Rule of Three")
  std::map<int, std::vector<SimpleCacheBlock>>::iterator it;
  it = _cache.find(index);
  for (int i = 0; i < it->second.size(); i++)
  {
    if (!it->second[i].valid())
    {
      it->second[i].replace(tag, data);
      return;
    }
  }
  it->second[0].replace(tag, data);
}
 

