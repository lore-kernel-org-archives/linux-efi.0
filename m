From: Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v12 1/5] efi: ARM/arm64: ignore DT memory nodes instead of
 removing them
Date: Wed, 24 Feb 2016 13:30:55 -0600
Message-ID: <CAL_Jsq+e9PXi936Dm6V9mYBFTa+_tyw4yWx3R8NyASfp0mK2xQ@mail.gmail.com>
References: <1456192703-2274-1-git-send-email-ddaney.cavm@gmail.com>
 <1456192703-2274-2-git-send-email-ddaney.cavm@gmail.com> <20160223115805.GB4989@leverpostej>
 <56CDFE6C.4020600@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56CDFE6C.4020600-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: devicetree-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Wed, Feb 24, 2016 at 1:03 PM, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On 2/23/2016 3:58 AM, Mark Rutland wrote:
>> Hi,
>>
>> On Mon, Feb 22, 2016 at 05:58:19PM -0800, David Daney wrote:
>>> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>>
>>> There are two problems with the UEFI stub DT memory node removal
>>> routine:
>>> - it deletes nodes as it traverses the tree, which happens to work
>>>   but is not supported, as deletion invalidates the node iterator;
>>> - deleting memory nodes entirely may discard annotations in the form
>>>   of additional properties on the nodes.
>>>
>>> Since the discovery of DT memory nodes occurs strictly before the
>>> UEFI init sequence, we can simply clear the memblock memory table
>>> before parsing the UEFI memory map. This way, it is no longer
>>> necessary to remove the nodes, so we can remove that logic from the
>>> stub as well.
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
> Please do not play games of treating nodes with status="disabled" as
> valid nodes.  The mindset should be if it is disabled, it does not exist.
>
> There have been two bugs reported in the last week where code should
> have been ignoring disabled nodes and failed to.  An audit of code
> scanning all nodes instead of all enabled nodes is now on my todo list.

Perhaps we should merge the default/available variants of iterators
into one. I suspect there are some valid uses. Otherwise, we could
also just not even populate those nodes in the live tree. There are
some cases where the kernel changes the status.

Rob
--
To unsubscribe from this list: send the line "unsubscribe devicetree" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
