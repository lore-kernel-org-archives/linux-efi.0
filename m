From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 18/18] pstore: Remove write_buf() callback
Date: Mon,  6 Mar 2017 13:55:32 -0800
Message-ID: <1488837332-71582-19-git-send-email-keescook@chromium.org>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Sender: linux-acpi-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>, Paul Gortmaker <paul.gortmaker@windriver.com>, Geliang Tang <geliangtang@163.com>, linuxppc-dev@lists.ozlabs.org, linux-acpi@
List-Id: linux-efi@vger.kernel.org

Now that write() and write_buf() are functionally identical, this removes
write_buf(), and renames write_buf_user() to write_user(). Additionally
adds sanity-checks for pstore_info's declared functions and flags at
registration time.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/pstore/ftrace.c     |  4 ++--
 fs/pstore/platform.c   | 35 ++++++++++++++++++++---------------
 fs/pstore/pmsg.c       |  4 ++--
 fs/pstore/ram.c        | 10 +++++-----
 include/linux/pstore.h | 29 ++++++++++-------------------
 5 files changed, 39 insertions(+), 43 deletions(-)

diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
index a5506ec6995e..06aab07b6bb7 100644
--- a/fs/pstore/ftrace.c
+++ b/fs/pstore/ftrace.c
@@ -53,7 +53,7 @@ static void notrace pstore_ftrace_call(unsigned long ip,
 	rec.parent_ip = parent_ip;
 	pstore_ftrace_write_timestamp(&rec, pstore_ftrace_stamp++);
 	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
-	psinfo->write_buf(&record);
+	psinfo->write(&record);
 
 	local_irq_restore(flags);
 }
@@ -122,7 +122,7 @@ void pstore_register_ftrace(void)
 {
 	struct dentry *file;
 
-	if (!psinfo->write_buf)
+	if (!psinfo->write)
 		return;
 
 	pstore_ftrace_dir = debugfs_create_dir("pstore", NULL);
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index 1e6642a2063e..e79f170fa79b 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -604,7 +604,7 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 		}
 		record.buf = (char *)s;
 		record.size = c;
-		psinfo->write_buf(&record);
+		psinfo->write(&record);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
@@ -632,15 +632,8 @@ static void pstore_register_console(void) {}
 static void pstore_unregister_console(void) {}
 #endif
 
-static int pstore_write_compat(struct pstore_record *record)
-{
-	record->buf = psinfo->buf;
-
-	return record->psi->write_buf(record);
-}
-
-static int pstore_write_buf_user_compat(struct pstore_record *record,
-					const char __user *buf)
+static int pstore_write_user_compat(struct pstore_record *record,
+				    const char __user *buf)
 {
 	unsigned long flags = 0;
 	size_t i, bufsize, total_size = record->size;
@@ -662,7 +655,7 @@ static int pstore_write_buf_user_compat(struct pstore_record *record,
 			break;
 		}
 		record->size = c;
-		ret = record->psi->write_buf(record);
+		ret = record->psi->write(record);
 		if (unlikely(ret < 0))
 			break;
 		i += c;
@@ -687,6 +680,20 @@ int pstore_register(struct pstore_info *psi)
 		return -EPERM;
 	}
 
