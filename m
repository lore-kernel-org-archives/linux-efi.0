From: Brijesh Singh <brijesh.singh@amd.com>
Subject: [RFC Part1 PATCH v3 13/17] x86/io: Unroll string I/O when SEV is active
Date: Mon, 24 Jul 2017 14:07:53 -0500
Message-ID: <20170724190757.11278-14-brijesh.singh@amd.com>
References: <20170724190757.11278-1-brijesh.singh@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <kvm-owner@vger.kernel.org>
In-Reply-To: <20170724190757.11278-1-brijesh.singh@amd.com>
Sender: kvm-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, x86@kernel.org, linux-efi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Tony Luck <tony.luck@intel.com>, Piotr Luc <piotr.luc@intel.com>, Tom Lendacky <thomas.lendacky@amd.com>, Fenghua Yu <fenghua.yu@intel.com>, Lu Baolu <baolu.lu@linux.intel.com>, Reza Arbab <arbab@linux.vnet.ibm.com>, David Howells <dhowells@redhat.com>, Matt Fleming <matt@codeblueprint.co.uk>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Laura Abbott <labbott@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Eric Biederman <ebiederm@xmission.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>Paul Mackerras <p>
List-Id: linux-efi@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

Secure Encrypted Virtualization (SEV) does not support string I/O, so
unroll the string I/O operation into a loop operating on one element at
a time.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Brijesh Singh <brijesh.singh@amd.com>
---
 arch/x86/include/asm/io.h | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index e080a39..2f3c002 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -327,14 +327,32 @@ static inline unsigned type in##bwl##_p(int port)			\
 									\
 static inline void outs##bwl(int port, const void *addr, unsigned long count) \
 {									\
-	asm volatile("rep; outs" #bwl					\
-		     : "+S"(addr), "+c"(count) : "d"(port));		\
+	if (sev_active()) {						\
+		unsigned type *value = (unsigned type *)addr;		\
+		while (count) {						\
+			out##bwl(*value, port);				\
+			value++;					\
+			count--;					\
+		}							\
+	} else {							\
+		asm volatile("rep; outs" #bwl				\
+			     : "+S"(addr), "+c"(count) : "d"(port));	\
+	}								\
 }									\
 									\
 static inline void ins##bwl(int port, void *addr, unsigned long count)	\
 {									\
-	asm volatile("rep; ins" #bwl					\
-		     : "+D"(addr), "+c"(count) : "d"(port));		\
+	if (sev_active()) {						\
+		unsigned type *value = (unsigned type *)addr;		\
+		while (count) {						\
+			*value = in##bwl(port);				\
+			value++;					\
+			count--;					\
+		}							\
+	} else {							\
+		asm volatile("rep; ins" #bwl				\
+			     : "+D"(addr), "+c"(count) : "d"(port));	\
+	}								\
 }
 
 BUILDIO(b, b, char)
-- 
2.9.4
