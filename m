From: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
Date: Thu, 7 Feb 2013 14:09:16 +0800
Message-ID: <5113450C.1080109@huawei.com>
References: <51074786.5030007@huawei.com> <1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com> <51131248.3080203@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51131248.3080203-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Luck, Tony" <tony.luck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Liujiang <jiang.liu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, WuJianguo <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

> Sorry, this bug will be happen when use Sparse-Memory(section is valid, but last

> several pages are invalid). If use Flat-Memory, crash kernel will boot successfully.
> I think the following patch would be better.
> 
> Hi Andrew, will you just ignore the earlier patch and consider the following one? :>
> 
> Signed-off-by: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> ---
>  arch/ia64/mm/init.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
> index 082e383..23f2ee3 100644
> --- a/arch/ia64/mm/init.c
> +++ b/arch/ia64/mm/init.c
> @@ -213,6 +213,8 @@ free_initrd_mem (unsigned long start, unsigned long end)
>  	for (; start < end; start += PAGE_SIZE) {
>  		if (!virt_addr_valid(start))
>  			continue;
> +		if ((start >> PAGE_SHIFT) >= max_low_pfn)

I confused the vaddr and paddr, really sorry for it.

In efi_init() memory aligns in IA64_GRANULE_SIZE(16M). If set "crashkernel=1024M-:600M"
and use sparse memory model, when crash kernel booting it changes [128M-728M] to [128M-720M].
But initrd memory is in [709M-727M], and virt_addr_valid() *can not* check the invalid pages
when freeing initrd memory. There are some pages missed at the end of the seciton.

ChangeLog V3:
	fixed vaddr mistake
ChangeLog V2:
	add invalid pages check when freeing initrd memory

Signed-off-by: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 arch/ia64/mm/init.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/arch/ia64/mm/init.c b/arch/ia64/mm/init.c
index 082e383..8a269f8 100644
--- a/arch/ia64/mm/init.c
+++ b/arch/ia64/mm/init.c
@@ -173,6 +173,7 @@ void __init
 free_initrd_mem (unsigned long start, unsigned long end)
 {
 	struct page *page;
+	unsigned long pfn;
 	/*
 	 * EFI uses 4KB pages while the kernel can use 4KB or bigger.
 	 * Thus EFI and the kernel may have different page sizes. It is
@@ -213,6 +214,9 @@ free_initrd_mem (unsigned long start, unsigned long end)
 	for (; start < end; start += PAGE_SIZE) {
 		if (!virt_addr_valid(start))
 			continue;
+		pfn = __pa(start) >> PAGE_SHIFT;
+		if (pfn >= max_low_pfn)
+			continue;
 		page = virt_to_page(start);
 		ClearPageReserved(page);
 		init_page_count(page);
-- 
1.7.6.1
