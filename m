From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 05/18] pstore: Add kernel-doc for struct pstore_info
Date: Mon,  6 Mar 2017 13:55:19 -0800
Message-ID: <1488837332-71582-6-git-send-email-keescook@chromium.org>
References: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Return-path: <linux-doc-owner@vger.kernel.org>
In-Reply-To: <1488837332-71582-1-git-send-email-keescook@chromium.org>
Sender: linux-doc-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Nobuhiro Iwamatsu <nobuhiro.iwamatsu.kw@hitachi.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Anton Vorontsov <anton@enomsg.org>, Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <lenb@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Nathan Fontenot <nfont@linux.vnet.ibm.com>, Pan Xinhui <xinhui.pan@linux.vnet.ibm.com>, Daniel Axtens <dja@axtens.net>, Paul Gortmaker <paul.gortmaker@windriver.com>, Geliang Tang <geliangtang@163.com>, linuxppc-dev@lists.ozlabs.org, linux-acpi@
List-Id: linux-efi@vger.kernel.org

This adds documentation for struct pstore_info, which also includes
the basic API the backends need to implement.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 include/linux/pstore.h | 133 +++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 128 insertions(+), 5 deletions(-)

diff --git a/include/linux/pstore.h b/include/linux/pstore.h
index 0da29cae009b..083b10bacd4a 100644
--- a/include/linux/pstore.h
+++ b/include/linux/pstore.h
@@ -30,7 +30,7 @@
 #include <linux/time.h>
 #include <linux/types.h>
 
-/* types */
+/* pstore record types (see fs/pstore/inode.c for filename templates) */
 enum pstore_type_id {
 	PSTORE_TYPE_DMESG	= 0,
 	PSTORE_TYPE_MCE		= 1,
@@ -47,14 +47,138 @@ enum pstore_type_id {
 
 struct module;
 
+/**
+ * struct pstore_info - backend pstore driver structure
+ *
+ * @owner:	module which is repsonsible for this backend driver
+ * @name:	name of the backend driver
+ *
+ * @buf_lock:	spinlock to serialize access to @buf
+ * @buf:	preallocated crash dump buffer
+ * @bufsize:	size of @buf available for crash dump writes
+ *
+ * @read_mutex:	mutex to serialize @open, @read, and @close callbacks
+ * @flags:	bitfield of frontends the backend can accept writes for
+ * @data:	backend-private pointer passed back during callbacks
+ *
+ * Callbacks:
+ *
+ * @open:
+ *	Notify backend that pstore is starting a full read of backend
+ *	records. Followed by one or more @read calls, and a final @close.
+ *
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error.
+ *
+ * @close:
+ *	Notify backend that pstore has finished a full read of backend
+ *	records. Always preceded by an @open call and one or more @read
+ *	calls.
+ *
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error. (Though pstore will
+ *	ignore the error.)
+ *
+ * @read:
+ *	Read next available backend record. Called after a successful
+ *	@open.
+ *
+ *	@id:	out: unique identifier for the record
+ *	@type:	out: pstore record type
+ *	@count: out: for PSTORE_TYPE_DMESG, the Oops count.
+ *	@time:	out: timestamp for the record
+ *	@buf:	out: kmalloc copy of record contents, to be freed by pstore
+ *	@compressed:
+ *		out: if the record contents are compressed
+ *	@ecc_notice_size:
+ *		out: ECC information
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns record size on success, zero when no more records are
+ *	available, or negative on error.
+ *
+ * @write:
+ *	Perform a frontend notification of a write to a backend record. The
+ *	data to be stored has already been written to the registered @buf
+ *	of the @psi structure.
+ *
+ *	@type:	in: pstore record type to write
+ *	@reason:
+ *		in: pstore write reason
+ *	@id:	out: unique identifier for the record
+ *	@part:	in: position in a multipart write
+ *	@count:	in: increasing from 0 since boot, the number of this Oops
+ *	@compressed:
+ *		in: if the record is compressed
+ *	@size:	in: size of the write
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error.
+ *
+ * @write_buf:
+ *	Perform a frontend write to a backend record, using a specified
+ *	buffer. Unlike @write, this does not use the @psi @buf.
+ *
+ *	@type:	in: pstore record type to write
+ *	@reason:
+ *		in: pstore write reason
+ *	@id:	out: unique identifier for the record
+ *	@part:	in: position in a multipart write
+ *	@buf:	in: pointer to contents to write to backend record
+ *	@compressed:
+ *		in: if the record is compressed
+ *	@size:	in: size of the write
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error.
+ *
+ * @write_buf_user:
+ *	Perform a frontend write to a backend record, using a specified
+ *	buffer that is coming directly from userspace.
+ *
+ *	@type:	in: pstore record type to write
+ *	@reason:
+ *		in: pstore write reason
+ *	@id:	out: unique identifier for the record
+ *	@part:	in: position in a multipart write
+ *	@buf:	in: pointer to userspace contents to write to backend record
+ *	@compressed:
+ *		in: if the record is compressed
+ *	@size:	in: size of the write
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error.
+ *
+ * @erase:
+ *	Delete a record from backend storage.  Different backends
+ *	identify records differently, so all possible methods of
+ *	identification are included to help the backend locate the
+ *	record to remove.
+ *
+ *	@type:	in: pstore record type to write
+ *	@id:	in: per-type unique identifier for the record
+ *	@count:	in: Oops count
+ *	@time:	in: timestamp for the record
+ *	@psi:	in: pointer to the struct pstore_info for the backend
+ *
+ *	Returns 0 on success, and non-zero on error.
+ *
+ */
 struct pstore_info {
 	struct module	*owner;
 	char		*name;
-	spinlock_t	buf_lock;	/* serialize access to 'buf' */
+
+	spinlock_t	buf_lock;
 	char		*buf;
 	size_t		bufsize;
-	struct mutex	read_mutex;	/* serialize open/read/close */
+
+	struct mutex	read_mutex;
+
 	int		flags;
+	void		*data;
+
 	int		(*open)(struct pstore_info *psi);
 	int		(*close)(struct pstore_info *psi);
 	ssize_t		(*read)(u64 *id, enum pstore_type_id *type,
@@ -76,11 +200,10 @@ struct pstore_info {
 	int		(*erase)(enum pstore_type_id type, u64 id,
 			int count, struct timespec time,
 			struct pstore_info *psi);
-	void		*data;
 };
 
+/* Supported frontends */
 #define PSTORE_FLAGS_DMESG	(1 << 0)
-#define PSTORE_FLAGS_FRAGILE	PSTORE_FLAGS_DMESG
 #define PSTORE_FLAGS_CONSOLE	(1 << 1)
 #define PSTORE_FLAGS_FTRACE	(1 << 2)
 #define PSTORE_FLAGS_PMSG	(1 << 3)
-- 
2.7.4

