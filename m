From: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
Subject: [PATCH v5 26/32] x86, drm,
	fbdev: Do not specify encrypted memory for video mappings
Date: Tue, 18 Apr 2017 16:20:56 -0500
Message-ID: <20170418212056.10190.25468.stgit@tlendack-t1.amdoffice.net>
References: <20170418211612.10190.82788.stgit@tlendack-t1.amdoffice.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
In-Reply-To: <20170418211612.10190.82788.stgit-qCXWGYdRb2BnqfbPTmsdiZQ+2ll4COg0XqFh9Ls21Oc@public.gmane.org>
List-Unsubscribe: <https://lists.linuxfoundation.org/mailman/options/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.linuxfoundation.org/pipermail/iommu/>
List-Post: <mailto:iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org>
List-Help: <mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=help>
List-Subscribe: <https://lists.linuxfoundation.org/mailman/listinfo/iommu>,
	<mailto:iommu-request-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org?subject=subscribe>
Sender: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Errors-To: iommu-bounces-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
To: linux-arch-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kvm-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kasan-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, iommu-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org
Cc: Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Brijesh Singh <brijesh.singh-5C7GfCeVMHo@public.gmane.org>, Toshimitsu Kani <toshi.kani-ZPxbGqLxI0U@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Radim =?utf-8?b?S3LEjW3DocWZ?= <rkrcmar-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andrey Ryabinin <aryabinin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "H. Peter
	Anvin" <hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, Paolo Bonzini <pbonzini-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alexander Potapenko <glider-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Larry Woodman <lwoodman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dmitry Vyukov <dvyukov-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Since video memory needs to be accessed decrypted, be sure that the
memory encryption mask is not set for the video ranges.

Signed-off-by: Tom Lendacky <thomas.lendacky-5C7GfCeVMHo@public.gmane.org>
---
 arch/x86/include/asm/vga.h       |   13 +++++++++++++
 arch/x86/mm/pageattr.c           |    2 ++
 drivers/gpu/drm/drm_gem.c        |    2 ++
 drivers/gpu/drm/drm_vm.c         |    4 ++++
 drivers/gpu/drm/ttm/ttm_bo_vm.c  |    7 +++++--
 drivers/gpu/drm/udl/udl_fb.c     |    4 ++++
 drivers/video/fbdev/core/fbmem.c |   12 ++++++++++++
 7 files changed, 42 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
index c4b9dc2..5c7567a 100644
--- a/arch/x86/include/asm/vga.h
+++ b/arch/x86/include/asm/vga.h
@@ -7,12 +7,25 @@
 #ifndef _ASM_X86_VGA_H
 #define _ASM_X86_VGA_H
 
+#include <asm/cacheflush.h>
+
 /*
  *	On the PC, we can just recalculate addresses and then
  *	access the videoram directly without any black magic.
+ *	To support memory encryption however, we need to access
+ *	the videoram as decrypted memory.
  */
 
+#ifdef CONFIG_AMD_MEM_ENCRYPT
+#define VGA_MAP_MEM(x, s)					\
+({								\
+	unsigned long start = (unsigned long)phys_to_virt(x);	\
+	set_memory_decrypted(start, (s) >> PAGE_SHIFT);		\
+	start;							\
+})
+#else
 #define VGA_MAP_MEM(x, s) (unsigned long)phys_to_virt(x)
+#endif
 
 #define vga_readb(x) (*(x))
 #define vga_writeb(x, y) (*(y) = (x))
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 0a850b1..5f14f20 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -1824,11 +1824,13 @@ int set_memory_encrypted(unsigned long addr, int numpages)
 {
 	return __set_memory_enc_dec(addr, numpages, true);
 }
+EXPORT_SYMBOL_GPL(set_memory_encrypted);
 
 int set_memory_decrypted(unsigned long addr, int numpages)
 {
 	return __set_memory_enc_dec(addr, numpages, false);
 }
