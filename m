From: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/2] efi: capsule pstore backend
Date: Thu, 2 Mar 2017 01:59:43 +0800
Message-ID: <20170301175943.87444-3-qiuxu.zhuo@intel.com>
References: <20170301175943.87444-1-qiuxu.zhuo@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170301175943.87444-1-qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

The EFI capsule mechanism allows data blobs to be passed to the EFI
firmware. By setting the EFI_CAPSULE_POPULATE_SYSTEM_TABLE and the
EFI_CAPSULE_PERSIST_ACROSS_REBOOT flags, the firmware will place a
pointer to our data blob in the EFI System Table on the next boot.
We can utilise this facility to save crash dumps, call traces, etc
and pick them up after reboot.

Initial cut at this driver by Matt Fleming as below links
https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=capsule-pstore&id=99c5f047133555aa0442f64064e85b7da2d4a45f
https://git.kernel.org/cgit/linux/kernel/git/mfleming/efi.git/commit/?h=capsule-pstore&id=8625c776c9b8bbed7fa4aa023e36542615165240
Extensive cleanup, refactoring, bug fix, and verification by Qiuxu Zhuo

Patch verified on Intel Kabylake client platform + Intel KBL BIOS:(10/24/2016):
- modprobe capsule-pstore
- echo 1 > /sys/module/kernel/parameters/panic
- echo c > /proc/sysrq-trigger
- system reboot...
- ls -l /sys/fs/pstore/
  -r--r--r-- 1 root root 4386 Feb 12 00:31 console-efi-capsule-0
  -r--r--r-- 1 root root 9065 Feb 12 00:29 dmesg-efi-capsule-6250071391647825921
  -r--r--r-- 1 root root 9073 Feb 12 00:29 dmesg-efi-capsule-6250071391647825922
  -r--r--r-- 1 root root 9096 Feb 12 00:29 dmesg-efi-capsule-6250071391647825923
  -r--r--r-- 1 root root 9073 Feb 12 00:29 dmesg-efi-capsule-6250071391647825924
  -r--r--r-- 1 root root 9048 Feb 12 00:29 dmesg-efi-capsule-6250071391647825925

The above files contain the last complete logs.

Signed-off-by: Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/firmware/efi/Kconfig          |  21 ++
 drivers/firmware/efi/Makefile         |   1 +
 drivers/firmware/efi/capsule-pstore.c | 527 ++++++++++++++++++++++++++++++++++
 3 files changed, 549 insertions(+)
 create mode 100644 drivers/firmware/efi/capsule-pstore.c

diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 2e78b0b..aab78a7 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -142,6 +142,27 @@ config APPLE_PROPERTIES
 
 	  If unsure, say Y if you have a Mac.  Otherwise N.
 
