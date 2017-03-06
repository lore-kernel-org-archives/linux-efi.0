From: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Subject: [PATCH 16/18] pstore: Replace arguments for write_buf() API
Date: Mon,  6 Mar 2017 13:55:30 -0800
Message-ID: <1488837332-71582-17-git-send-email-keescook@chromium.org>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1488837332-71582-1-git-send-email-keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw-FCd8Q96Dh0JBDgjK7y7TUQ@public.gmane.org>, Qiuxu Zhuo <qiuxu.zhuo-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Benjamin Herrenschmidt <benh-XVmvHMARGAS8U2dJNN8I7kB+6BGkLq7r@public.gmane.org>, Paul Mackerras <paulus-eUNUBHrolfbYtjvyW6yDsg@public.gmane.org>, Michael Ellerman <mpe-Gsx/Oe8HsFggBc27wqDAHg@public.gmane.org>, "Rafael J. Wysocki" <rjw-LthD3rsA81gm4RdzfppkhA@public.gmane.org>, Len Brown <lenb-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, Nathan Fontenot <nfont-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Pan Xinhui <xinhui.pan-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Daniel Axtens <dja-Yfaxwxk/+vWsTnJN9+BGXg@public.gmane.org>, Paul Gortmaker <paul.gortmaker-CWA4WttNNZF54TAoqtyWWQ@public.gmane.org>, Geliang Tang <geliangtang-9Onoh4P/yGk@public.gmane.org>, linuxppc-dev-uLR06cmDAlY/bJ5BZ2RsiQ@public.gmane.org, linux-acpi@
List-Id: linux-efi@vger.kernel.org

As with the other API updates, this removes the long argument list in favor
of passing a single pstore recaord.

Signed-off-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
---
 fs/pstore/ftrace.c     |  9 +++++++--
 fs/pstore/platform.c   | 30 +++++++++++++++++++++---------
 fs/pstore/ram.c        | 44 ++++++++++++++++++++++----------------------
 include/linux/pstore.h | 21 +++++----------------
 4 files changed, 55 insertions(+), 49 deletions(-)

