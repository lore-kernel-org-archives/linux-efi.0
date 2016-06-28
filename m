From: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Subject: [PATCH v4 1/3] mm: memblock enhence the memblock debugfs output
Date: Tue, 28 Jun 2016 17:45:35 +0800
Message-ID: <1467107137-29631-1-git-send-email-dennis.chen@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-arm-kernel-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: nd-5wv7dgnIgG8@public.gmane.org, Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>, Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>, Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>, Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>, Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>, "Rafael J . Wysocki" <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-efi@vger.kernel.org

Current memblock debugfs output doesn't make the debug convenient
enough, for example, lack of the 'flag' of the corresponding memblock
region result in it's difficult to known whether the region has been
mapped to the kernel linear map zone or not. This patch is trying to
ease the dubug effort by adding 'size' and 'flag' output.

The '/sys/kernel/debug/memblock/memory' output looks like before:
   0: 0x0000008000000000..0x0000008001e7ffff
   1: 0x0000008001e80000..0x00000083ff184fff
   2: 0x00000083ff185000..0x00000083ff1c2fff
   3: 0x00000083ff1c3000..0x00000083ff222fff
   4: 0x00000083ff223000..0x00000083ffe42fff
   5: 0x00000083ffe43000..0x00000083ffffffff

After applied:
   0: 0x0000008000000000..0x0000008001e7ffff  0x0000000001e80000  0x4
   1: 0x0000008001e80000..0x00000083ff184fff  0x00000003fd305000  0x0
   2: 0x00000083ff185000..0x00000083ff1c2fff  0x000000000003e000  0x4
   3: 0x00000083ff1c3000..0x00000083ff222fff  0x0000000000060000  0x0
   4: 0x00000083ff223000..0x00000083ffe42fff  0x0000000000c20000  0x4
   5: 0x00000083ffe43000..0x00000083ffffffff  0x00000000001bd000  0x0

Signed-off-by: Dennis Chen <dennis.chen-5wv7dgnIgG8@public.gmane.org>
Cc: Catalin Marinas <catalin.marinas-5wv7dgnIgG8@public.gmane.org>
Cc: Steve Capper <steve.capper-5wv7dgnIgG8@public.gmane.org>
Cc: Ard Biesheuvel <ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Will Deacon <will.deacon-5wv7dgnIgG8@public.gmane.org>
Cc: Mark Rutland <mark.rutland-5wv7dgnIgG8@public.gmane.org>
Cc: Rafael J. Wysocki <rafael.j.wysocki-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matt Fleming <matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org
Cc: linux-acpi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
Change history:
v3->v4: 
According to suggestion from Mark Rutland, make the memblock debugfs
part as an individual patch since logically it's independent from others

 mm/memblock.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/mm/memblock.c b/mm/memblock.c
index ca09915..0fc0fa1 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -1677,13 +1677,15 @@ static int memblock_debug_show(struct seq_file *m, void *private)
 		reg = &type->regions[i];
 		seq_printf(m, "%4d: ", i);
 		if (sizeof(phys_addr_t) == 4)
-			seq_printf(m, "0x%08lx..0x%08lx\n",
+			seq_printf(m, "0x%08lx..0x%08lx  0x%08lx  0x%lx\n",
 				   (unsigned long)reg->base,
-				   (unsigned long)(reg->base + reg->size - 1));
+				   (unsigned long)(reg->base + reg->size - 1),
+				   (unsigned long)reg->size, reg->flags);
 		else
-			seq_printf(m, "0x%016llx..0x%016llx\n",
+			seq_printf(m, "0x%016llx..0x%016llx  0x%016llx  0x%lx\n",
 				   (unsigned long long)reg->base,
-				   (unsigned long long)(reg->base + reg->size - 1));
+				   (unsigned long long)(reg->base + reg->size - 1),
+				   (unsigned long long)reg->size, reg->flags);
 
 	}
 	return 0;
-- 
2.7.4
