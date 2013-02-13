From: Tony Luck <tony.luck@gmail.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
Date: Tue, 12 Feb 2013 16:32:16 -0800
Message-ID: <CA+8MBbK7ZSkk2tOfjbeKuyCJ1mBT5OeY3GHKLS2EVFwH_nXZYA@mail.gmail.com>
References: <51074786.5030007@huawei.com>
	<1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com>
	<51131248.3080203@huawei.com>
	<5113450C.1080109@huawei.com>
	<CA+8MBb+3_xWv1wMWv0+gwWm9exPCNTZWG3mXQnBsUbc5fJnuiA@mail.gmail.com>
	<20130212161912.6a9e9293.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <20130212161912.6a9e9293.akpm@linux-foundation.org>
Sender: owner-linux-mm@kvack.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Xishi Qiu <qiuxishi@huawei.com>, Matt Fleming <matt.fleming@intel.com>, fenghua.yu@intel.com, Liujiang <jiang.liu@huawei.com>, linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-mm@kvack.org, Hanjun Guo <guohanjun@huawei.com>, WuJianguo <wujianguo@huawei.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Feb 12, 2013 at 4:19 PM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> But, umm, why am I sitting here trying to maintain an ia64 bugfix and
> handling bug reports from the ia64 maintainer?  Wanna swap?

That sounds like a plan.  I'll look out for a new version with the
missing #include
and less silly global variable names and try to take it before you
pull it into -mm

-Tony

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
