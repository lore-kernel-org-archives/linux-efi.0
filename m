From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/2] efi/arm*: use memremap() to create the persistent
 memmap mapping
Date: Thu, 14 Apr 2016 13:23:05 +0100
Message-ID: <20160414122305.GO2829@codeblueprint.co.uk>
References: <1460561873-27756-1-git-send-email-ard.biesheuvel@linaro.org>
 <1460561873-27756-2-git-send-email-ard.biesheuvel@linaro.org>
 <CAKv+Gu9GNssCtBY85zMSpGh8bcwXD-3t3LCxmwmK7dO5qN0dzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu9GNssCtBY85zMSpGh8bcwXD-3t3LCxmwmK7dO5qN0dzQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Thu, 14 Apr, at 10:43:45AM, Ard Biesheuvel wrote:
> 
> Actually, this patch does not depend on the ARM memremap changes being
> merged: before those changes, memremap() unconditionally falls back to
> ioremap_cache() for 'System RAM' so this patch is essentially a nop in
> that case. This is guaranteed to work due to the fact that we [still]
> use MEMBLOCK_NOMAP for mapping the memory map on ARM.
 
OK, these two look good to me, so I'm going to queue them up in 'next'
chronologically before your EFI Memory Attributes table patches.

> The memory attributes table and GOP changes do depend on it, however,
> since the configuration tables it accesses are likely to be covered by
> a struct page, in which case ARM disallows the ioremap_cache() (and
> thus the use of memremap() until it is updated to deal with this
> situation explicitly)
> 
> The other change that depends on it is dropping the MEMBLOCK_NOMAP for
> ARM as well (as we did in the arm64 patch that is currently queued up
> for v4.6-rc)

Noted. Thanks Ard.
