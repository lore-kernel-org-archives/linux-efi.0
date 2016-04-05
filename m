From: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Subject: Re: [PATCH 2/4] efi: Capsule update support
Date: Tue, 5 Apr 2016 11:09:29 +0100
Message-ID: <20160405100929.GB2701@codeblueprint.co.uk>
References: <1458219431-24741-1-git-send-email-matt@codeblueprint.co.uk>
 <1458219431-24741-3-git-send-email-matt@codeblueprint.co.uk>
 <CAKv+Gu8fX7x1x3Od5ThxyFxux_NKDx59PNedkgSfn_V0yg_NQQ@mail.gmail.com>
 <20160321203159.GF11676@codeblueprint.co.uk>
 <20160329122658.GC3625@codeblueprint.co.uk>
 <CAKv+Gu_S-BBo8yinQmbEcag43krKBZGxf-0OC=WkZASgS5_Cdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_S-BBo8yinQmbEcag43krKBZGxf-0OC=WkZASgS5_Cdg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: "linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, joeyli <jlee-IBi9RG/b67k@public.gmane.org>, Kweh Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Mark Salter <msalter-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 29 Mar, at 03:50:39PM, Ard Biesheuvel wrote:
> 
> Should we perhaps whitelist rather than blacklist these flags? If a
> 'EFI_CAPSULE_INITIATE_RESET_TOO' surfaces at some point, or flags that
> do other nasty things, at least we won't be caught off guard.
 
I spent a while thinking about this and was originally going to go
with the blacklist. The idea being that we wouldn't need to update the
kernel to allow new capsule flags to be passed through to the
firmware, even when the kernel doesn't care about them.

But then the thought of having to apply patches to stable to disallow
new capsule flags that don't work correctly with the current patches
left me feeling a cold chill.

So yes, it's a good suggestion Ard. Let's go with the whitelist, which
gives us the power to opt-in to any new capsule flags, whatever they
may be.

---

diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
index dac25208ad5e..0de55944ac0b 100644
--- a/drivers/firmware/efi/capsule.c
+++ b/drivers/firmware/efi/capsule.c
@@ -64,6 +64,17 @@ out:
 	return rv;
 }
 
+/*
+ * Whitelist of EFI capsule flags that we support.
+ *
+ * We do not handle EFI_CAPSULE_INITIATE_RESET because that would
+ * require us to prepare the kernel for reboot. Refuse to load any
+ * capsules with that flag and any other flags that we do not know how
+ * to handle.
+ */
+#define EFI_CAPSULE_SUPPORTED_FLAG_MASK			\
+	(EFI_CAPSULE_PERSIST_ACROSS_RESET | EFI_CAPSULE_POPULATE_SYSTEM_TABLE)
+
 /**
  * efi_capsule_supported - does the firmware support the capsule?
  * @guid: vendor guid of capsule
@@ -84,6 +95,9 @@ int efi_capsule_supported(efi_guid_t guid, u32 flags, size_t size, int *reset)
 	u64 max_size;
 	int rv = 0;
 
+	if (flags & ~EFI_CAPSULE_SUPPORTED_FLAG_MASK)
+		return -EINVAL;
+
 	capsule = kmalloc(sizeof(*capsule), GFP_KERNEL);
 	if (!capsule)
 		return -ENOMEM;
