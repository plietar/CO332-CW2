#ifndef MESH_H
#define MESH_H

#include <vector>
#include <stdint.h>

#include "Global.h"
#include "Data.h"

//abstract mesh class
class Mesh 
{
	public:
	
	Data & data;
	Mesh(Data & d) : data(d) {}
	
	void createGraph(std::vector<size_t> & order);
	uint numVerts();
	
        size_t getNeighbors(size_t i, size_t *nbrs)
        {
            uint x,y,z;
            data.convertIndex( i, x, y, z );
            if ( (x+y+z)%2 == ODD_TET_PARITY ) {
                return find6Neighbors(x,y,z, nbrs);
            } else {
                return find18Neighbors(x,y,z, nbrs);
            }
        }

        size_t find6Neighbors( uint x, uint y, uint z, size_t *nbrs)
        {
            uint nx[6],ny[6],nz[6];

            for (uint i = 0; i < 6; i++) {
                nx[i] = x;
                ny[i] = y;
                nz[i] = z;
            }

            //first 6 neighbors
            nx[0] -= 1;
            ny[1] -= 1;
            nz[2] -= 1;
            nx[3] += 1;
            ny[4] += 1;
            nz[5] += 1;

            size_t j = 0;
            for (uint i = 0; i < 6; i++) {
               if (nx[i] >= data.size[0]) continue;
               if (ny[i] >= data.size[1]) continue;
               if (nz[i] >= data.size[2]) continue;

               nbrs[j] = data.convertIndex(nx[i],ny[i],nz[i]);
               j += 1;
            }
            return j;
        }

	size_t find18Neighbors( uint x, uint y, uint z, size_t *nbrs)
        {
            uint nx[18],ny[18],nz[18];

            for (uint i = 0; i < 18; i++) {
                nx[i] = x;
                ny[i] = y;
                nz[i] = z;
            }

            //first 6 neighbors
            nx[0] -= 1;
            ny[1] -= 1;
            nz[2] -= 1;
            nx[3] += 1;
            ny[4] += 1;
            nz[5] += 1;

            //the rest of the 18
            nx[6] -= 1; ny[6]  -= 1;
            nx[7] += 1; ny[7]  -= 1;
            ny[8] -= 1; nz[8]  -= 1;
            ny[9] += 1; nz[9]  -= 1;
            nz[10]-= 1; nx[10] -= 1;
            nz[11]+= 1; nx[11] -= 1;

            nx[12] -= 1; ny[12] += 1;
            nx[13] += 1; ny[13] += 1;
            ny[14] -= 1; nz[14] += 1;
            ny[15] += 1; nz[15] += 1;
            nz[16] -= 1; nx[16] += 1;
            nz[17] += 1; nx[17] += 1;

            size_t j = 0;
            for (uint i = 0; i < 18; i++) {
               if (nx[i] >= data.size[0]) continue;
               if (ny[i] >= data.size[1]) continue;
               if (nz[i] >= data.size[2]) continue;

               nbrs[j] = data.convertIndex(nx[i],ny[i],nz[i]);
               j += 1;
            }
            return j;
        }
};

#endif
