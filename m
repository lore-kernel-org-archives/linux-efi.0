From: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] efi: stub: use a pool allocation for the cmdline
Date: Wed, 15 Apr 2015 12:01:12 +0200
Message-ID: <CAKv+Gu-Gcie0-voFTwjsbz1Z0tGfY-fwjfsNausAwRBfQknNQg@mail.gmail.com>
References: <1428670569-23089-1-git-send-email-ard.biesheuvel@linaro.org>
	<CAFECyb9efREE=BU5RGSbzAGHqi5CkivUuTf=BRdq02GvFqJaOA@mail.gmail.com>
	<CAKv+Gu-KHpSWLKOgA7UW8C6L1-K3dOieNmF2=qq_t5N73u3Spg@mail.gmail.com>
	<20150415095506.GA4804@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150415095506.GA4804-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leif Lindholm <leif.lindholm-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, "linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, "x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On 15 April 2015 at 11:55, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org> wrote:
> On Fri, 10 Apr, at 07:14:34PM, Ard Biesheuvel wrote:
>>
>> It is not such a big deal: the memory is reclaimed anyway, I was just
>> trying to reduce the fragmentation a bit, and trying to avoid
>> efi_xxx_alloc() which are substantially heavier than calling
>> allocate_pool() or allocate_pages() directly.
>
> Out of curiosity, do you have any runtime numbers to backup the claim
> that allocate_*() is substantially more lightweight?
>

No, I do not. But since efi_[high|low]_alloc() call
efi_get_memory_map() internally, which itself calls allocate_pool() at
least twice [typically], and then iterate over the entire memory map
to select a suitable slot which gets allocated using allocate_pages(),
calling either of allocate_[pool|pages] directly is arguably more
lightweight. But claiming they are 'substantially heavier' is
unsubstantiated.

-- 
Ard.