+EXPORT_SYMBOL_GPL(set_memory_decrypted);
 
 int set_pages_uc(struct page *page, int numpages)
 {
diff --git a/drivers/gpu/drm/drm_gem.c b/drivers/gpu/drm/drm_gem.c
index bc93de3..96af539 100644
--- a/drivers/gpu/drm/drm_gem.c
+++ b/drivers/gpu/drm/drm_gem.c
@@ -36,6 +36,7 @@
 #include <linux/pagemap.h>
 #include <linux/shmem_fs.h>
 #include <linux/dma-buf.h>
+#include <linux/mem_encrypt.h>
 #include <drm/drmP.h>
 #include <drm/drm_vma_manager.h>
 #include <drm/drm_gem.h>
@@ -928,6 +929,7 @@ int drm_gem_mmap_obj(struct drm_gem_object *obj, unsigned long obj_size,
 	vma->vm_ops = dev->driver->gem_vm_ops;
 	vma->vm_private_data = obj;
 	vma->vm_page_prot = pgprot_writecombine(vm_get_page_prot(vma->vm_flags));
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 
 	/* Take a ref for this mapping of the object, so that the fault
 	 * handler can dereference the mmap offset's pointer to the object.
diff --git a/drivers/gpu/drm/drm_vm.c b/drivers/gpu/drm/drm_vm.c
index 1170b32..ed4bcbf 100644
--- a/drivers/gpu/drm/drm_vm.c
+++ b/drivers/gpu/drm/drm_vm.c
@@ -40,6 +40,7 @@
 #include <linux/efi.h>
 #include <linux/slab.h>
 #endif
+#include <linux/mem_encrypt.h>
 #include <asm/pgtable.h>
 #include "drm_internal.h"
 #include "drm_legacy.h"
@@ -58,6 +59,9 @@ static pgprot_t drm_io_prot(struct drm_local_map *map,
 {
 	pgprot_t tmp = vm_get_page_prot(vma->vm_flags);
 
+	/* We don't want graphics memory to be mapped encrypted */
+	tmp = pgprot_decrypted(tmp);
+
 #if defined(__i386__) || defined(__x86_64__) || defined(__powerpc__)
 	if (map->type == _DRM_REGISTERS && !(map->flags & _DRM_WRITE_COMBINING))
 		tmp = pgprot_noncached(tmp);
diff --git a/drivers/gpu/drm/ttm/ttm_bo_vm.c b/drivers/gpu/drm/ttm/ttm_bo_vm.c
index 35ffb37..7958279 100644
--- a/drivers/gpu/drm/ttm/ttm_bo_vm.c
+++ b/drivers/gpu/drm/ttm/ttm_bo_vm.c
@@ -39,6 +39,7 @@
 #include <linux/rbtree.h>
 #include <linux/module.h>
 #include <linux/uaccess.h>
+#include <linux/mem_encrypt.h>
 
 #define TTM_BO_VM_NUM_PREFAULT 16
 
@@ -230,9 +231,11 @@ static int ttm_bo_vm_fault(struct vm_fault *vmf)
 	 * first page.
 	 */
 	for (i = 0; i < TTM_BO_VM_NUM_PREFAULT; ++i) {
-		if (bo->mem.bus.is_iomem)
+		if (bo->mem.bus.is_iomem) {
+			/* Iomem should not be marked encrypted */
+			cvma.vm_page_prot = pgprot_decrypted(cvma.vm_page_prot);
 			pfn = ((bo->mem.bus.base + bo->mem.bus.offset) >> PAGE_SHIFT) + page_offset;
-		else {
+		} else {
 			page = ttm->pages[page_offset];
 			if (unlikely(!page && i == 0)) {
 				retval = VM_FAULT_OOM;
diff --git a/drivers/gpu/drm/udl/udl_fb.c b/drivers/gpu/drm/udl/udl_fb.c
index 8e8d60e..51ee424 100644
--- a/drivers/gpu/drm/udl/udl_fb.c
+++ b/drivers/gpu/drm/udl/udl_fb.c
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/fb.h>
 #include <linux/dma-buf.h>
+#include <linux/mem_encrypt.h>
 
 #include <drm/drmP.h>
 #include <drm/drm_crtc.h>
@@ -169,6 +170,9 @@ static int udl_fb_mmap(struct fb_info *info, struct vm_area_struct *vma)
 	pr_notice("mmap() framebuffer addr:%lu size:%lu\n",
 		  pos, size);
 
+	/* We don't want the framebuffer to be mapped encrypted */
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
+
 	while (size > 0) {
 		page = vmalloc_to_pfn((void *)pos);
 		if (remap_pfn_range(vma, start, page, PAGE_SIZE, PAGE_SHARED))
diff --git a/drivers/video/fbdev/core/fbmem.c b/drivers/video/fbdev/core/fbmem.c
index 069fe79..b5e7c33 100644
--- a/drivers/video/fbdev/core/fbmem.c
+++ b/drivers/video/fbdev/core/fbmem.c
@@ -32,6 +32,7 @@
 #include <linux/device.h>
 #include <linux/efi.h>
 #include <linux/fb.h>
+#include <linux/mem_encrypt.h>
 
 #include <asm/fb.h>
 
@@ -1405,6 +1406,12 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 	mutex_lock(&info->mm_lock);
 	if (fb->fb_mmap) {
 		int res;
+
+		/*
+		 * The framebuffer needs to be accessed decrypted, be sure
+		 * SME protection is removed ahead of the call
+		 */
+		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 		res = fb->fb_mmap(info, vma);
 		mutex_unlock(&info->mm_lock);
 		return res;
@@ -1430,6 +1437,11 @@ static long fb_compat_ioctl(struct file *file, unsigned int cmd,
 	mutex_unlock(&info->mm_lock);
 
 	vma->vm_page_prot = vm_get_page_prot(vma->vm_flags);
+	/*
+	 * The framebuffer needs to be accessed decrypted, be sure
+	 * SME protection is removed
+	 */
+	vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
 	fb_pgprotect(file, vma, start);
 
 	return vm_iomap_memory(vma, start, len);
