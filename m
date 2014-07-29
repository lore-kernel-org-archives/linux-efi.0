From: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] x86, efi: print debug values in Kib not MB
Date: Tue, 29 Jul 2014 15:02:48 -0700
Message-ID: <1406671368.12100.5.camel@joe-AO725>
References: <1406653761-3884-1-git-send-email-prarit@redhat.com>
	 <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1407291327450.13073@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: David Rientjes <rientjes@google.com>
Cc: Prarit Bhargava <prarit@redhat.com>, linux-kernel@vger.kernel.org, lszubowi@redhat.com, Matt Fleming <matt.fleming@intel.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On Tue, 2014-07-29 at 13:29 -0700, David Rientjes wrote:
> On Tue, 29 Jul 2014, Prarit Bhargava wrote:
> > diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
[]
> > @@ -384,10 +384,10 @@ static void __init print_efi_memmap(void)
> >  	     p < memmap.map_end;
> >  	     p += memmap.desc_size, i++) {
> >  		md = p;
> > -		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
> > +		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluKiB)\n",
> >  			i, md->type, md->attribute, md->phys_addr,
> >  			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
> > -			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
> > +			(md->num_pages << 2));
> >  	}
> >  #endif  /*  EFI_DEBUG  */
> >  }
> 
> If EFI_PAGE_SHIFT were to ever change from its hard-coded 12, then( this 
> would be wrong.  Any reason to not simply print EFI_PAGE_SIZE and 
> md->num_pages?

Or maybe ((u64)EFI_PAGE_SIZE * md->num_pages) >> 10
