From: Matt Fleming <matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Subject: [PATCH 1/5] pstore/ftrace: Don't increment initial data offset
Date: Wed, 16 Oct 2013 14:50:56 +0100
Message-ID: <1381931460-6999-2-git-send-email-matt@console-pimps.org>
References: <1381931460-6999-1-git-send-email-matt@console-pimps.org>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1381931460-6999-1-git-send-email-matt-HNK1S37rvNbeXh+fF434Mdi2O/JbrIOy@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andi Kleen <ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Seiji Aguchi <seiji.aguchi-7rDLJAbr9SE@public.gmane.org>, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>, Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

From: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Delete the following expression,

	data->off = ps->size % REC_SIZE;

as it is not reasonable to expect users to allocate an exact multiple
of REC_SIZE because that constant isn't exported outside of
fs/pstore. There are already checks in the ftrace code to ensure that
no accesses happen beyond the bounds of the buffer, so there's no real
reason to skip the beginning of the data buffer.

It's likely this hasn't been caught before because this code mainly
runs under ARM where REC_SIZE is 8 bytes. On x86-64 REC_SIZE is 24
bytes and so it's more likely that ps->size isn't going to be a multiple.

Cc: Anton Vorontsov <anton-9xeibp6oKSgdnm+yROfE0A@public.gmane.org>
Cc: Colin Cross <ccross-z5hGa2qSFaRBDgjK7y7TUQ@public.gmane.org>
Cc: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Cc: Tony Luck <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 fs/pstore/inode.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/pstore/inode.c b/fs/pstore/inode.c
index 71bf5f4..cc6ec0e 100644
--- a/fs/pstore/inode.c
+++ b/fs/pstore/inode.c
@@ -71,7 +71,6 @@ static void *pstore_ftrace_seq_start(struct seq_file *s, loff_t *pos)
 	if (!data)
 		return NULL;
 
-	data->off = ps->size % REC_SIZE;
 	data->off += *pos * REC_SIZE;
 	if (data->off + REC_SIZE > ps->size) {
 		kfree(data);
-- 
1.8.1.4