+	/* Sanity check flags. */
+	if (!psi->flags) {
+		pr_warn("backend '%s' must support at least one frontend\n",
+			psi->name);
+		return -EINVAL;
+	}
+
+	/* Check for required functions. */
+	if (!psi->read || !psi->write) {
+		pr_warn("backend '%s' must implement read() and write()\n",
+			psi->name);
+		return -EINVAL;
+	}
+
 	spin_lock(&pstore_lock);
 	if (psinfo) {
 		pr_warn("backend '%s' already loaded: ignoring '%s'\n",
@@ -695,10 +702,8 @@ int pstore_register(struct pstore_info *psi)
 		return -EBUSY;
 	}
 
-	if (!psi->write)
-		psi->write = pstore_write_compat;
-	if (!psi->write_buf_user)
-		psi->write_buf_user = pstore_write_buf_user_compat;
+	if (!psi->write_user)
+		psi->write_user = pstore_write_user_compat;
 	psinfo = psi;
 	mutex_init(&psinfo->read_mutex);
 	spin_unlock(&pstore_lock);
diff --git a/fs/pstore/pmsg.c b/fs/pstore/pmsg.c
index ce35907602de..c16a2477e106 100644
--- a/fs/pstore/pmsg.c
+++ b/fs/pstore/pmsg.c
@@ -33,12 +33,12 @@ static ssize_t write_pmsg(struct file *file, const char __user *buf,
 	if (!count)
 		return 0;
 
-	/* check outside lock, page in any data. write_buf_user also checks */
+	/* check outside lock, page in any data. write_user also checks */
 	if (!access_ok(VERIFY_READ, buf, count))
 		return -EFAULT;
 
 	mutex_lock(&pmsg_lock);
-	ret = psinfo->write_buf_user(&record, buf);
+	ret = psinfo->write_user(&record, buf);
 	mutex_unlock(&pmsg_lock);
 	return ret ? ret : count;
 }
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index d85e1adae1b6..5523df7f17ef 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -378,7 +378,7 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
 	return len;
 }
 
-static int notrace ramoops_pstore_write_buf(struct pstore_record *record)
+static int notrace ramoops_pstore_write(struct pstore_record *record)
 {
 	struct ramoops_context *cxt = record->psi->data;
 	struct persistent_ram_zone *prz;
@@ -451,8 +451,8 @@ static int notrace ramoops_pstore_write_buf(struct pstore_record *record)
 	return 0;
 }
 
-static int notrace ramoops_pstore_write_buf_user(struct pstore_record *record,
-						 const char __user *buf)
+static int notrace ramoops_pstore_write_user(struct pstore_record *record,
+					     const char __user *buf)
 {
 	if (record->type == PSTORE_TYPE_PMSG) {
 		struct ramoops_context *cxt = record->psi->data;
@@ -503,8 +503,8 @@ static struct ramoops_context oops_cxt = {
 		.name	= "ramoops",
 		.open	= ramoops_pstore_open,
 		.read	= ramoops_pstore_read,
-		.write_buf	= ramoops_pstore_write_buf,
-		.write_buf_user	= ramoops_pstore_write_buf_user,
+		.write	= ramoops_pstore_write,
+		.write_user	= ramoops_pstore_write_user,
 		.erase	= ramoops_pstore_erase,
 	},
 };
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 7f6eaa71504e..936744221171 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -130,27 +130,19 @@ struct pstore_record {
  *	available, or negative on error.
  *
  * @write:
- *	Perform a frontend notification of a write to a backend record. The
- *	data to be stored has already been written to the registered @buf
- *	of the @psi structure.
+ *	A newly generated record needs to be written to backend storage.
  *
  *	@record:
- *		pointer to record metadata. Note that @buf is NULL, since
- *		the @buf registered with @psi is what has been written. The
- *		backend is expected to update @id.
+ *		pointer to record metadata. When @type is PSTORE_TYPE_DMESG,
+ *		@buf will be pointing to the preallocated @psi.buf, since
+ *		memory allocation may be broken during an Oops. Regardless,
+ *		@buf must be proccesed or copied before returning. The
+ *		backend is also expected to write @id with something that
+ 8		can help identify this record to a future @erase callback.
  *
  *	Returns 0 on success, and non-zero on error.
  *
- * @write_buf:
- *	Perform a frontend write to a backend record. The record contains
- *	all metadata and the buffer to write to backend storage. (Unlike
- *	@write, this does not use the @psi @buf.)
- *
- *	@record:	pointer to record metadata.
- *
- *	Returns 0 on success, and non-zero on error.
- *
- * @write_buf_user:
+ * @write_user:
  *	Perform a frontend write to a backend record, using a specified
  *	buffer that is coming directly from userspace, instead of the
  *	@record @buf.
@@ -188,9 +180,8 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(struct pstore_record *record);
 	int		(*write)(struct pstore_record *record);
-	int		(*write_buf)(struct pstore_record *record);
-	int		(*write_buf_user)(struct pstore_record *record,
-					  const char __user *buf);
+	int		(*write_user)(struct pstore_record *record,
+				      const char __user *buf);
 	int		(*erase)(struct pstore_record *record);
 };
 
-- 
2.7.4

