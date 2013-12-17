From: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Subject: Re: [PATCH v5 10/14] efi: only print saved efi runtime maps instead
 of all memmap ranges for kexec
Date: Tue, 17 Dec 2013 16:58:44 +0100
Message-ID: <20131217155844.GG30592@pd.tnic>
References: <1386582147-9802-1-git-send-email-dyoung@redhat.com>
 <1386582147-9802-11-git-send-email-dyoung@redhat.com>
 <20131213160150.GE32329@pd.tnic>
 <20131216020010.GC3754@dhcp-16-126.nay.redhat.com>
 <20131216113324.GB4922@pd.tnic>
 <20131217063436.GF6751@dhcp-16-126.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20131217063436.GF6751-je1gSBvt1TcFLmT5oZ11vB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, toshi.kani-VXdhtT5mjnY@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 17, 2013 at 02:34:36PM +0800, Dave Young wrote:
> They are moved to efi.c efi_setup_init(), I'm not sure if I expained
> clear enough, in current code parse_efi_setup only accept one argument
> phys_addr so I will mapping it with sizeof(struct setup_data) to
> get the payload size then get the nr_efi_runtime_map. This is a
> simplification from the old implementation.
>
> Based on current implementation, yes, I can add back another argument
> data_len to avoid the 1st mapping thus I can print efi memmap as you
> said.
>
> In this way I need export another extern for the data_len though.

Well, think about it: do you want to do the memremap/unmap a second time
*just* to print the memmap in the efi kernel or do you want to do the
memremap/unmap only once and do the work once?

If you say you don't care about speed and wasting cycles then I'm
certainly fine with that as I've spent more time hinting at the
performance aspect than I'd like to.

> What do you mean about NOPARSE, do you want another function name like
> save_efi_setup()?

-ENOPARSE means I cannot parse what you said above.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
