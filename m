From: Grant Likely <grant.likely-s3s/WqlpOiPyB63q8FvJNQ@public.gmane.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Wed, 26 Jun 2013 15:35:06 +0100
Message-ID: <CACxGe6uJN1tLNYpb-_MiX5xMQnUsC84Wybe2estz_VST-A0P-w@mail.gmail.com>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <CACxGe6tUpo31p6N0BZt_jdonuPP8ijvLBygC76wQ044EFsqOwA@mail.gmail.com> <20130626140459.GB9078@rocoto.smurfnet.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130626140459.GB9078-GZEopFhza0F985/tl1ce8aaDwS/vmuI7@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org" <patches-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "H. Peter Anvin" <hpa-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 26, 2013 at 3:04 PM, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org> wrote:
> On Wed, Jun 26, 2013 at 02:13:39PM +0100, Grant Likely wrote:
>> > +- 'efi-runtime-mmap':
>> > +  Physical address of an EFI memory map, containing at least
>> > +  the regions to be preserved. (required)
>> > +- 'efi-runtime-mmap-size':
>> > +  Size in bytes of the provided memory map. (required)
>>
>> I would collapse the above two properties into a single property that
>> actually contains the memory map instead of pointing to it. You will
>> also need to specify the exact format of the data in this property.
>
> Ok, that makes sense.
>
> Hmm. The data is an array of struct EFI_MEMORY_DESCRIPTOR entries,
> known in Linux as efi_memory_desc_t. Is that a good enough description?

Yes, it is perfectly valid to point at another spec and state "it is
in that format". You'll also want to be specific that the data is
using the UEFI byte ordering, and not the ordering normally used by
FDT. One could argue that it should be 'translated' into a native DT
data format, but I think it is better to view it as a BLOB that DT
doesn't have anything to say about.

>> > +- 'efi-mmap-desc-size':
>> > +  Size of each descriptor in the memory map. (override default)
>> > +- 'efi-mmap-desc-ver':
>> > +  Memory descriptor format version. (override default)
>>
>> I don't understand how these properties will actually work. What
>> changes in the parsing if these properties are set?
>
> I guess the intended use is that these options would permit you to
> append new fields to the struct and have old code correctly parse the
> array anyway.

Let's leave them out as part of the binding until it is actually needed.

g.
