From: Robert Richter <robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v12 4/5] arm64, numa: Add NUMA support for arm64
 platforms.
Date: Tue, 1 Mar 2016 13:21:12 +0100
Message-ID: <20160301122112.GU24726@rric.localdomain>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-5-git-send-email-ddaney.cavm@gmail.com>
 <20160229173446.GG31343@rric.localdomain>
 <56D4D782.3010503@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <56D4D782.3010503-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Robert Richter <rric-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 29.02.16 15:42:58, David Daney wrote:
> On 02/29/2016 09:34 AM, Robert Richter wrote:
> >On 22.02.16 17:58:22, David Daney wrote:
> >>From: Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>

> >>+static int __init numa_init(int (*init_func)(void))
> >>+{
> >>+	int ret;
> >>+
> >>+	nodes_clear(numa_nodes_parsed);
> >>+	nodes_clear(node_possible_map);
> >>+	nodes_clear(node_online_map);
> >>+	numa_free_distance();
> 
>         ^^^^^^^^^^^^^
>      Cleanup for any previous numa_alloc_distance()
> 
> >>+
> >>+	ret = numa_alloc_distance();
> >>+	if (ret < 0)
> >>+		return ret;
> >
> >If you move this before the remaining initializers, you will need to
> >clean this up on error.
> 
> Yes, we do this.  See above.
> 
> >So better move it back after
> >numa_register_nodes() as it was in v10. This should work since
> >distances are used not earlier than numa is enabled.
> 
> I moved it here for a reason.
> 
> The init_func (of_numa_init() in this case) makes callbacks that use the
> numa_distance object.  We need to allocate it before using it. Allocating it
> after calling the init_func() is too late.

Sounds reasonable and looks sane now.

Thanks,

-Robert
