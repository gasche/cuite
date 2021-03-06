#ifndef CUITE_GC
#define CUITE_GC

#include "cuite_csupport.h"
/* GC interface */

struct CUITE_Region
{
  cuite_region_t region;

  CUITE_Region() : region(cuite_region_enter())
  {
    cuite_assert(!cuite_ocaml_released);
  }

  ~CUITE_Region()
  {
    cuite_region_leave(region);
  }
};

struct CUITE_AcquireRegion
{
  cuite_region_t region;
  bool acquired;

  CUITE_AcquireRegion(bool _acquired) :
    acquired(_acquired), region(cuite_region_enter())
  {
    cuite_assert(!cuite_ocaml_released);
  }

  ~CUITE_AcquireRegion()
  {
    cuite_region_leave(region);
    if (acquired) cuite_release_ocaml();
  }
};

struct CUITE_ReleaseRegion
{

  CUITE_ReleaseRegion()
  {
    cuite_release_ocaml();
  }

  ~CUITE_ReleaseRegion()
  {
    cuite_assert(cuite_acquire_ocaml());
  }
};

/* Setup a cuite region just for allocating. Abort if the OCaml runtime was released. */
#define CUITE_GC_REGION CUITE_Region _region

/* Setup a cuite region that reacquire the OCaml runtime if necessary. */
#define CUITE_OCAML_REGION CUITE_AcquireRegion _region(cuite_acquire_ocaml())

/* Release the OCaml runtime in a lexical scope. */
#define CUITE_WITHOUT_OCAML CUITE_ReleaseRegion _release

#endif /* !CUITE_GC */
