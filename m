From: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCHv4 2/4] arm64: dump: Make the page table dumping seq_file optional
Date: Thu, 27 Oct 2016 09:27:32 -0700
Message-ID: <1477585654-8908-3-git-send-email-labbott@redhat.com>
References: <1477585654-8908-1-git-send-email-labbott@redhat.com>
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477585654-8908-1-git-send-email-labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: AKASHI Takahiro <takahiro.akashi-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, David Brown <david.brown-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>, kernel-hardening-ZwoEplunGu1jrUoiu81ncdBPR1lH4CV8@public.gmane.org, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org


The page table dumping code always assumes it will be dumping to a
seq_file to userspace. Future code will be taking advantage of
the page table dumping code but will not need the seq_file. Make
the seq_file optional for these cases.

Reviewed-by: Kees Cook <keescook-F7+t8E8rja9g9hUCZPvPmw@public.gmane.org>
Reviewed-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Tested-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Acked-by: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Signed-off-by: Laura Abbott <labbott-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
v4: No changes
---
 arch/arm64/mm/dump.c | 26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

diff --git a/arch/arm64/mm/dump.c b/arch/arm64/mm/dump.c
index f0f0be7..bb36649 100644
--- a/arch/arm64/mm/dump.c
+++ b/arch/arm64/mm/dump.c
@@ -50,6 +50,18 @@ static const struct addr_marker address_markers[] = {
 	{ -1,				NULL },
 };
 
+#define pt_dump_seq_printf(m, fmt, args...)	\
+({						\
+	if (m)					\
+		seq_printf(m, fmt, ##args);	\
+})
+
+#define pt_dump_seq_puts(m, fmt)	\
+({					\
+	if (m)				\
+		seq_printf(m, fmt);	\
+})
+
 /*
  * The page dumper groups page table entries of the same type into a single
  * description. It uses pg_state to track the range information while
@@ -186,7 +198,7 @@ static void dump_prot(struct pg_state *st, const struct prot_bits *bits,
 			s = bits->clear;
 
 		if (s)
-			seq_printf(st->seq, " %s", s);
+			pt_dump_seq_printf(st->seq, " %s", s);
 	}
 }
 
@@ -200,14 +212,14 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
 		st->level = level;
 		st->current_prot = prot;
 		st->start_address = addr;
-		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 	} else if (prot != st->current_prot || level != st->level ||
 		   addr >= st->marker[1].start_address) {
 		const char *unit = units;
 		unsigned long delta;
 
 		if (st->current_prot) {
-			seq_printf(st->seq, "0x%016lx-0x%016lx   ",
+			pt_dump_seq_printf(st->seq, "0x%016lx-0x%016lx   ",
 				   st->start_address, addr);
 
 			delta = (addr - st->start_address) >> 10;
@@ -215,17 +227,17 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
 				delta >>= 10;
 				unit++;
 			}
-			seq_printf(st->seq, "%9lu%c %s", delta, *unit,
+			pt_dump_seq_printf(st->seq, "%9lu%c %s", delta, *unit,
 				   pg_level[st->level].name);
 			if (pg_level[st->level].bits)
 				dump_prot(st, pg_level[st->level].bits,
 					  pg_level[st->level].num);
-			seq_puts(st->seq, "\n");
+			pt_dump_seq_puts(st->seq, "\n");
 		}
 
 		if (addr >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
+			pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 		}
 
 		st->start_address = addr;
@@ -235,7 +247,7 @@ static void note_page(struct pg_state *st, unsigned long addr, unsigned level,
 
 	if (addr >= st->marker[1].start_address) {
 		st->marker++;
-		seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(st->seq, "---[ %s ]---\n", st->marker->name);
 	}
 
 }
-- 
2.7.4
