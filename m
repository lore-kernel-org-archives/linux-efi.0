From: Robert Richter <robert.richter-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>
Subject: Re: [PATCH v12 4/5] arm64, numa: Add NUMA support for arm64
 platforms.
Date: Mon, 29 Feb 2016 11:12:36 +0100
Message-ID: <20160229101236.GQ24726@rric.localdomain>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-5-git-send-email-ddaney.cavm@gmail.com>
 <20160226185341.GN29125@arm.com>
 <56D0ACC4.1060605@caviumnetworks.com>
 <CAFpQJXURSKFw6RmNVLiB=YDcUiaaQLz3zMvM9gy=b1MobaCfgg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFpQJXURSKFw6RmNVLiB=YDcUiaaQLz3zMvM9gy=b1MobaCfgg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ganapatrao Kulkarni <gpkulkarni-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 27.02.16 09:43:49, Ganapatrao Kulkarni wrote:
> On Sat, Feb 27, 2016 at 1:21 AM, David Daney <ddaney-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org> wrote:
> > On 02/26/2016 10:53 AM, Will Deacon wrote:

> >>> +static __init int numa_parse_early_param(char *opt)
> >>> +{
> >>> +       if (!opt)
> >>> +               return -EINVAL;
> >>> +       if (!strncmp(opt, "off", 3)) {
> >>> +               pr_info("%s\n", "NUMA turned off");
> >>> +               numa_off = 1;
> >>> +       }
> >>> +       return 0;
> >>> +}
> >>> +early_param("numa", numa_parse_early_param);
> >>
> >>
> >> Curious, but when is this option actually useful?
> >>
> >
> > Good point.  I will remove that bit, it was used as an aid in debugging
> > while bringing up the patch set.
> 
> this is handy in debugging new platforms.
> this boot argument option forces to boot as single node dummy system
> adding all resources to node0.

This is used to disable numa in a numa enabled kernel esp. for
debugging/enabling/booting single node systems. Same kernel parameter
as for x86 and other archs. Should not being removed.

-Robert
