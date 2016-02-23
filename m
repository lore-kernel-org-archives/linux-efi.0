From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 1/5] efi: ARM/arm64: ignore DT memory nodes instead of
 removing them
Date: Tue, 23 Feb 2016 13:20:10 +0100
Message-ID: <CAKv+Gu8fOKqLrnbre7sHko+hPd3wq_O6U5Ev27tN3zEc7W8Mww@mail.gmail.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
	<1456192703-2274-2-git-send-email-ddaney.cavm@gmail.com>
	<20160223115805.GB4989@leverpostej>
	<20160223121648.GI3966@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160223121648.GI3966-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 23 February 2016 at 13:16, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Tue, Feb 23, 2016 at 11:58:05AM +0000, Mark Rutland wrote:
>> On Mon, Feb 22, 2016 at 05:58:19PM -0800, David Daney wrote:
>> > From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> >
>> > There are two problems with the UEFI stub DT memory node removal
>> > routine:
>> > - it deletes nodes as it traverses the tree, which happens to work
>> >   but is not supported, as deletion invalidates the node iterator;
>> > - deleting memory nodes entirely may discard annotations in the form
>> >   of additional properties on the nodes.
>> >
>> > Since the discovery of DT memory nodes occurs strictly before the
>> > UEFI init sequence, we can simply clear the memblock memory table
>> > before parsing the UEFI memory map. This way, it is no longer
>> > necessary to remove the nodes, so we can remove that logic from the
>> > stub as well.
>>
>> This is a little bit scary, but I guess this works.
>>
>> My only concern is that when we get kexec, a subsequent kernel must also
>> have EFI memory map support, or things go bad for the next EFI-aware
>> kernel after that (as things like the runtime services may have been
>> corrupted by the kernel in the middle). It's difficult to fix the
>> general case later.
>>
>> A different option would be to support status="disabled" for the memory
>> nodes, and ignore these in early_init_dt_scan_memory. That way a kernel
>> cannot use memory without first having parsed the EFI memory map, and we
>> can still get NUMA info from the disabled nodes.
>
> So in that case, the middle, non-EFI kernel would fail to boot?
> Realistically, once you've kexec'd a non-EFI payload, I don't think you
> can rely on the EFI state remaining intact for future EFI applications.
>
> Is this really something we should be trying to police in the kernel?
>

Well, we could add entries to /reserved-memory in the stub for all the
regions UEFI cares about, that would probably be sufficient to fix
this case.
