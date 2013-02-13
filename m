From: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel
 booting
Date: Tue, 12 Feb 2013 16:22:22 -0800
Message-ID: <20130212162222.e4103ddb.akpm@linux-foundation.org>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
	<CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Liujiang <jiang.liu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, WuJianguo <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

On Tue, 12 Feb 2013 16:11:33 -0800
Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> Building linux-next today (tag next-20130212) I get the following errors when
> building arch/ia64/configs/{tiger_defconfig, zx1_defconfig, bigsur_defconfig,
> sim_defconfig}
> 
> arch/ia64/mm/init.c: In function 'free_initrd_mem':
> arch/ia64/mm/init.c:215: error: 'max_addr' undeclared (first use in
> this function)
> arch/ia64/mm/init.c:215: error: (Each undeclared identifier is
> reported only once
> arch/ia64/mm/init.c:215: error: for each function it appears in.)
> arch/ia64/mm/init.c:216: error: implicit declaration of function
> 'GRANULEROUNDDOWN'
> 

`max_addr' is an awesomely bad name for a global identifier, btw.

And this:

-static u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;
+u64 mem_limit = ~0UL, max_addr = ~0UL, min_addr = 0UL;

needlessly exported `mem_limit' and `min_addr' as well.  These too are
very poor global identifiers.

Also, Matt suggested an alternative implementation which afaik hasn't
been responded to.


I think I'll just drop the patch.
