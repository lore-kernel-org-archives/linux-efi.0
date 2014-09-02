From: Maarten Lankhorst <maarten.lankhorst-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
Subject: [REGRESSION] "efi: efistub: Convert into static library" and preparation
 patches
Date: Tue, 02 Sep 2014 17:25:58 +0200
Message-ID: <5405E186.2080406@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ulf Winkelvos <ulf-rS3t9PEbhQ0OIzVOb1FTxg@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Seth Forshee <seth.forshee-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Hey,

My macbook pro 8.2 fails to do a efi stub boot with these patches.

Commit f23cf8bd5c1f49 "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
causes the first break, but this can be averted by changing

struct efi_config *efi_early;

to

struct efi_config *efi_early __attribute__((visibility("hidden")));

I also need to revert commit f4f75ad5741fe "efi: efistub: Convert into static library"
to get boot working.

I'm not an early boot expert, so I have no idea what's going on here.
Only console output I see when the boot fails is "setup_efi_pci() failed!" after
the commit that adds this message.

~Maarten
