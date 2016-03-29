From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: Capsule update support
Date: Tue, 29 Mar 2016 13:26:58 +0100
Message-ID: <20160329122658.GC3625@codeblueprint.co.uk>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
 <1458219431-24741-3-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu8fX7x1x3Od5ThxyFxux_NKDx59PNedkgSfn_V0yg_NQQ@mail.gmail.com>
 <20160321203159.GF11676@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160321203159.GF11676-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 21 Mar, at 08:31:59PM, Matt Fleming wrote:
> 
> Good question. They're not handled in any special way with this patch
> series, so the firmware will just initiate its own reset inside of
> UpdateCapsule().
> 
> That's probably not what we want, because things like on-disk
> consistency are not guaranteed if the machine spontaneously reboots
> without assistance from the kernel.
> 
> The simplest thing to do is to refuse to pass such capsules to the
> firmware, since it's likely not going to be a common use case. But
> maybe that's overly restrictive.
> 
> Let me have a think about that one.

OK, I did think about this, and until someone actually requests the
ability to handle CAPSULE_FLAGS_INITIATE_RESET, I'm happy to just punt
on the problem. Anyone got any objections?

---

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index dac25208ad5e..84450e9cdf41 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -84,6 +84,14 @@ int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
 	u64 max_size;
 	int rv = 0;
 
+	/*
+	 * We do not handle firmware-initiated reset because that
+	 * would require us to prepare the kernel for reboot. Refuse
+	 * to load any capsules with that flag.
+	 */
+	if (flags & EFI_CAPSULE_INITIATE_RESET)
+		return -EINVAL;
+
 	capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
 	if (!capsule)
 		return -ENOMEM;
