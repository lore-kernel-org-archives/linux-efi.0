From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [GIT PULL] EFI changes
Date: Mon, 28 Oct 2013 15:52:15 +0000
Message-ID: <20131028155215.GN1982@console-pimps.org>
References: <20131028123528.GM1982@console-pimps.org>
 <20131028134413.GA10163@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131028134413.GA10163-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Mon, 28 Oct, at 02:44:13PM, Ingo Molnar wrote:
> and this breaks the ARM build:
> 
> In file included from /home/mingo/tip/init/main.c:44:
> /home/mingo/tip/include/linux/efi.h:842:21: error: asm/efi.h: No such file or directory
> /home/mingo/tip/init/main.c: In function 'start_kernel':
> /home/mingo/tip/init/main.c:638: error: implicit declaration of function 'efi_enabled'
> /home/mingo/tip/init/main.c:639: error: implicit declaration of function 'efi_late_init'
> /home/mingo/tip/init/main.c:640: error: implicit declaration of function 'efi_free_boot_services'

Ah, that's my own fault because my 'next' branch doesn't include the ARM
EFI support. Where did you get the patches from? Are they in linux-next?

I'm inclined to drop the cleanup patch for now and do it later, once
things have settled because it's also causing conflicts for Borislav's
work.

-- 
Matt Fleming, Intel Open Source Technology Center
