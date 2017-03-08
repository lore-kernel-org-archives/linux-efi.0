From: Baoquan He <bhe@redhat.com>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Wed, 8 Mar 2017 17:08:33 +0800
Message-ID: <20170308090833.GA6570@x1>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
 <20170308084513.GF18014@x1>
 <20170308085447.pt55rref5eqmuf5x@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308085447.pt55rref5eqmuf5x@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@suse.de>
Cc: Dave Young <dyoung@redhat.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, thgarnie@google.com, keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org
List-Id: linux-efi@vger.kernel.org

On 03/08/17 at 09:54am, Borislav Petkov wrote:
> On Wed, Mar 08, 2017 at 04:45:13PM +0800, Baoquan He wrote:
> > -4G and -68G just a trick which makes people understand easily, still we
> > think kernel text mapping region is in higher addr area then vmalloc. I
> > personnally think.
> 
> Just remove the direction: bottom-up or top-down, it will confuse people.
> 
> "We allocate runtime services regions starting from -4G, i.e.
> 0xffff_ffff_0000_0000 and decrement as we go. The EFI VA mapping space
> is limited to 64G."

Right, will repost one.

Thanks!
