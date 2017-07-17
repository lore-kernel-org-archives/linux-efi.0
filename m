From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [PATCH v10 33/38] x86/mm: Use proper encryption attributes with /dev/mem
Date: Mon, 17 Jul 2017 16:10:30 -0500
Message-ID: <c917f403ab9f61cbfd455ad6425ed8429a5e7b54.1500319216.git.thomas.lendacky@amd.com>
References: <cover.1500319216.git.thomas.lendacky@amd.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1500319216.git.thomas.lendacky@amd.com>
Sender: owner-linux-mm@kvack.org
To: x86@kernel.org, linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org, linux-efi@vger.kernel.org, linux-doc@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org, kasan-dev@googlegroups.com
Cc: =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Alexander Potapenko <glider@google.com>, Thomas Gleixner <tglx@linutronix.de>, Dmitry Vyukov <dvyukov@google.com>, Rik van Riel <riel@redhat.com>, Larry Woodman <lwoodman@redhat.com>, Dave Young <dyoung@redhat.com>, Toshimitsu Kani <toshi.kani@hpe.com>, "Michael S. Tsirkin" <mst@redhat.com>, Brijesh Singh <brijesh.singh@amd.com>
List-Id: linux-efi@vger.kernel.org

When accessing memory using /dev/mem (or /dev/kmem) use the proper
encryption attributes when mapping the memory.

To insure the proper attributes are applied when reading or writing
/dev/mem, update the xlate_dev_mem_ptr() function to use memremap()
which will essentially perform the same steps of applying __va for
RAM or using ioremap() if not RAM.

To insure the proper attributes are applied when mmapping /dev/mem,
update the phys_mem_access_prot() to call phys_mem_access_encrypted(),
a new function which will check if the memory should be mapped encrypted
or not. If it is not to be mapped encrypted then the VMA protection
value is updated to remove the encryption bit.

Reviewed-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/include/asm/io.h |  3 +++
 arch/x86/mm/ioremap.c     | 18 +++++++++---------
 arch/x86/mm/pat.c         |  3 +++
 3 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/io.h b/arch/x86/include/asm/io.h
index 09c5557..e080a39 100644
--- a/arch/x86/include/asm/io.h
+++ b/arch/x86/include/asm/io.h
@@ -386,4 +386,7 @@ extern bool arch_memremap_can_ram_remap(resource_size_t offset,
 					unsigned long flags);
 #define arch_memremap_can_ram_remap arch_memremap_can_ram_remap
 
+extern bool phys_mem_access_encrypted(unsigned long phys_addr,
+				      unsigned long size);
+
 #endif /* _ASM_X86_IO_H */
diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 704fc08..34f0e18 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -400,12 +400,10 @@ void *xlate_dev_mem_ptr(phys_addr_t phys)
 	unsigned long offset = phys & ~PAGE_MASK;
 	void *vaddr;
 
-	/* If page is RAM, we can use __va. Otherwise ioremap and unmap. */
-	if (page_is_ram(start >> PAGE_SHIFT))
-		return __va(phys);
+	/* memremap() maps if RAM, otherwise falls back to ioremap() */
+	vaddr = memremap(start, PAGE_SIZE, MEMREMAP_WB);
 
-	vaddr = ioremap_cache(start, PAGE_SIZE);
-	/* Only add the offset on success and return NULL if the ioremap() failed: */
+	/* Only add the offset on success and return NULL if memremap() failed */
 	if (vaddr)
 		vaddr += offset;
 
@@ -414,10 +412,7 @@ void *xlate_dev_mem_ptr(phys_addr_t phys)
 
 void unxlate_dev_mem_ptr(phys_addr_t phys, void *addr)
 {
-	if (page_is_ram(phys >> PAGE_SHIFT))
-		return;
-
-	iounmap((void __iomem *)((unsigned long)addr & PAGE_MASK));
+	memunmap((void *)((unsigned long)addr & PAGE_MASK));
 }
 
 /*
@@ -626,6 +621,11 @@ pgprot_t __init early_memremap_pgprot_adjust(resource_size_t phys_addr,
 	return prot;
 }
 
+bool phys_mem_access_encrypted(unsigned long phys_addr, unsigned long size)
+{
+	return arch_memremap_can_ram_remap(phys_addr, size, 0);
+}
+
 #ifdef CONFIG_ARCH_USE_MEMREMAP_PROT
 /* Remap memory with encryption */
 void __init *early_memremap_encrypted(resource_size_t phys_addr,
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index 88990ab..fe7d57a 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -744,6 +744,9 @@ void arch_io_free_memtype_wc(resource_size_t start, resource_size_t size)
 pgprot_t phys_mem_access_prot(struct file *file, unsigned long pfn,
 				unsigned long size, pgprot_t vma_prot)
 {
+	if (!phys_mem_access_encrypted(pfn << PAGE_SHIFT, size))
+		vma_prot = pgprot_decrypted(vma_prot);
+
 	return vma_prot;
 }
 
-- 
1.9.1

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
