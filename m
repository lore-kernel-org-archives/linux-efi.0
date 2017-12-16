From: Vincent Legoll <vincent.legoll-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH,v2] efi: make EFI a menuconfig to ease disabling it all
Date: Sat, 16 Dec 2017 11:46:53 +0100
Message-ID: <20171216104654.10790-1-vincent.legoll@gmail.com>
References: <f1007c70-caa4-8ca9-3d52-532e4302cc6e@gmail.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f1007c70-caa4-8ca9-3d52-532e4302cc6e-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


The following v2 patch adds the "default y" to avoid breaking existing
configs.

I don't know if using the CONFIG_EFI symbol would be better, it is spread
in multiple arch/*/Kconfig files, and would make the changes more invasive.

Please advise the way forward

Thanks