diff --git a/fs/pstore/ftrace.c b/fs/pstore/ftrace.c
index 899d0ba0bd6c..a5506ec6995e 100644
--- a/fs/pstore/ftrace.c
+++ b/fs/pstore/ftrace.c
@@ -37,6 +37,12 @@ static void notrace pstore_ftrace_call(unsigned long ip,
 {
 	unsigned long flags;
 	struct pstore_ftrace_record rec = {};
+	struct pstore_record record = {
+		.type = PSTORE_TYPE_FTRACE,
+		.buf = (char *)&rec,
+		.size = sizeof(rec),
+		.psi = psinfo,
+	};
 
 	if (unlikely(oops_in_progress))
 		return;
@@ -47,8 +53,7 @@ static void notrace pstore_ftrace_call(unsigned long ip,
 	rec.parent_ip = parent_ip;
 	pstore_ftrace_write_timestamp(&rec, pstore_ftrace_stamp++);
 	pstore_ftrace_encode_cpu(&rec, raw_smp_processor_id());
-	psinfo->write_buf(PSTORE_TYPE_FTRACE, 0, NULL, 0, (void *)&rec,
-			  0, sizeof(rec), psinfo);
+	psinfo->write_buf(&record);
 
 	local_irq_restore(flags);
 }
diff --git a/fs/pstore/platform.c b/fs/pstore/platform.c
index aa3d6e572ede..5eecf9012459 100644
--- a/fs/pstore/platform.c
+++ b/fs/pstore/platform.c
@@ -587,8 +587,11 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 	const char *e = s + c;
 
 	while (s < e) {
+		struct pstore_record record = {
+			.type = PSTORE_TYPE_CONSOLE,
+			.psi = psinfo,
+		};
 		unsigned long flags;
-		u64 id;
 
 		if (c > psinfo->bufsize)
 			c = psinfo->bufsize;
@@ -599,8 +602,9 @@ static void pstore_console_write(struct console *con, const char *s, unsigned c)
 		} else {
 			spin_lock_irqsave(&psinfo->buf_lock, flags);
 		}
-		psinfo->write_buf(PSTORE_TYPE_CONSOLE, 0, &id, 0,
-				  s, 0, c, psinfo);
+		record.buf = (char *)s;
+		record.size = c;
+		psinfo->write_buf(&record);
 		spin_unlock_irqrestore(&psinfo->buf_lock, flags);
 		s += c;
 		c = e - s;
@@ -630,10 +634,9 @@ static void pstore_unregister_console(void) {}
 
 static int pstore_write_compat(struct pstore_record *record)
 {
-	return record->psi->write_buf(record->type, record->reason,
-				      &record->id, record->part,
-				      psinfo->buf, record->compressed,
-				      record->size, record->psi);
+	record->buf = psinfo->buf;
+
+	return record->psi->write_buf(record);
 }
 
 static int pstore_write_buf_user_compat(enum pstore_type_id type,
@@ -653,6 +656,15 @@ static int pstore_write_buf_user_compat(enum pstore_type_id type,
 		bufsize = psinfo->bufsize;
 	spin_lock_irqsave(&psinfo->buf_lock, flags);
 	for (i = 0; i < size; ) {
+		struct pstore_record record = {
+			.type = type,
+			.reason = reason,
+			.id = id,
+			.part = part,
+			.buf = psinfo->buf,
+			.compressed = compressed,
+			.psi = psi,
+		};
 		size_t c = min(size - i, bufsize);
 
 		ret = __copy_from_user(psinfo->buf, buf + i, c);
@@ -660,8 +672,8 @@ static int pstore_write_buf_user_compat(enum pstore_type_id type,
 			ret = -EFAULT;
 			break;
 		}
-		ret = psi->write_buf(type, reason, id, part, psinfo->buf,
-				     compressed, c, psi);
+		record.size = c;
+		ret = psi->write_buf(&record);
 		if (unlikely(ret < 0))
 			break;
 		i += c;
diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index a18575fe32e9..a7cdde60b1f9 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -378,23 +378,18 @@ static size_t ramoops_write_kmsg_hdr(struct persistent_ram_zone *prz,
 	return len;
 }
 
-static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
-					    enum kmsg_dump_reason reason,
-					    u64 *id, unsigned int part,
-					    const char *buf,
-					    bool compressed, size_t size,
-					    struct pstore_info *psi)
+static int notrace ramoops_pstore_write_buf(struct pstore_record *record)
 {
-	struct ramoops_context *cxt = psi->data;
+	struct ramoops_context *cxt = record->psi->data;
 	struct persistent_ram_zone *prz;
-	size_t hlen;
+	size_t size, hlen;
 
-	if (type == PSTORE_TYPE_CONSOLE) {
+	if (record->type == PSTORE_TYPE_CONSOLE) {
 		if (!cxt->cprz)
 			return -ENOMEM;
-		persistent_ram_write(cxt->cprz, buf, size);
+		persistent_ram_write(cxt->cprz, record->buf, record->size);
 		return 0;
-	} else if (type == PSTORE_TYPE_FTRACE) {
+	} else if (record->type == PSTORE_TYPE_FTRACE) {
 		int zonenum;
 
 		if (!cxt->fprzs)
@@ -407,33 +402,36 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 		else
 			zonenum = 0;
 
-		persistent_ram_write(cxt->fprzs[zonenum], buf, size);
+		persistent_ram_write(cxt->fprzs[zonenum], record->buf,
+				     record->size);
 		return 0;
-	} else if (type == PSTORE_TYPE_PMSG) {
+	} else if (record->type == PSTORE_TYPE_PMSG) {
 		pr_warn_ratelimited("PMSG shouldn't call %s\n", __func__);
 		return -EINVAL;
 	}
 
-	if (type != PSTORE_TYPE_DMESG)
+	if (record->type != PSTORE_TYPE_DMESG)
 		return -EINVAL;
 
-	/* Out of the various dmesg dump types, ramoops is currently designed
+	/*
+	 * Out of the various dmesg dump types, ramoops is currently designed
 	 * to only store crash logs, rather than storing general kernel logs.
 	 */
-	if (reason != KMSG_DUMP_OOPS &&
-	    reason != KMSG_DUMP_PANIC)
+	if (record->reason != KMSG_DUMP_OOPS &&
+	    record->reason != KMSG_DUMP_PANIC)
 		return -EINVAL;
 
 	/* Skip Oopes when configured to do so. */
-	if (reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
+	if (record->reason == KMSG_DUMP_OOPS && !cxt->dump_oops)
 		return -EINVAL;
 
-	/* Explicitly only take the first part of any new crash.
+	/*
+	 * Explicitly only take the first part of any new crash.
 	 * If our buffer is larger than kmsg_bytes, this can never happen,
 	 * and if our buffer is smaller than kmsg_bytes, we don't want the
 	 * report split across multiple records.
 	 */
-	if (part != 1)
+	if (record->part != 1)
 		return -ENOSPC;
 
 	if (!cxt->dprzs)
@@ -441,10 +439,12 @@ static int notrace ramoops_pstore_write_buf(enum pstore_type_id type,
 
 	prz = cxt->dprzs[cxt->dump_write_cnt];
 
-	hlen = ramoops_write_kmsg_hdr(prz, compressed);
+	/* Build header and append record contents. */
+	hlen = ramoops_write_kmsg_hdr(prz, record->compressed);
+	size = record->size;
 	if (size + hlen > prz->buffer_size)
 		size = prz->buffer_size - hlen;
-	persistent_ram_write(prz, buf, size);
+	persistent_ram_write(prz, record->buf, size);
 
 	cxt->dump_write_cnt = (cxt->dump_write_cnt + 1) % cxt->max_dump_cnt;
 
diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index a4b2c21a512e..351a22242518 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -142,19 +142,11 @@ struct pstore_record {
  *	Returns 0 on success, and non-zero on error.
  *
  * @write_buf:
- *	Perform a frontend write to a backend record, using a specified
- *	buffer. Unlike @write, this does not use the @psi @buf.
+ *	Perform a frontend write to a backend record. The record contains
+ *	all metadata and the buffer to write to backend storage. (Unlike
+ *	@write, this does not use the @psi @buf.)
  *
- *	@type:	in: pstore record type to write
- *	@reason:
- *		in: pstore write reason
- *	@id:	out: unique identifier for the record
- *	@part:	in: position in a multipart write
- *	@buf:	in: pointer to contents to write to backend record
- *	@compressed:
- *		in: if the record is compressed
- *	@size:	in: size of the write
- *	@psi:	in: pointer to the struct pstore_info for the backend
+ *	@record:	pointer to record metadata.
  *
  *	Returns 0 on success, and non-zero on error.
  *
@@ -203,10 +195,7 @@ struct pstore_info {
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(struct pstore_record *record);
 	int		(*write)(struct pstore_record *record);
-	int		(*write_buf)(enum pstore_type_id type,
-			enum kmsg_dump_reason reason, u64 *id,
-			unsigned int part, const char *buf, bool compressed,
-			size_t size, struct pstore_info *psi);
+	int		(*write_buf)(struct pstore_record *record);
 	int		(*write_buf_user)(enum pstore_type_id type,
 			enum kmsg_dump_reason reason, u64 *id,
 			unsigned int part, const char __user *buf,
-- 
2.7.4
