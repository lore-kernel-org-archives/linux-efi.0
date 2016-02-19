From: "Zheng, Lv" <lv.zheng-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] ACPICA: Tables: Add function to remove ACPI tables
Date: Fri, 19 Feb 2016 03:19:10 +0000
Message-ID: <1AE640813FDE7649BE1B193DEA596E883BB4D5B8@SHSMSX101.ccr.corp.intel.com>
References: <1455723910-16710-1-git-send-email-matt@codeblueprint.co.uk>
 <1455723910-16710-2-git-send-email-matt@codeblueprint.co.uk>
 <1AE640813FDE7649BE1B193DEA596E883BB4D2A6@SHSMSX101.ccr.corp.intel.com>
 <CAJZ5v0hAmCKc8Qn7sKQhdGhoAXH=zmXubx295K_Nbm9npOYzBw@mail.gmail.com>
 <20160218204123.GA17042@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160218204123.GA17042-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Content-Language: en-US
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "Wysocki, Rafael J" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Josh Triplett <josh-iaAMLnmF4UmaiuxdJuQwMA@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hi,

> From: Matt Fleming [mailto:matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org]
> Subject: Re: [PATCH 1/2] ACPICA: Tables: Add function to remove ACPI tables
> 
> On Thu, 18 Feb, at 09:15:28PM, Rafael J. Wysocki wrote:
> >
> > Actually, the reason is that, as a rule, the process for ACPICA
> > patches is that they first go to upstream ACPICA and they are acquired
> > by Linux from there.
> >
> > While there are some exceptions from that process, there also are good
> > reasons for that process to be followed, including the licensing one
> > mentioned by Lv.
> >
> > All that said, Matt, if you agree that the patch can be applied under
> > the BSD license, I think we can offer help with converting it to the
> > upstream ACPICA coding conventions and applying it there.  Lv, would
> > you be able to take care of that?
> 
> I don't have any problem with that, but can we hold off on this patch
> for now? There's another approach to fixing the BGRT issue with kexec
> that's being discussed which would supersede this,
> 
>   https://lkml.kernel.org/r/20160218141544.GH2651-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org
> 
> Assuming this patch does get picked up again, I'm happy to respin it
> against upstream ACPICA, but how do I go about getting dependent
> patches merged, PATCH 2/2 in this case?
[Lv Zheng] 
I can help to port your code to the ACPICA upstream.
Rafael can help to merge the linuxized ported patch and the PATCH 2/2 if you want this solution to be upstreamed now.
Or you can wait and submit PATCH 2/2 again.
PATCH 1/2 should be a part of ACPICA 201603xx release I think.

Thanks and best regards
-Lv
