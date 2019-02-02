From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH 04/10] efi: use 32-bit alignment for efi_guid_t
Date: Sat,  2 Feb 2019 10:41:13 +0100
Message-ID: <20190202094119.13230-5-ard.biesheuvel@linaro.org>
References: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190202094119.13230-1-ard.biesheuvel@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-efi@vger.kernel.org, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, linux-kernel@vger.kernel.org, AKASHI Takahiro <takahiro.akashi@linaro.org>, Alexander Graf <agraf@suse.de>, Bjorn Andersson <bjorn.andersson@linaro.org>, Borislav Petkov <bp@alien8.de>, Heinrich Schuchardt <xypron.glpk@gmx.de>, Jeffrey Hugo <jhugo@codeaurora.org>, Lee Jones <lee.jones@linaro.org>, Leif Lindholm <leif.lindholm@linaro.org>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Jones <pjones@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>
List-Id: linux-efi@vger.kernel.org

The UEFI spec and EDK2 reference implementation both define EFI_GUID as
struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
this means that firmware services invoked by the kernel may assume that
efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
do not tolerate misalignment. So let's set the minimum alignment to 32 bits.

Note that the UEFI spec as well as some comments in the EDK2 code base
suggest that EFI_GUID should be 64-bit aligned, but this appears to be
a mistake, given that no code seems to exist that actually enforces that
or relies on it.

Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>
Reviewed-by: Leif Lindholm <leif.lindholm@linaro.org>
Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
---
 include/linux/efi.h | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45ff763fba76..be08518c2553 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -48,7 +48,20 @@ typedef u16 efi_char16_t;		/* UNICODE character */
 typedef u64 efi_physical_addr_t;
 typedef void *efi_handle_t;
 
-typedef guid_t efi_guid_t;
+/*
+ * The UEFI spec and EDK2 reference implementation both define EFI_GUID as
+ * struct { u32 a; u16; b; u16 c; u8 d[8]; }; and so the implied alignment
+ * is 32 bits not 8 bits like our guid_t. In some cases (i.e., on 32-bit ARM),
+ * this means that firmware services invoked by the kernel may assume that
+ * efi_guid_t* arguments are 32-bit aligned, and use memory accessors that
+ * do not tolerate misalignment. So let's set the minimum alignment to 32 bits.
+ *
+ * Note that the UEFI spec as well as some comments in the EDK2 code base
+ * suggest that EFI_GUID should be 64-bit aligned, but this appears to be
+ * a mistake, given that no code seems to exist that actually enforces that
+ * or relies on it.
+ */
+typedef guid_t efi_guid_t __aligned(__alignof__(u32));
 
 #define EFI_GUID(a,b,c,d0,d1,d2,d3,d4,d5,d6,d7) \
 	GUID_INIT(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)
-- 
2.17.1
