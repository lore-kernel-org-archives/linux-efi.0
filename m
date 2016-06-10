From: "Elliott, Robert (Persistent Memory)" <elliott-ZPxbGqLxI0U@public.gmane.org>
Subject: RE: [PATCH] efi: kernel param for legacy NVDIMM support
Date: Fri, 10 Jun 2016 14:46:26 +0000
Message-ID: <DF4PR84MB016965ECBD5DF92D9091E816AB500@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <CAA9_cmeQUaxShZfnARt=j4iResPTwjxrK_toA6CJgtRAnzEgYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAA9_cmeQUaxShZfnARt=j4iResPTwjxrK_toA6CJgtRAnzEgYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Williams <dan.j.williams-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org" <linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org] On
> Behalf Of Dan Williams
> Sent: Friday, June 10, 2016 9:28 AM
> To: Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>; linux-
> efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH] efi: kernel param for legacy NVDIMM support
> 
> On Fri, Jun 10, 2016 at 1:48 AM, Yigal Korman <yigal-/8YdC2HfS5554TAoqtyWWQ@public.gmane.org>
> wrote:
> > On Thu, Jun 9, 2016 at 11:27 PM, Dan Williams
...
> We should always look for an NFIT in the type-14 case.  Injecting a
> crafted NFIT for this legacy case removes confusion as there is only
> one action the kernel takes and no possibility for collisions.  I
> also
> do not want to make it easier for firmware developers to skip the
> necessary due diligence to decide whether attributes like numa
> topology, posted write queue flush mechanisms, and media health,
> etc...  need description.

I'll also reiterate that NVDIMM ranges may also be reported using
the UEFI and E820 reserved types.  The simple E820 and UEFI memory
map persistent memory type values do not contain enough information
to properly talk to an NVDIMM; the information in ACPI NFIT is
crucial.

---
Robert Elliott, HPE Persistent Memory
