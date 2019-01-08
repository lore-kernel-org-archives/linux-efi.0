From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Subject: [PATCH] efi: use 32-bit alignment for efi_guid_t
Date: Tue,  8 Jan 2019 16:28:29 +0100
Message-ID: <20190108152829.11579-1-ard.biesheuvel@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: linux-efi@vger.kernel.org
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Heinrich Schuchardt <xypron.glpk@gmx.de>, leif.lindholm@linaro.org, lersek@redhat.com, mingo@kernel.org, linux-arm-kernel@lists.infradead.org
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

Reported-by: Heinrich Schuchardt <xypron.glpk@gmx.de>,
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
2.20.1
