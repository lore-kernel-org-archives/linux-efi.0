From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: Re: [PATCH v11 1/1] efi: a misc char interface for user to update
 efi firmware
Date: Mon, 8 Feb 2016 15:13:42 +0000
Message-ID: <20160208151342.GB2413@codeblueprint.co.uk>
References: <1454042394-21507-1-git-send-email-hock.leong.kweh@intel.com>
 <1454042394-21507-2-git-send-email-hock.leong.kweh@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1454042394-21507-2-git-send-email-hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Ong Boon Leong <boon.leong.ong-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sam Protsenko <semen.protsenko-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Peter Jones <pjones-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Andy Lutomirski <luto-kltTT9wpgjJwATOyAt5JVQ@public.gmane.org>, Roy Franz <roy.franz-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Borislav Petkov <bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org>, James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Linux FS Devel <linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Anvin H Peter <h.peter.anvin-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bryan O'Donoghue <pure.logic-SyKdqv6vbfZdzvEItQ6vdLNAH6kLmebB@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 29 Jan, at 12:39:54PM, Kweh Hock Leong wrote:
> From: "Kweh, Hock Leong" <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Introducing a kernel module to expose capsule loader interface
> (misc char device file note) for users to upload capsule binaries.
> 
> Example:
> cat firmware.bin > /dev/efi_capsule_loader
> 
> This patch also export efi_capsule_supported() function symbol for
> verifying the submitted capsule header in this kernel module.
> 
> Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
> Signed-off-by: Kweh, Hock Leong <hock.leong.kweh-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> ---
>  drivers/firmware/efi/Kconfig          |    9 +
>  drivers/firmware/efi/Makefile         |    1 +
>  drivers/firmware/efi/capsule-loader.c |  334 +++++++++++++++++++++++++++++++++
>  drivers/firmware/efi/capsule.c        |    1 +
>  4 files changed, 345 insertions(+)
>  create mode 100644 drivers/firmware/efi/capsule-loader.c

OK, I've picked this up. I did make some modifications based on
Bryan's comments from v10 of this patch.

You can see a diff of the changes below, but roughly,

 1. Use Bryan's comments for changelog and expand it a bit
 2. Add more detail to Kconfig entry, most people don't need this
 3. Sprinkled comments from Bryan in the kerneldoc comments
 4. Deleted a level of indentation in efi_capsule_setup_info()
 5. Local variable instead of indexing ->pages in efi_capsule_write()
 6. Fix memory leak in efi_capsule_open()

My plan is to include this patch in the EFI capsule series, and resend
the whole thing out.

---

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 73c14af00c19..de221bbde9c9 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -92,9 +92,10 @@ config EFI_CAPSULE_LOADER
 	depends on EFI
 	help
 	  This option exposes a loader interface "/dev/efi_capsule_loader" for
-	  users to load EFI capsules.
+	  users to load EFI capsules. This driver requires working runtime
+	  capsule support in the firmware, which many OEMs do not provide.
 
-	  If unsure, say N.
+	  Most users should say N.
 
 endmenu
 
diff --git a/drivers/firmware/efi/capsule-loader.c b/drivers/firmware/efi/capsule-loader.c
index acffd767223e..9a43b1568234 100644
--- a/drivers/firmware/efi/capsule-loader.c
+++ b/drivers/firmware/efi/capsule-loader.c
@@ -33,7 +33,7 @@ struct capsule_info {
  * efi_free_all_buff_pages - free all previous allocated buffer pages
  * @cap_info: pointer to current instance of capsule_info structure
  *
- *	In addition of freeing buffer pages, it flags NO_FURTHER_WRITE_ACTION
+ *	In addition to freeing buffer pages, it flags NO_FURTHER_WRITE_ACTION
  *	to cease processing data in subsequent write(2) calls until close(2)
  *	is called.
  **/
@@ -46,7 +46,7 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 }
 
 /**
- * efi_capsule_setup_info - to obtain the efi capsule header in the binary and
+ * efi_capsule_setup_info - obtain the efi capsule header in the binary and
  *			    setup capsule_info structure
  * @cap_info: pointer to current instance of capsule_info structure
  * @kbuff: a mapped first page buffer pointer
@@ -55,44 +55,46 @@ static void efi_free_all_buff_pages(struct capsule_info *cap_info)
 static ssize_t efi_capsule_setup_info(struct capsule_info *cap_info,
 				      void *kbuff, size_t hdr_bytes)
 {
+	efi_capsule_header_t *cap_hdr;
+	size_t pages_needed;
 	int ret;
 	void *temp_page;
 
-	/* Only process data block that is larger than a efi header size */
-	if (hdr_bytes >= sizeof(efi_capsule_header_t)) {
-		/* Reset back to the correct offset of header */
-		efi_capsule_header_t *cap_hdr = kbuff - cap_info->count;
-		size_t pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >>
-					    PAGE_SHIFT;
+	/* Only process data block that is larger than efi header size */
+	if (hdr_bytes < sizeof(efi_capsule_header_t))
+		return 0;
 
-		if (pages_needed == 0) {
-			pr_err("%s: pages count invalid\n", __func__);
-			return -EINVAL;
-		}
+	/* Reset back to the correct offset of header */
+	cap_hdr = kbuff - cap_info->count;
+	pages_needed = ALIGN(cap_hdr->imagesize, PAGE_SIZE) >> PAGE_SHIFT;
 
-		/* Check if the capsule binary supported */
-		ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
-					    cap_hdr->imagesize,
-					    &cap_info->reset_type);
-		if (ret) {
-			pr_err("%s: efi_capsule_supported() failed\n",
-			       __func__);
-			return ret;
-		}
+	if (pages_needed == 0) {
+		pr_err("%s: pages count invalid\n", __func__);
+		return -EINVAL;
+	}
 