+config EFI_CAPSULE_PSTORE
+	tristate "EFI capsule pstore backend"
+	depends on EFI && PSTORE
+	help
+	  Saying Y here enable the EFI capsule mechanism to store crash dumps,
+	  console log, and function tracing data.
+
+	  To compile this driver as a module, choose M here.
+
+	  Not many firmware implementations fully support EFI capsules.
+	  If you plan to rely on this you should test whether yours works by
+	  forcing a crash. Most people should not enable this.
+
+config EFI_CAPSULE_PSTORE_DEFAULT_DISABLE
+	bool "Disable using efi capsule as a pstore backend by default"
+	depends on EFI_CAPSULE_PSTORE
+	help
+	  Saying Y here will disable the use of efi capsule as a storage
+	  backend for pstore by default. This setting can be overridden
+	  using the capsule-pstore module's pstore_disable parameter.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index ad67342..1417e653 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -14,6 +14,7 @@ obj-$(CONFIG_EFI)			+= capsule.o memmap.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_ESRT)			+= esrt.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
+obj-$(CONFIG_EFI_CAPSULE_PSTORE)		+= capsule-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
diff --git a/drivers/firmware/efi/capsule-pstore.c b/drivers/firmware/efi/capsule-pstore.c
new file mode 100644
index 0000000..b94cfb9
--- /dev/null
+++ b/drivers/firmware/efi/capsule-pstore.c
@@ -0,0 +1,527 @@
+#define pr_fmt(fmt) "efi-capsule: " fmt
+#include <linux/slab.h>
+#include <linux/vmalloc.h>
+#include <linux/efi.h>
+#include <linux/module.h>
+#include <linux/pstore.h>
+
+#define CAPSULE_SIZE (16 * 1024)
+#define CRASH_SIZE 4096
+#define CAPSULE_MAGIC 0x63617073 /* 'caps' */
+
+static bool efi_capsule_pstore_disable =
+	IS_ENABLED(CONFIG_CAPSULE_PSTORE_DEFAULT_DISABLE);
+
+static int efi_reset_type = -1;
+
+struct efi_capsule_ctx {
+	struct page **pages;
+	unsigned int nr_pages;
+	efi_capsule_header_t *capsule;
+	size_t capsule_size;
+	void *data;
+	size_t data_size;
+};
+
+struct efi_capsule_pstore_buf {
+	void *buf;
+	size_t size;
+	atomic_long_t offset;
+};
+
+struct efi_capsule_pstore {
+	/* Previous records */
+	efi_capsule_header_t **hdrs;
+	uint32_t hdrs_num;
+	off_t hdr_offset;  /* Offset into current header */
+
+	/* New records */
+	struct efi_capsule_pstore_buf console;
+	struct efi_capsule_pstore_buf ftrace;
+	struct efi_capsule_pstore_buf dmesg;
+};
+
+struct efi_capsule_pstore_record {
+	u64 timestamp;
+	u64 id;
+	enum pstore_type_id type;
+	size_t size;
+	bool compressed;
+	u32 magic;
+	char data[];
+} __packed;
+
+static struct pstore_info efi_capsule_pstore_info;
+
+static __init void efi_capsule_destroy(struct efi_capsule_ctx *ctx)
+{
+	if (!ctx)
+		return;
+
+	while (ctx->nr_pages--)
+		__free_page(ctx->pages[ctx->nr_pages]);
+
+	kfree(ctx->pages);
+	kfree(ctx);
+}
+
+/**
+ * efi_capsule_build - alloc data buffer and fill out the header
+ * @guid: vendor's guid
+ * @data_size: size in bytes of the capsule data
+ *
+ * This is a helper function for allocating enough room for user data
+ * + the size of an EFI capsule header.
+ *
+ * Returns a pointer to an allocated capsule on success, an ERR_PTR()
+ * value on error.
+ */
+static __init struct efi_capsule_ctx *
+efi_capsule_build(efi_guid_t guid, size_t data_size)
+{
+	struct efi_capsule_ctx *ctx;
+	size_t capsule_size, needed_pages;
+	u32 flags;
+	int rv;
+
+	flags = EFI_CAPSULE_PERSIST_ACROSS_RESET |
+		EFI_CAPSULE_POPULATE_SYSTEM_TABLE;
+	capsule_size = data_size + sizeof(efi_capsule_header_t);
+	rv = efi_capsule_supported(LINUX_EFI_CRASH_GUID, flags,
+		capsule_size, &efi_reset_type);
+	if (rv)
+		return ERR_PTR(rv);
+
+	ctx = kzalloc(sizeof(*ctx), GFP_KERNEL);
+	if (!ctx)
+		return ERR_PTR(-ENOMEM);
+
+	pr_info("Allocating: %zu\n", capsule_size);
+	needed_pages = ALIGN(capsule_size, PAGE_SIZE) >> PAGE_SHIFT;
+	ctx->pages = kcalloc(needed_pages, sizeof(*ctx->pages), GFP_KERNEL);
+	if (!ctx->pages)
+		goto fail;
+
+	while (needed_pages--) {
+		struct page *page;
+
+		page = alloc_page(GFP_KERNEL | __GFP_HIGHMEM);
+		if (!page)
+			goto fail;
+
+		ctx->pages[ctx->nr_pages++] = page;
+	}
+
+	ctx->capsule = vmap(ctx->pages, ctx->nr_pages, 0, PAGE_KERNEL);
+	if (!ctx->capsule)
+		goto fail;
+
+	ctx->capsule_size = capsule_size;
+	ctx->data = (void *)ctx->capsule + sizeof(efi_capsule_header_t);
+	ctx->data_size = data_size;
+
+	pr_info("Allocated %zd bytes of capsule memory\n", data_size);
+
+	/*
+	 * Setup the EFI capsule header.
+	 */
+	memcpy(&ctx->capsule->guid, &guid, sizeof(guid));
+
+	ctx->capsule->flags = flags;
+	ctx->capsule->headersize = sizeof(*ctx->capsule);
+	ctx->capsule->imagesize = capsule_size;
+
+	return ctx;
+
+fail:
+	efi_capsule_destroy(ctx);
+	return ERR_PTR(-ENOMEM);
+}
+
+/**
+ * We may not be in a position to allocate memory at the time of a
+ * crash, so pre-allocate some space now and register it with the
+ * firmware via efi_capsule_update().
+ *
+ * Also, iterate through the array of capsules pointed to from the EFI
+ * system table and take note of any LINUX_EFI_CRASH_GUID
+ * capsules. They will be parsed by efi_capsule_pstore_read().
+ */
+static __init int efi_capsule_pstore_setup(void)
+{
+	struct efi_capsule_pstore_record *rec;
+	struct efi_capsule_pstore *pctx = NULL;
+	struct efi_capsule_ctx *console_ctx = NULL;
+	struct efi_capsule_ctx *ftrace_ctx = NULL;
+	struct efi_capsule_ctx *dmesg_ctx = NULL;
+	efi_capsule_header_t **hdrs;
+	uint32_t hdrs_num;
+	void *crash_buf = NULL;
+	int rv;
+
+	pctx = kzalloc(sizeof(*pctx), GFP_KERNEL);
+	if (!pctx)
+		return -ENOMEM;
+
+	crash_buf = kmalloc(CRASH_SIZE, GFP_KERNEL);
+	if (!crash_buf) {
+		rv = -ENOMEM;
+		goto fail;
+	}
+
+	/* Allocate all the capsules upfront */
+	dmesg_ctx = efi_capsule_build(LINUX_EFI_CRASH_GUID, CAPSULE_SIZE);
+	if (IS_ERR(dmesg_ctx)) {
+		rv = PTR_ERR(dmesg_ctx);
+		dmesg_ctx = NULL;
+		goto fail2;
+	}
+
+	ftrace_ctx = efi_capsule_build(LINUX_EFI_CRASH_GUID, CAPSULE_SIZE);
+	if (IS_ERR(ftrace_ctx)) {
+		rv = PTR_ERR(ftrace_ctx);
+		ftrace_ctx = NULL;
+		goto fail3;
+	}
+
+	console_ctx = efi_capsule_build(LINUX_EFI_CRASH_GUID, CAPSULE_SIZE);
+	if (IS_ERR(console_ctx)) {
+		rv = PTR_ERR(console_ctx);
+		console_ctx = NULL;
+		goto fail4;
+	}
+
+	/* Register with the firmware */
+	rv = efi_capsule_update(dmesg_ctx->capsule, dmesg_ctx->pages);
+	if (rv)
+		goto fail5;
+	pr_info("Registered dmesg with firmware\n");
+
+	rv = efi_capsule_update(ftrace_ctx->capsule, ftrace_ctx->pages);
+	if (rv)
+		goto fail5;
+	pr_info("Registered ftrace with firmware\n");
+
+	rv = efi_capsule_update(console_ctx->capsule, console_ctx->pages);
+	if (rv)
+		goto fail5;
+	pr_info("Registered console with firmware\n");
+
+	memset(dmesg_ctx->data, 0, dmesg_ctx->data_size);
+	pctx->dmesg.size = dmesg_ctx->data_size;
+	pctx->dmesg.buf = dmesg_ctx->data;
+	atomic_long_set(&pctx->dmesg.offset, 0);
+
+	/* Setup the pstore records for the ring-buffers. */
+	memset(ftrace_ctx->data, 0, ftrace_ctx->data_size);
+	pctx->ftrace.size = ftrace_ctx->data_size - offsetof(typeof(*rec), data);
+	pctx->ftrace.buf = ftrace_ctx->data + offsetof(typeof(*rec), data);
+	atomic_long_set(&pctx->ftrace.offset, 0);
+	rec = ftrace_ctx->data;
+	rec->type = PSTORE_TYPE_FTRACE;
+
+	memset(console_ctx->data, 0, console_ctx->data_size);
+	pctx->console.size = console_ctx->data_size - offsetof(typeof(*rec), data);
+	pctx->console.buf = console_ctx->data + offsetof(typeof(*rec), data);
+	atomic_long_set(&pctx->console.offset, 0);
+	rec = console_ctx->data;
+	rec->type = PSTORE_TYPE_CONSOLE;
+
+	/* Read any pstore entries that were passed across a reboot. */
+	pr_info("Looking up old capsule\n");
+	hdrs = efi_capsule_lookup(LINUX_EFI_CRASH_GUID, &hdrs_num);
+	pctx->hdrs_num = hdrs_num;
+	pctx->hdrs = IS_ERR(hdrs) ? NULL : hdrs;
+
+	if (pctx->hdrs_num)
+		pr_info("Found Linux crash capsule\n");
+
+	/* Register the capsule backend with pstore. */
+	spin_lock_init(&efi_capsule_pstore_info.buf_lock);
+	efi_capsule_pstore_info.buf = crash_buf;
+	efi_capsule_pstore_info.bufsize = CRASH_SIZE;
+	efi_capsule_pstore_info.data = pctx;
+	pr_info("Registering with pstore\n");
+	rv = pstore_register(&efi_capsule_pstore_info);
+	if (rv)
+		pr_err("Capsule support registration failed for pstore: %d\n", rv);
+	else
+		return 0;
+
+fail5:
+	efi_capsule_destroy(console_ctx);
+fail4:
+	efi_capsule_destroy(ftrace_ctx);
+fail3:
+	efi_capsule_destroy(dmesg_ctx);
+fail2:
+	kfree(crash_buf);
+fail:
+	kfree(pctx);
+	return rv;
+}
+
+/**
+ * Return the next pstore record that was passed to us across a reboot
+ * in an EFI capsule.
+ *
+ * This is expected to be called under the pstore
+ * read_mutex. Therefore, no serialisation is done here.
+ */
+static struct efi_capsule_pstore_record *
+get_pstore_read_record(struct efi_capsule_pstore *pctx)
+{
+	struct efi_capsule_pstore_record *rec;
+	efi_capsule_header_t *hdr;
+	off_t remaining;
+
+next:
+	if (!pctx->hdrs_num)
+		return NULL;
+
+	hdr = pctx->hdrs[pctx->hdrs_num - 1];
+	rec = (void *)hdr + hdr->headersize + pctx->hdr_offset;
+
+	remaining = hdr->imagesize - hdr->headersize - pctx->hdr_offset - offsetof(typeof(*rec), data);
+
+	/*
+	 * A single EFI capsule may contain multiple pstore
+	 * records. It may also only be partially filled with pstore
+	 * records, which we can detect by checking for a record with
+	 * zero size.
+	 *
+	 * If there are no more entries in this capsule try the next.
+	 */
+	if (!rec->size) {
+		pctx->hdrs_num--;
+		pctx->hdr_offset = 0;
+		goto next;
+	}
+
+	/*
+	 * If we've finished parsing all records in this capsule, move
+	 * onto the next. Otherwise, increment the offset into the
+	 * current capsule (pctx->hdr_offset).
+	 */
+	if (rec->size == remaining) {
+		pctx->hdrs_num--;
+		pctx->hdr_offset = 0;
+	} else
+		pctx->hdr_offset += rec->size + offsetof(typeof(*rec), data);
+
+	return rec;
+}
+
+static ssize_t efi_capsule_pstore_read(u64 *id, enum pstore_type_id *type,
+				       int *count, struct timespec *time,
+				       char **buf, bool *compressed, ssize_t *ecc_notice_size,
+					   struct pstore_info *psi)
+{
+	struct efi_capsule_pstore_record *rec;
+	struct efi_capsule_pstore *pctx = psi->data;
+	ssize_t size;
+
+	rec = get_pstore_read_record(pctx);
+	if (!rec)
+		return 0;
+
+	if (rec->magic != CAPSULE_MAGIC) {
+		pr_info("%s Invalid capsule record!\n", __func__);
+		return 0;
+	}
+
+	*type = rec->type;
+	time->tv_sec = rec->timestamp;
+	time->tv_nsec = 0;
+	size = rec->size;
+	*id = rec->id;
+	*compressed = rec->compressed;
+	*ecc_notice_size = 0;
+
+	pr_info("Read record type %d size %zu id %llu compressed %d timestamp %llu\n",
+			rec->type, rec->size, rec->id, rec->compressed, rec->timestamp);
+
+	*buf = kmalloc(size, GFP_KERNEL);
+	if (!*buf)
+		return -ENOMEM;
+
+	memcpy(*buf, rec->data, size);
+
+	return size;
+}
+
+/*
+ * We expect to be called with ->buf_lock held, and so don't perform
+ * any serialisation.
+ */
+static struct notrace efi_capsule_pstore_record *
+get_pstore_write_record(struct efi_capsule_pstore_buf *pbuf, size_t *size)
+{
+	struct efi_capsule_pstore_record *rec;
+	long offset = atomic_long_read(&pbuf->offset);
+
+	if (offset + offsetof(typeof(*rec), data) >= pbuf->size)
+		return NULL;
+
+	/* Trim 'size' if there isn't enough remaining space */
+	if (offset + *size + offsetof(typeof(*rec), data) > pbuf->size)
+		*size = pbuf->size - offset - offsetof(typeof(*rec), data);
+
+	rec = pbuf->buf + offset;
+	atomic_long_add(offsetof(typeof(*rec), data) + *size, &pbuf->offset);
+
+	return rec;
+}
+
+static int notrace
+efi_capsule_pstore_write(enum pstore_type_id type,
+			 enum kmsg_dump_reason reason, u64 *id,
+			 unsigned int part, int count, bool compressed,
+			 size_t size, struct pstore_info *psi)
+{
+	struct efi_capsule_pstore_record *rec;
+	struct efi_capsule_pstore *pctx = psi->data;
+	size_t sz = size;
+	static atomic64_t seq;
+
+	/*
+	 * A zero size record would break our detection of
+	 * partially-filled capsules.
+	 */
+	if (!size)
+		return -EINVAL;
+
+	rec = get_pstore_write_record(&pctx->dmesg, &size);
+	if (!rec || (compressed && size < sz))
+		return -ENOSPC;
+
+	rec->type = type;
+	rec->timestamp = get_seconds();
+	rec->size = size;
+	if (!atomic64_read(&seq))
+		atomic64_set(&seq, rec->timestamp << 32);
+	rec->id = (*id) = atomic64_inc_return(&seq);
+	rec->compressed = compressed;
+	rec->magic = CAPSULE_MAGIC;
+	memcpy(rec->data, psi->buf, size);
+
+	return 0;
+}
+
+static notrace void *
+get_pstore_buf(struct efi_capsule_pstore_buf *pbuf, size_t size)
+{
+	long next, curr;
+	struct efi_capsule_pstore_record *rec;
+
+	if (size > pbuf->size)
+		return NULL;
+
+	rec = pbuf->buf - offsetof(typeof(*rec), data);
+	rec->magic = CAPSULE_MAGIC;
+	if (rec->size + size > pbuf->size)
+		rec->size = pbuf->size;
+	else
+		rec->size += size;
+
+	do {
+		curr = atomic_long_read(&pbuf->offset);
+		next = curr + size;
+
+		/* Wrap? */
+		if (next > pbuf->size) {
+			next = size;
+			if (atomic_long_cmpxchg(&pbuf->offset, curr, next)) {
+				curr = 0;
+				break;
+			}
+
+			continue;
+		}
+
+	} while (atomic_long_cmpxchg(&pbuf->offset, curr, next) != curr);
+
+	return pbuf->buf + curr;
+}
+
+static int notrace
+efi_capsule_pstore_write_buf(enum pstore_type_id type,
+			     enum kmsg_dump_reason reason,
+			     u64 *id, unsigned int part,
+			     const char *buf, bool compressed,
+			     size_t size, struct pstore_info *psi)
+{
+	struct efi_capsule_pstore *pctx = psi->data;
+	void *dst;
+
+	if (type == PSTORE_TYPE_FTRACE)
+		dst = get_pstore_buf(&pctx->ftrace, size);
+	else if (type == PSTORE_TYPE_CONSOLE)
+		dst = get_pstore_buf(&pctx->console, size);
+	else
+		return -EINVAL;
+
+	if (!dst)
+		return -ENOSPC;
+
+	memcpy(dst, buf, size);
+
+	return 0;
+}
+
+static struct pstore_info efi_capsule_pstore_info = {
+	.owner     = THIS_MODULE,
+	.name      = "efi-capsule",
+	.flags     = PSTORE_FLAGS_DMESG | PSTORE_FLAGS_CONSOLE | PSTORE_FLAGS_FTRACE,
+	.read      = efi_capsule_pstore_read,
+	.write     = efi_capsule_pstore_write,
+	.write_buf = efi_capsule_pstore_write_buf,
+};
+
+static __init int check_capsule_support(void)
+{
+	int rv;
+
+	efi_guid_t guid = LINUX_EFI_CRASH_GUID;
+	u32 flags = EFI_CAPSULE_PERSIST_ACROSS_RESET |
+		EFI_CAPSULE_POPULATE_SYSTEM_TABLE;
+
+	rv = efi_capsule_supported(guid, flags, CAPSULE_SIZE, &efi_reset_type);
+	if (rv)
+		return rv;
+
+	return 0;
+}
+
+static __init int efi_capsule_pstore_init(void)
+{
+	int rv = 0;
+
+	if (!efi_enabled(EFI_RUNTIME_SERVICES))
+		return -ENODEV;
+
+	if (efi_capsule_pstore_disable)
+		return 0;
+
+	rv = check_capsule_support();
+	if (rv)
+		return rv;
+
+	rv = efi_capsule_pstore_setup();
+	if (rv)
+		return rv;
+
+	return 0;
+}
+
+static __exit void efi_capsule_pstore_exit(void)
+{
+}
+
+module_init(efi_capsule_pstore_init);
+module_exit(efi_capsule_pstore_exit);
+
+module_param_named(pstore_disable, efi_capsule_pstore_disable, bool, 0644);
+
+MODULE_DESCRIPTION("EFI capsule backend for pstore");
+MODULE_LICENSE("GPL v2");
-- 
2.9.0.GIT
