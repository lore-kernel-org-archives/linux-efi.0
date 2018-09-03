From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V2 5/6] x86/mm: If in_atomic(), allocate pages without
 sleeping
Date: Mon, 3 Sep 2018 10:53:26 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809031048430.1349@nanos.tec.linutronix.de>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com> <1535881594-25469-6-git-send-email-sai.praneeth.prakhya@intel.com> <20180903083459.GT24124@hirez.programming.kicks-ass.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180903083459.GT24124@hirez.programming.kicks-ass.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org, ricardo.neri@intel.com, matt@codeblueprint.co.uk, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

On Mon, 3 Sep 2018, Peter Zijlstra wrote:

Thanks for CC'ing me. I wonder why the world and some more is on CC, but
x86@kernel.org is NOT.

> On Sun, Sep 02, 2018 at 02:46:33AM -0700, Sai Praneeth Prakhya wrote:

> > @@ -926,7 +926,13 @@ static void unmap_pud_range(p4d_t *p4d, unsigned long start, unsigned long end)
> >  
> >  static int alloc_pte_page(pmd_t *pmd)
> >  {
> > -	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +	pte_t *pte;
> > +
> > +	if (in_atomic())
> > +		pte = (pte_t *)get_zeroed_page(GFP_ATOMIC);
> > +	else
> > +		pte = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +
> >  	if (!pte)
> >  		return -1;
> >  
> 
> This looks like tinkering to me..

Yes it is and it's not going to happen.

Thanks,

	tglx
