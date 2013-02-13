From: Tony Luck <tony.luck-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
Date: Tue, 12 Feb 2013 16:11:33 -0800
Message-ID: <CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5113450C.1080109-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Matt Fleming <matt.fleming-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, fenghua.yu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Liujiang <jiang.liu-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-ia64-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Hanjun Guo <guohanjun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, WuJianguo <wujianguo-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-efi@vger.kernel.org

Building linux-next today (tag next-20130212) I get the following errors when
building arch/ia64/configs/{tiger_defconfig, zx1_defconfig, bigsur_defconfig,
sim_defconfig}

arch/ia64/mm/init.c: In function 'free_initrd_mem':
arch/ia64/mm/init.c:215: error: 'max_addr' undeclared (first use in
this function)
arch/ia64/mm/init.c:215: error: (Each undeclared identifier is
reported only once
arch/ia64/mm/init.c:215: error: for each function it appears in.)
arch/ia64/mm/init.c:216: error: implicit declaration of function
'GRANULEROUNDDOWN'

with "git blame" saying that these lines in init.c were added/changed by

commit 5a54b4fb8f554b15c6113e30ca8412b7fe11c62e
Author: Xishi Qiu <qiuxishi-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date:   Thu Feb 7 12:25:59 2013 +1100

    ia64/mm: fix a bad_page bug when crash kernel booting

-Tony
