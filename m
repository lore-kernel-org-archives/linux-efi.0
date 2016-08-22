From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH v2 02/20] x86: Set the write-protect cache mode for full
 PAT support
Date: Mon, 22 Aug 2016 17:35:50 -0500
Message-ID: <20160822223550.29880.39409.stgit@tlendack-t1.amdoffice.net>
References: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20160822223529.29880.50884.stgit@tlendack-t1.amdoffice.net>
Sender: owner-linux-mm@kvack.org
To: linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, iommu@lists.linux-foundation.org
Cc: Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Joerg Roedel <joro@8bytes.org>, Konrad Rzeszutek
 Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy
 Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>
List-Id: linux-efi@vger.kernel.org

For processors that support PAT, set the write-protect cache mode
(_PAGE_CACHE_MODE_WP) entry to the actual write-protect value (x05).

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/mm/pat.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index ecb1b69..8f0c44f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -355,7 +355,7 @@ void pat_init(void)
 		 *      010    2    UC-: _PAGE_CACHE_MODE_UC_MINUS
 		 *      011    3    UC : _PAGE_CACHE_MODE_UC
 		 *      100    4    WB : Reserved
-		 *      101    5    WC : Reserved
+		 *      101    5    WP : _PAGE_CACHE_MODE_WP
 		 *      110    6    UC-: Reserved
 		 *      111    7    WT : _PAGE_CACHE_MODE_WT
 		 *
@@ -363,7 +363,7 @@ void pat_init(void)
 		 * corresponding types in the presence of PAT errata.
 		 */
 		pat = PAT(0, WB) | PAT(1, WC) | PAT(2, UC_MINUS) | PAT(3, UC) |
-		      PAT(4, WB) | PAT(5, WC) | PAT(6, UC_MINUS) | PAT(7, WT);
+		      PAT(4, WB) | PAT(5, WP) | PAT(6, UC_MINUS) | PAT(7, WT);
 	}
 
 	if (!boot_cpu_done) {

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
