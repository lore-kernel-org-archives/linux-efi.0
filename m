From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: Fix warning of int-to-pointer-cast on x86 32-bit
 builds
Date: Mon, 26 Oct 2015 21:02:35 +0000
Message-ID: <20151026210235.GA3526@codeblueprint.co.uk>
References: <1445593826-4578-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ingo Molnar <mingo.kernel.org-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 23 Oct, at 10:37:46AM, Ard Biesheuvel wrote:
> 
> After looking at the original (already merged) patch 11/11 again, I
> realize this is still not right: the problem is that efi_memory_map's
> phys_map member uses a void* type to hold a physical address, which
> happens to be correct in the normal case even when phys_addr_t is
> larger than void* (like on ARM with LPAE enabled) since the address it
> holds is the address of an allocation performed by the firmware, which
> only uses 1:1 addressable memory.
> 
> However, overwriting memmap.phys_map with a value produced my
> memblock_alloc() is problematic, since the allocation may be above 4
> GB on 32-bit (L)PAE platforms. So the correct way to do this would be
> to set the memblock limit to 4GB before memblock_alloc() on 32-bit
> platforms, and restore it afterwards. This is a bit of a kludge,
> though, and it would be more correct to change the type of
> efi_memory_map::phys_map to phys_addr_t, although I don't know what
> the potential fallout of that change is. Matt?

I think that should be fine. The only potentially tricky situation we
could encounter is where 32-bit x86 firmware uses PAE but the kernel
is built without support.

But that's not something I've ever seen enabled in the firmware and
there's a bunch of assumptions in the kernel already that would break
in that case.

Given that addresses are always 64-bit in the UEFI spec, even on
32-bit platforms, what's the downside of picking u64 instead of
phys_addr_t for efi_memory_map::phys_map?
