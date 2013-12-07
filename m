From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to
 sysfs
Date: Sat, 7 Dec 2013 04:01:02 -0500 (EST)
Message-ID: <2141297830.13051543.1386406862068.JavaMail.root@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com> <1385445477-9665-7-git-send-email-dyoung@redhat.com> <20131127114402.GB32267@pd.tnic> <20131129094034.GI4186@dhcp-16-126.nay.redhat.com> <20131129115029.GB4266@pd.tnic> <20131202025942.GF3999@dhcp-16-126.nay.redhat.com> <20131202094020.GA7380@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20131202094020.GA7380-fF5Pk5pvG8Y@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, toshi kani <toshi.kani-VXdhtT5mjnY@public.gmane.org>, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Hi, all

Update my status:

I have finished most of thecode related changes including the krealloc
fixes (both for original code and my new code). And I'm slowly
moving the kexec related stuff to efi_kexec.c, this involves
some other cleanups, such as:
efi_systab_init:
 -> move 64bit code to efi_64.c, move 32bit code to efi_32.c

efi_setup global variable is changing to physical address, ioremapping
it when necessary instead of directly using the virt addr because
previously the virt addr will be freed until entering virtual mode,
it's possible a leak in case something is wrong in the middle also it
occupies the ioremap slot a little bit long.

There's also other problems, so I still need a few days probably
a week to carefully restructure the code.

Thanks
Dave

Sending from web interface so sorry for the email format.
----- Original Message -----
From: "Borislav Petkov" <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>
To: "Dave Young" <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "toshi kani" <toshi.kani-VXdhtT5mjnY@public.gmane.org>, matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org, greg-U8xfFu+wG4EAvxtiuMwx3w@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "James Bottomley" <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, horms-/R6kz+dDXgpPR4JQBCEnsQ@public.gmane.org, ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Sent: Monday, December 2, 2013 5:40:20 PM
Subject: Re: [PATCH v4 06/12] efi: export efi runtime memory mapping to sysfs

On Mon, Dec 02, 2013 at 10:59:42AM +0800, Dave Young wrote:
> They are only called if there's setup_data SETUP_EFI passed in. Yes, I
> think only kexec need that part of code. But I hesitated to mess the
> code with a lot of #if. Will think about it.

Well, the accepted strategy with the efi code is to have function calls
in efi.c and then have different versions of those functions defined for
32 and 64-bit, i.e. efi_32.c and efi_64.c.

I can imagine adding an efi_kexec.c could make the whole deal very
clearly arranged without ifdeffery.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--

_______________________________________________
kexec mailing list
kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
http://lists.infradead.org/mailman/listinfo/kexec
