From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH v2] efi: Fix warning of int-to-pointer-cast on x86 32-bit
 builds
Date: Tue, 27 Oct 2015 21:08:47 +0000
Message-ID: <20151027210847.GB8973@codeblueprint.co.uk>
References: <1445593826-4578-1-git-send-email-izumi.taku@jp.fujitsu.com>
 <CAKv+Gu8WPvG5rzBB57eK1_Ehj1wB19wR=zzBDRoQbmhRfpCGng@mail.gmail.com>
 <20151026210235.GA3526@codeblueprint.co.uk>
 <CAKv+Gu-1MfUJiF5idd0KoziUxhrDStmRwXQZHuX+gwnJvq083g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-1MfUJiF5idd0KoziUxhrDStmRwXQZHuX+gwnJvq083g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Taku Izumi <izumi.taku-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Ingo Molnar <mingo.kernel.org-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org, "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 27 Oct, at 11:33:55AM, Ard Biesheuvel wrote:
> 
> Does UEFI even allow that? Even if it can describe memory over 4 GB,
> it uses a flat mapping so allocations done by the stub (which
> retrieves the memory map) should never reside at addresses over 4 GB.

Right, exactly. We're good with phys_addr_t.
