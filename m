From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v15 1/6] efi: ARM/arm64: ignore DT memory nodes instead of
 removing them
Date: Fri, 18 Mar 2016 14:11:20 +0100
Message-ID: <CAKv+Gu_6S+ME8MH8DZ32q+hKcRiOqp=nRy6Reryy5v=J7yE2vg@mail.gmail.com>
References: <1457481587-8976-1-git-send-email-ddaney.cavm@gmail.com>
	<1457481587-8976-2-git-send-email-ddaney.cavm@gmail.com>
	<20160318122609.GS2619@codeblueprint.co.uk>
	<CAKv+Gu8STa=tF0o1qje6LorYxzBon704Q_O2U=cvigg9v53hZw@mail.gmail.com>
	<20160318125600.GT2619@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160318125600.GT2619-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 18 March 2016 at 13:56, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 18 Mar, at 01:31:59PM, Ard Biesheuvel wrote:
>>
>> Typically, the UEFI memory map is more restrictive, since it does not
>> only describe where the memory lives, but also which parts of it the
>> firmware has claimed for its own use. So if both memory nodes and the
>> UEFI memory map are available, we must use the latter anyway, and so
>> it makes sense to ignore the former. Alternatively, we could sanity
>> check the memory nodes against the memory map, but it is simpler just
>> to ignore them.
>>
>> However, that caused some problems in the past, since discovering the
>> memory nodes occurs before the EFI entry point is invoked, and so it
>> was decided that we strip the memory nodes rather than ignore them.
>
> Thanks Ard.
>
> Once you've stripped the memory nodes as represented in memblock,
> there's no way for the memory nodes to re-appear in one form or
> another after that point, right? The EFI memory map is the sole memory
> layout either via memblock or if it's queried directly?

Well, the significance of this patch in this series is that the memory
nodes contain additional properties that describe the NUMA topology,
which the UEFI memory map does not allow us to do. At some point, we
may decide to capture this information in a different way (i.e., a
separate configuration table), but for now, I think this is fine,
especially since stripping nodes is a bit of a blunt tool.
