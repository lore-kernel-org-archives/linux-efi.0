From: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: Re: [PATCH v1 1/8] lib/uuid: Introduce uuid_{be|le}_cmp_p{p}()
 helpers
Date: Mon, 24 Apr 2017 11:53:30 +0300
Message-ID: <1493024010.24567.151.camel@linux.intel.com>
References: <20170421144645.45189-1-andriy.shevchenko@linux.intel.com>
         <5B8DA87D05A7694D9FA63FD143655C1B543E8399@hasmsx108.ger.corp.intel.com>
         <CAHp75VeTgdE=OiRNS6JrH3M-rF+jpPVgmd4G+n321=vhVE4XiA@mail.gmail.com>
         <1492975128.3570.2.camel@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492975128.3570.2.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Winkler, Tomas" <tomas.winkler-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <andy.shevchenko-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Koul, Vinod" <vinod.koul-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org" <devel-tBiZLqfeLfOHmIFyCCdPziST3g8Odh+X@public.gmane.org>, "kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org" <kwankhede-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>, "kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <kys-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org" <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org" <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, "rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, "sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org" <sthemmin-0li6OtcxBFHby3iVrkZq2A@public.gmane.org>, "srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <srinivas.pandruvada-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, "mika.westerberg-VuQAYsv1563Yd54FQh9/CA@public.gmane.org" <mik>
List-Id: linux-efi@vger.kernel.org

On Sun, 2017-04-23 at 20:20 +0000, Winkler, Tomas wrote:
> On Sun, 2017-04-23 at 15:42 +0300, Andy Shevchenko wrote:
> > On Sun, Apr 23, 2017 at 1:29 PM, Winkler, Tomas <tomas.winkler@intel
> > .
> > com> wrote:
> > > > New helpers take pointers to uuid_{be|le} as parameters.
> > > > 
> > > > When using them on a raw data we don't need to do an ugly
> > > > dereference and,
> > > > in some cases, a type casting.
> > > 
> > > I think this going overboard, the _pp types  are just enough.
> > 
> > I looked at existing users and there are cases like
> > #define XXX_UUID UUID_...(a, b, c, ...)
> > 
> > uuid_.*_cmp(value, XXX_UUID)
> > 
> > For _pp variant if would be _cmp_pp(value, &XXX_UUID) which is
> > slightly worse than for _p variant.
> 
> 
> Maybe it's worth to actually replace the defines with variables than
> to
> create an interface with all the permutations.

Maybe. I didn't estimate the number of users that would be in a scope.

-- 
Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Intel Finland Oy
