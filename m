From: Tom Lendacky <thomas.lendacky@amd.com>
Subject: [RFC PATCH v2 19/20] x86: Access the setup data through debugfs
 un-encrypted
Date: Mon, 22 Aug 2016 17:38:59 -0500
Message-ID: <20160822223859.29880.60652.stgit@tlendack-t1.amdoffice.net>
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

Since the setup data is in memory in the clear, it must be accessed as
un-encrypted.  Always use ioremap (similar to sysfs setup data support)
to map the data.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
---
 arch/x86/kernel/kdebugfs.c |   30 +++++++++++-------------------
 1 file changed, 11 insertions(+), 19 deletions(-)

diff --git a/arch/x86/kernel/kdebugfs.c b/arch/x86/kernel/kdebugfs.c
index bdb83e4..a58a82e 100644
--- a/arch/x86/kernel/kdebugfs.c
+++ b/arch/x86/kernel/kdebugfs.c
@@ -48,17 +48,13 @@ static ssize_t setup_data_read(struct file *file, char __user *user_buf,
 
 	pa = node->paddr + sizeof(struct setup_data) + pos;
 	pg = pfn_to_page((pa + count - 1) >> PAGE_SHIFT);
-	if (PageHighMem(pg)) {
-		p = ioremap_cache(pa, count);
-		if (!p)
-			return -ENXIO;
-	} else
-		p = __va(pa);
+	p = ioremap_cache(pa, count);
+	if (!p)
+		return -ENXIO;
 
 	remain = copy_to_user(user_buf, p, count);
 
-	if (PageHighMem(pg))
-		iounmap(p);
+	iounmap(p);
 
 	if (remain)
 		return -EFAULT;
@@ -127,15 +123,12 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		}
 
 		pg = pfn_to_page((pa_data+sizeof(*data)-1) >> PAGE_SHIFT);
-		if (PageHighMem(pg)) {
-			data = ioremap_cache(pa_data, sizeof(*data));
-			if (!data) {
-				kfree(node);
-				error = -ENXIO;
-				goto err_dir;
-			}
-		} else
-			data = __va(pa_data);
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			kfree(node);
+			error = -ENXIO;
+			goto err_dir;
+		}
 
 		node->paddr = pa_data;
 		node->type = data->type;
@@ -143,8 +136,7 @@ static int __init create_setup_data_nodes(struct dentry *parent)
 		error = create_setup_data_node(d, no, node);
 		pa_data = data->next;
 
-		if (PageHighMem(pg))
-			iounmap(data);
+		iounmap(data);
 		if (error)
 			goto err_dir;
 		no++;

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
