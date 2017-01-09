From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: [PATCH v2 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Mon, 9 Jan 2017 13:45:02 +0000
Message-ID: <20170109134502.GK16838@codeblueprint.co.uk>
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

Indeed. I've only ever seen this situation lead to silent memory
corruption and bitter tears.

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
