From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH v2 03/20] x86: Secure Memory Encryption (SME) build
 enablement
Date: Mon, 22 Aug 2016 17:35:59 -0500
Message-ID: <20160822223559.29880.1502.stgit@tlendack-t1.amdoffice.net>
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

Provide the Kconfig support to build the SME support in the kernel.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/Kconfig |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index c580d8c..131f329 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1357,6 +1357,15 @@ config X86_DIRECT_GBPAGES
 	  supports them), so don't confuse the user by printing
 	  that we have them enabled.
 
+config AMD_MEM_ENCRYPT
+	bool "Secure Memory Encryption support for AMD"
+	depends on X86_64 && CPU_SUP_AMD
+	---help---
+	  Say yes to enable the encryption of system memory. This requires
+	  an AMD processor that supports Secure Memory Encryption (SME).
+	  The encryption of system memory is disabled by default but can be
+	  enabled with the mem_encrypt=on command line option.
+
 # Common NUMA Features
 config NUMA
 	bool "Numa Memory Allocation and Scheduler Support"

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
