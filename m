From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH v2 RESEND 1/2] x86/UV: Introduce a helper function to
 check UV system at earlier stage
Date: Fri, 15 Sep 2017 08:55:32 +0800
Message-ID: <20170915005532.GA2322@dhcp-128-65.nay.redhat.com>
References: <1504770150-25456-1-git-send-email-bhe@redhat.com>
 <1504770150-25456-2-git-send-email-bhe@redhat.com>
 <20170914072952.GN12824@x1>
 <20170914074901.GA5182@dhcp-128-65.nay.redhat.com>
 <20170914080814.GO12824@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170914080814.GO12824@x1>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com, thgarnie@google.com, keescook@chromium.org, akpm@linux-foundation.org, yamada.masahiro@socionext.com, rja@hpe.com, frank.ramsay@hpe.com, linux-efi@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

Missed a comma in cc list in last reply, readd linux-efi list in cc.
On 09/14/17 at 04:08pm, Baoquan He wrote:
> On 09/14/17 at 03:49pm, Dave Young wrote:
> > > > diff --git a/arch/x86/include/asm/uv/uv.h b/arch/x86/include/asm/uv/uv.h
> > > > index b5a32231abd8..93d7ad8763ba 100644
> > > > --- a/arch/x86/include/asm/uv/uv.h
> > > > +++ b/arch/x86/include/asm/uv/uv.h
> > > > @@ -18,6 +18,11 @@ extern void uv_nmi_init(void);
> > > >  extern void uv_system_init(void);
> > > >  extern const struct cpumask *uv_flush_tlb_others(const struct cpumask *cpumask,
> > > >  						 const struct flush_tlb_info *info);
> > > > +#include <linux/efi.h>
> > > > +static inline int is_early_uv_system(void)
> > > > +{
> > > > +	return !((efi.uv_systab == EFI_INVALID_TABLE_ADDR) || !efi.uv_systab);
> > > > +}
> > 
> 
> Thanks for looking into this, Dave!
> 
> > 
> > Sorry for jumping in late, I have two questions about the patch:
> > 
> > 1) For efi tables, the only invalid value is EFI_INVALID_TABLE_ADDR, and
> > efi struct is initialized as EFI_INVALID_TABLE_ADDR by default so no
> > need to check "|| !efi.uv_systab". Do we have any UV firmware specific
> > assumption that "0" is also possible to be assigned?
> 
> Hmm, in uv_bios_init() it also checks the !efi.uv_systab case. And
> EFI_INVALID_TABLE_ADDR checking is earlier, it won't affect the result
> if it's EFI_INVALID_TABLE_ADDR. And !efi.uv_systab can make it safer
> since it doesn't work either if efi.uv_systab is 0. Mainly it's not
> harmful.
> 
> Mike, what's your thought? Should I only check the (efi.uv_systab ==
> EFI_INVALID_TABLE_ADDR) case?
> 
> > 
> > 2) It seems adding this function in uv.h for separating this for uv
> > system only purpose. But I feel it is better to put it in efi.h instead.
> 
> At the beginning I put it in efi.c, later Mike suggested putting it in
> asm/uv/uv.h. You can also find the discussion in below link.
> https://patchwork.kernel.org/patch/9732787/
> 
> Thanks
> Baoquan
> 
> > 
> > uv_systab is already a member of struct efi, it is in efi.h so it is
> > natural to check the table exist or not. Then just include efi.h in
> > kaslr.c and use the function.
> > 
> > something like drivers/firmware/efi/esrt.c: esrt_table_exists()
> > 
> > Anyway I have no strong opinon, it looks more natural to me though.
> > 
> > > >  
> > > >  #else	/* X86_UV */
> > > >  
> > > > @@ -30,6 +35,7 @@ static inline const struct cpumask *
> > > >  uv_flush_tlb_others(const struct cpumask *cpumask,
> > > >  		    const struct flush_tlb_info *info)
> > > >  { return cpumask; }
> > > > +static inline int is_early_uv_system(void)	{ return 0; }
> > > >  
> > > >  #endif	/* X86_UV */
> > > >  
> > > > -- 
> > > > 2.5.5
> > > > 
> > 
> > Thanks
> > Dave
