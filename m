From: Robert Richter <robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v14 2/6] Documentation, dt, numa: dt bindings for NUMA.
Date: Tue, 8 Mar 2016 09:34:36 +0100
Message-ID: <20160308083436.GC24726@rric.localdomain>
References: <1457049339-23351-1-git-send-email-ddaney.cavm@gmail.com>
 <1457049339-23351-3-git-send-email-ddaney.cavm@gmail.com>
 <20160307192220.GA1535@rric.localdomain>
 <56DDDAC9.1010600@caviumnetworks.com>
 <CAFpQJXWHXxa2DLKHpLHqnURUJqY-+P-vLintUoCmm3Fmh6xsZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFpQJXWHXxa2DLKHpLHqnURUJqY-+P-vLintUoCmm3Fmh6xsZQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganapatrao Kulkarni <gpkulkarni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 08.03.16 10:31:33, Ganapatrao Kulkarni wrote:
> On Tue, Mar 8, 2016 at 1:17 AM, David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> > On 03/07/2016 11:22 AM, Robert Richter wrote:
> >>
> >> On 03.03.16 15:55:35, David Daney wrote:
> >>>
> >>> From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
> >>>
> >>> Add DT bindings for numa mapping of memory, CPUs and IOs.
> >>>
> >>> Reviewed-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >>> Signed-off-by: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
> >>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >>> ---
> >>>   Documentation/devicetree/bindings/numa.txt | 272
> >>> +++++++++++++++++++++++++++++
> >>>   1 file changed, 272 insertions(+)
> >>>   create mode 100644 Documentation/devicetree/bindings/numa.txt
> >>>
> >>> diff --git a/Documentation/devicetree/bindings/numa.txt
> >>> b/Documentation/devicetree/bindings/numa.txt
> >>> new file mode 100644
> >>> index 0000000..ec5ed7c
> >>> --- /dev/null
> >>> +++ b/Documentation/devicetree/bindings/numa.txt
> >>
> >>
> >>>
> >>> +==============================================================================
> >>> +3 - distance-map
> >>>
> >>> +==============================================================================
> >>> +
> >>> +The device tree node distance-map describes the relative
> >>> +distance (memory latency) between all numa nodes.
> >>> +
> >>> +- compatible : Should at least contain "numa-distance-map-v1".
> >>> +
> >>> +- distance-matrix
> >>> +  This property defines a matrix to describe the relative distances
> >>> +  between all numa nodes.
> >>> +  It is represented as a list of node pairs and their relative distance.
> >>> +
> >>> +  Note:
> >>> +       1. Each entry represents distance from first node to second node.
> >>> +       The distances are equal in either direction.
> >>> +       2. The distance from a node to self (local distance) is
> >>> represented
> >>> +       with value 10 and all internode distance should be represented
> >>> with
> >>> +       a value greater than 10.
> >>> +       3. distance-matrix should have entries in lexicographical
> >>> ascending
> >>> +       order of nodes.
> >>> +       4. There must be only one device node distance-map which must
> >>> reside in the root node.
> >>
> >>
> >> There is no note that this one is optional, but is it right? The
> >> default is 10 for local and 20 for remote connections.
> >>
> >
> > Do we need to explicitly state that it is optional?  Many node types are
> > optional, and their binding specifications don't really talk about their
> > being optional.
> >
> > If the node is present then it has the meaning specified.
> >
> > If the node is *not* present, then the special meaning described in the
> > bindings document does not apply.
> >
> > In the case of NUMA, this means that all memory is equally distant (i.e. it
> > is *Uniform*), and we are not talking about a *Non* *Uniform* Memory
> > Architecture (NUMA) system.
> >
> >
> >> If so, then ...
> >>
> >> static int __init of_numa_parse_distance_map(void)
> >> {
> >>         int ret = -EINVAL;
> >>         struct device_node *np = of_find_node_by_path("/distance-map");
> >>
> >>         if (!np)
> >>                 return ret;
> >>
> >> must return 0 instead of -EINVAL here.
> >
> >
> > No, I don't think doing that would be correct.
> >
> > If there is no "distance-map", then of_numa_init() returns the error code.
> > This causes the code in arch/arm64/kernel/numa.c to fall back to the
> > non-NUMA "dummy_numa" case.

Which means distance-map is not optional for numa.

> IMO, return 0 will allow 2 node system to have distance-map optional.
> by default node distance is set to 10 for local node and for remote node is 20
> and this will suffice the need of 2 node system.
> by returning EINVAL, we are forcing 2 node system (and even for
> systems which has equal remote distances)
> to define distance-map.

This is exaclty the problem. numa_init() fails if there is no
distance-map node.

> > By adding your Reviewed-by: Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org> tag to
> > patch 5/6, where we select between "real" and "dummy_numa", I had assumed
> > that you agreed with this approach.

This is from v6:

       if (strcmp(uname, "distance-map") != 0)
               return 0;

-Robert
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
