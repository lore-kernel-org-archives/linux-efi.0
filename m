From: Matt Fleming <matt@codeblueprint.co.uk>
Subject: Re: Cannot load linux after recent efi-related changes
Date: Mon, 19 Sep 2016 12:41:53 +0100
Message-ID: <20160919114153.GD2892@codeblueprint.co.uk>
References: <20160917162357.GA4122@gmail.com>
 <20160918011443.GA4475@gmail.com>
 <20160919111424.GB2892@codeblueprint.co.uk>
 <20160919113634.GA4140@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160919113634.GA4140@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Krinkin <krinkin.m.u@gmail.com>
Cc: mingo@kernel.org, tglx@linutronix.de, hpa@zytor.com, ricardo.neri-calderon@linux.intel.com, ard.biesheuvel@linaro.org, pjones@redhat.com, scott.lawson@intel.com, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, Mike Galbraith <umgwanakikbuti@gmail.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 19 Sep, at 02:36:36PM, Mike Krinkin wrote:
> On Mon, Sep 19, 2016 at 12:14:24PM +0100, Matt Fleming wrote:
> > On Sun, 18 Sep, at 04:14:45AM, Mike Krinkin wrote:
> > > 
> > > diff --git a/drivers/firmware/efi/memmap.c b/drivers/firmware/efi/memmap.c
> > > index cd96086..34322d1 100644
> > > --- a/drivers/firmware/efi/memmap.c
> > > +++ b/drivers/firmware/efi/memmap.c
> > > @@ -221,8 +221,8 @@ void __init efi_memmap_insert(struct efi_memory_map *old_memmap, void *buf,
> > >  	void *old, *new;
> > >  
> > >  	/* modifying range */
> > > -	m_start = mem->range.start;
> > > -	m_end = mem->range.end;
> > > +	m_start = mem->range.start & ~(u64)EFI_PAGE_SIZE;
> > > +	m_end = ALIGN(mem->range.end, EFI_PAGE_SIZE) - 1;
> > >  	m_attr = mem->attribute;
> > >  
> > >  	for (old = old_memmap->map, new = buf;
> > 
> > Thanks for the analysis and patch Mike, but this needs fixing further
> > up the call stack so that we don't map things the caller didn't
> > expect.
> > 
> > This bug was also reported in this thread,
> > 
> >   https://lkml.kernel.org/r/1474005912.3930.10.camel@gmail.com
> 
> Sorry, i haven't seen that.
 
No problem.

> > 
> > Could you try this patch?
> 
> Works fine for me.

Thanks, I've added your Tested-by.
