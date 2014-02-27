From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 13/13] x86/efi: Re-disable interrupts after calling firmware services
Date: Thu, 27 Feb 2014 19:51:00 +0000
Message-ID: <1393530660-12692-14-git-send-email-matt@console-pimps.org>
References: <1393530660-12692-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1393530660-12692-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "H. Peter Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Alan Cox <alan-qBU/x9rampVanCEyBjwyrvXRex20P6io@public.gmane.org>, Matthew Garrett <mjg59-1xO5oi07KQx4cg9Nei1l7Q@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Some firmware appears to enable interrupts during boot service calls,
even if we've explicitly disabled them prior to the call. This is
actually allowed per the UEFI spec because boottime services expect to
be called with interrupts enabled.

So that's fine, we just need to ensure that we disable them again in
efi_enter32() before switching to a 64-bit GDT, otherwise an interrupt
may fire causing a 32-bit IRQ handler to run after we've left
compatibility mode.

Despite efi_enter32() being called both for boottime and runtime
services, this really only affects boottime because the runtime services
callchain is executed with interrupts disabled. See efi_thunk().

Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 arch/x86/platform/efi/efi_stub_64.S | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index e811514beeac..65b787a9fc4e 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -261,6 +261,12 @@ ENTRY(efi_enter32)
 	/* We must preserve return value */
 	movl	%eax, %edi
 
+	/*
+	 * Some firmware will return with interrupts enabled. Be sure to
+	 * disable them before we switch GDTs.
+	 */
+	cli
+
 	movl	44(%esp), %eax
 	movl	%eax, 2(%eax)
 	lgdtl	(%eax)
-- 
1.8.5.3