-		cap_info->total_size = cap_hdr->imagesize;
-		temp_page = krealloc(cap_info->pages,
-				     pages_needed * sizeof(void *),
-				     GFP_KERNEL | __GFP_ZERO);
-		if (!temp_page) {
-			pr_debug("%s: krealloc() failed\n", __func__);
-			return -ENOMEM;
-		}
+	/* Check if the capsule binary supported */
+	ret = efi_capsule_supported(cap_hdr->guid, cap_hdr->flags,
+				    cap_hdr->imagesize,
+				    &cap_info->reset_type);
+	if (ret) {
+		pr_err("%s: efi_capsule_supported() failed\n",
+		       __func__);
+		return ret;
+	}
 
-		cap_info->pages = temp_page;
-		cap_info->header_obtained = true;
+	cap_info->total_size = cap_hdr->imagesize;
+	temp_page = krealloc(cap_info->pages,
+			     pages_needed * sizeof(void *),
+			     GFP_KERNEL | __GFP_ZERO);
+	if (!temp_page) {
+		pr_debug("%s: krealloc() failed\n", __func__);
+		return -ENOMEM;
 	}
 
+	cap_info->pages = temp_page;
+	cap_info->header_obtained = true;
+
 	return 0;
 }
 
@@ -137,21 +139,22 @@ static ssize_t efi_capsule_submit_update(struct capsule_info *cap_info)
  * @offp: not used
  *
  *	Expectation:
- *	- User space tool should start at the beginning of capsule binary and
+ *	- A user space tool should start at the beginning of capsule binary and
  *	  pass data in sequentially.
  *	- Users should close and re-open this file note in order to upload more
  *	  capsules.
  *	- After an error returned, user should close the file and restart the
  *	  operation for the next try otherwise -EIO will be returned until the
  *	  file is closed.
- *	- EFI capsule header must be located at the beginning of capsule binary
- *	  file and passed in as first block data of write operation.
+ *	- An EFI capsule header must be located at the beginning of capsule
+ *	  binary file and passed in as first block data of write operation.
  **/
 static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 				 size_t count, loff_t *offp)
 {
 	int ret = 0;
 	struct capsule_info *cap_info = file->private_data;
+	struct page *page;
 	void *kbuff = NULL;
 	size_t write_byte;
 
@@ -164,16 +167,20 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 
 	/* Only alloc a new page when previous page is full */
 	if (!cap_info->page_bytes_remain) {
-		cap_info->pages[cap_info->index++] = alloc_page(GFP_KERNEL);
-		if (!cap_info->pages[cap_info->index - 1]) {
+		page = alloc_page(GFP_KERNEL);
+		if (!page) {
 			pr_debug("%s: alloc_page() failed\n", __func__);
 			ret = -ENOMEM;
 			goto failed;
 		}
+
+		cap_info->pages[cap_info->index++] = page;
 		cap_info->page_bytes_remain = PAGE_SIZE;
 	}
 
-	kbuff = kmap(cap_info->pages[cap_info->index - 1]);
+	page = cap_info->pages[cap_info->index - 1];
+
+	kbuff = kmap(page);
 	if (!kbuff) {
 		pr_debug("%s: kmap() failed\n", __func__);
 		ret = -EFAULT;
@@ -199,7 +206,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	}
 
 	cap_info->count += write_byte;
-	kunmap(cap_info->pages[cap_info->index - 1]);
+	kunmap(page);
 
 	/* Submit the full binary to efi_capsule_update() API */
 	if (cap_info->header_obtained &&
@@ -219,7 +226,7 @@ static ssize_t efi_capsule_write(struct file *file, const char __user *buff,
 	return write_byte;
 
 fail_unmap:
-	kunmap(cap_info->pages[cap_info->index - 1]);
+	kunmap(page);
 failed:
 	efi_free_all_buff_pages(cap_info);
 	return ret;
@@ -253,8 +260,8 @@ static int efi_capsule_flush(struct file *file, fl_owner_t id)
  * @inode: not used
  * @file: file pointer
  *
- *	We would not free successfully submitted pages since efi update require
- *	data to be maintained across system reboot.
+ *	We will not free successfully submitted pages since efi update
+ *	requires data to be maintained across system reboot.
  **/
 static int efi_capsule_release(struct inode *inode, struct file *file)
 {
@@ -285,8 +292,10 @@ static int efi_capsule_open(struct inode *inode, struct file *file)
 		return -ENOMEM;
 
 	cap_info->pages = kzalloc(sizeof(void *), GFP_KERNEL);
-	if (!cap_info->pages)
+	if (!cap_info->pages) {
+		kfree(cap_info);
 		return -ENOMEM;
+	}
 
 	file->private_data = cap_info;
