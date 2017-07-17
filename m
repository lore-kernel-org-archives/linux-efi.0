From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v10 02/38] x86/mm/pat: Set write-protect cache mode for full PAT support
Date: Mon, 17 Jul 2017 16:09:59 -0500
Message-ID: <ade53b63d4dbffbfc3cb08fb62024647059c8688.1500319216.git.thomas.lendacky@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1500319216.git.thomas.lendacky@amd.com>
Sender: owner-linux-mm@kvack.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave Young <dyoung@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, "Michael S. Tsirkin" <mst@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>
List-Id: linux-efi@vger.kernel.org

For processors that support PAT, set the write-protect cache mode
(_PAGE_CACHE_MODE_WP) entry to the actual write-protect value (x05).

Acked-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/pat.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 4597950..88990ab 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -293,7 +293,7 @@ void init_cache_modes(void)
  * pat_init - Initialize PAT MSR and PAT table
  *
  * This function initializes PAT MSR and PAT table with an OS-defined value
- * to enable additional cache attributes, WC and WT.
+ * to enable additional cache attributes, WC, WT and WP.
  *
  * This function must be called on all CPUs using the specific sequence of
  * operations defined in Intel SDM. mtrr_rendezvous_handler() provides this
@@ -352,7 +352,7 @@ void pat_init(void)
 		 *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
 		 *      011    3    UC : _PAGE_CACHE_MODE_UC
 		 *      100    4    WB : Reserved
-		 *      101    5    WC : Reserved
+		 *      101    5    WP : _PAGE_CACHE_MODE_WP
 		 *      110    6    UC-: Reserved
 		 *      111    7    WT : _PAGE_CACHE_MODE_WT
 		 *
@@ -360,7 +360,7 @@ void pat_init(void)
 		 * corresponding types in the presence of PAT errata.
 		 */
 		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
-		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
+		      PAT(4, WB) | PAT(5, WP) | PAT(6, UC_MINUS) | PAT(7, WT);
 	}
 
 	if (!boot_cpu_done) {
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
