From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v16 1/6] efi: ARM/arm64: ignore DT memory nodes instead of
 removing them
Date: Fri, 15 Apr 2016 16:06:08 +0200
Message-ID: <CAKv+Gu_7m0FH5CHLOEPu8uwUKOVMLANGYMd8pvqvp7r+q2Mk4g@mail.gmail.com>
References: <1460155828-8690-1-git-send-email-ddaney.cavm@gmail.com>
	<1460155828-8690-2-git-send-email-ddaney.cavm@gmail.com>
	<20160415140357.GK22906@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160415140357.GK22906-5wv7dgnIgG8@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: David Daney <ddaney.cavm-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, Rob Herring <robh+dt-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Frank Rowand <frowand.list-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Grant Likely <grant.likely-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Pawel Moll <pawel.moll-5wv7dgnIgG8@public.gmane.org>, Ian Campbell <ijc+devicetree-KcIKpvwj1kUDXYZnReoRVg@public.gmane.org>, Kumar Gala <galak-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Ganapatrao Kulkarni <gkulkarni-M3mlKVOIwJVv6pq1l3V1OdBPR1lH4CV8@public.gmane.org>, Robert Richter <rrichter-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <devicetree-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 April 2016 at 16:03, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org> wrote:
> On Fri, Apr 08, 2016 at 03:50:23PM -0700, David Daney wrote:
>> From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>>
>> There are two problems with the UEFI stub DT memory node removal
>> routine:
>> - it deletes nodes as it traverses the tree, which happens to work
>>   but is not supported, as deletion invalidates the node iterator;
>> - deleting memory nodes entirely may discard annotations in the form
>>   of additional properties on the nodes.
>>
>> Since the discovery of DT memory nodes occurs strictly before the
>> UEFI init sequence, we can simply clear the memblock memory table
>> before parsing the UEFI memory map. This way, it is no longer
>> necessary to remove the nodes, so we can remove that logic from the
>> stub as well.
>>
>> Signed-off-by: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
>> Signed-off-by: David Daney <david.daney-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
>> ---
>>  drivers/firmware/efi/arm-init.c    |  8 ++++++++
>>  drivers/firmware/efi/libstub/fdt.c | 24 +-----------------------
>>  2 files changed, 9 insertions(+), 23 deletions(-)
>
> Matt, are you ok with me taking this through the arm64 tree? (since the
> NUMA patches depend on it). If so, please can I have your ack?
>

Matt gave his Reviewed-by for v15

http://www.gossamer-threads.com/lists/linux/kernel/2390242
