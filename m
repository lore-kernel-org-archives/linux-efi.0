From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Mon, 27 Feb 2017 21:57:45 +0000
Message-ID: <20170227215745.GA28416@codeblueprint.co.uk>
References: <20161222102340.2689-1-nicstange@gmail.com>
 <20161222102340.2689-2-nicstange@gmail.com>
 <20170105091242.GA11021@dhcp-128-65.nay.redhat.com>
 <20170109114400.GF16838@codeblueprint.co.uk>
 <20170109133152.2izkcrzgzinxdwux@techsingularity.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170109133152.2izkcrzgzinxdwux@techsingularity.net>
Sender: owner-linux-mm@kvack.org
To: Mel Gorman <mgorman@techsingularity.net>
Cc: Dave Young <dyoung@redhat.com>, Nicolai Stange <nicstange@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mika =?iso-8859-1?Q?Penttil=E4?= <mika.penttila@nextfour.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-efi@vger.kernel.org

On Mon, 09 Jan, at 01:31:52PM, Mel Gorman wrote:
> 
> Well, you could put in a __init global variable about availability into
> mm/memblock.c and then check it in memblock APIs like memblock_reserve()
> to BUG_ON? I know BUG_ON is frowned upon but this is not likely to be a
> situation that can be sensibly recovered.

What about something like this?

BUG_ON() shouldn't actually be necessary because I couldn't think of a
situation where A) memblock would be unavailable and B) returning an
error would prevent us from making progress.

---->8----

>From 1c1c06664d23c5d256016918c54e01802af4e891 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt@codeblueprint.co.uk>
Date: Mon, 27 Feb 2017 21:14:29 +0000
Subject: [PATCH] mm/memblock: Warn if used after slab is up and prevent memory
 corruption

Historically there have been many memory corruption bugs caused by
using the memblock API after its internal data structures have been
destroyed. The latest bug was fixed in commit,

  20b1e22d01a4 ("x86/efi: Don't allocate memmap through memblock after mm_init()")

Instead of modifying the memblock data structures that no longer exist
and silently corrupting memory, WARN and return with an error.

Cc: Nicolai Stange <nicstange@gmail.com>
Cc: Dave Young <dyoung@redhat.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Matt Fleming <matt@codeblueprint.co.uk>
---
 mm/memblock.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/memblock.c b/mm/memblock.c
index 7608bc305936..4dbd86f2fddb 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -530,6 +530,9 @@ int __init_memblock memblock_add_range(struct memblock_type *type,
 	if (!size)
 		return 0;
 
+	if (WARN_ONCE(slab_is_available(), "memblock no longer available\n"))
+		return -EINVAL;
+
 	/* special case for empty array */
 	if (type->regions[0].size == 0) {
 		WARN_ON(type->cnt != 1 || type->total_size);
@@ -648,6 +651,9 @@ static int __init_memblock memblock_isolate_range(struct memblock_type *type,
 	if (!size)
 		return 0;
 
+	if (WARN_ONCE(slab_is_available(), "memblock no longer available\n"))
+		return -EINVAL;
+
 	/* we'll create at most two more regions */
 	while (type->cnt + 2 > type->max)
 		if (memblock_double_array(type, base, size) < 0)
-- 
2.10.0

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
