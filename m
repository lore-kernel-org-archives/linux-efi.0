From: Mel Gorman <mgorman@techsingularity.net>
Subject: Re: [PATCH v2 2/2] efi: efi_mem_reserve(): don't reserve through
 memblock after mm_init()
Date: Mon, 9 Jan 2017 13:31:52 +0000
Message-ID: <20170109133152.2izkcrzgzinxdwux@techsingularity.net>
References: <20161222102340.2689-1-nicstange@gmail.com>
 <20161222102340.2689-2-nicstange@gmail.com>
 <20170105091242.GA11021@dhcp-128-65.nay.redhat.com>
 <20170109114400.GF16838@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20170109114400.GF16838@codeblueprint.co.uk>
Sender: owner-linux-mm@kvack.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: Dave Young <dyoung@redhat.com>, Nicolai Stange <nicstange@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, Mika =?iso-8859-15?Q?Penttil=E4?= <mika.penttila@nextfour.com>, Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.cz>
List-Id: linux-efi@vger.kernel.org

On Mon, Jan 09, 2017 at 11:44:00AM +0000, Matt Fleming wrote:
> On Thu, 05 Jan, at 05:12:42PM, Dave Young wrote:
> > On 12/22/16 at 11:23am, Nicolai Stange wrote:
> > > Before invoking the arch specific handler, efi_mem_reserve() reserves
> > > the given memory region through memblock.
> > > 
> > > efi_mem_reserve() can get called after mm_init() though -- through
> > > efi_bgrt_init(), for example. After mm_init(), memblock is dead and should
> > > not be used anymore.
> > 
> > It did not fail during previous test so we did not catch this bug, if memblock
> > can not be used after mm_init(), IMHO it should fail instead of silently succeed.
>  
> This must literally be the fifth time or so that I've been caught out
> by this over the years because there's no hard error if you call the
> memblock code after slab and co. are up.
> 
> MM folks, is there some way to catch these errors without requiring
> the sprinkling of slab_is_available() everywhere?
> 

Well, you could put in a __init global variable about availability into
mm/memblock.c and then check it in memblock APIs like memblock_reserve()
to BUG_ON? I know BUG_ON is frowned upon but this is not likely to be a
situation that can be sensibly recovered.

-- 
Mel Gorman
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
