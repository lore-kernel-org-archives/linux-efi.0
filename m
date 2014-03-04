From: Matt Fleming <matt@console-pimps.org>
Subject: [PATCH 13/13] x86/efi: Re-disable interrupts after calling firmware services
Date: Tue,  4 Mar 2014 13:14:21 +0000
Message-ID: <1393938861-16797-14-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

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

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
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
