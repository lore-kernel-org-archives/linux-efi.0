From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 1/2] x86/efi: Correct a tiny mistake in code comment
Date: Thu, 9 Mar 2017 09:38:52 +0800
Message-ID: <20170309013852.GD12600@dhcp-128-65.nay.redhat.com>
References: <1488959258-4731-1-git-send-email-bhe@redhat.com>
 <20170308081812.GA12600@dhcp-128-65.nay.redhat.com>
 <20170308084513.GF18014@x1>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170308084513.GF18014@x1>
Sender: linux-kernel-owner@vger.kernel.org
To: Baoquan He <bhe@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, thgarnie@google.com, keescook@chromium.org, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, akpm@linux-foundation.org, bp@suse.de
List-Id: linux-efi@vger.kernel.org

Hi,

On 03/08/17 at 04:45pm, Baoquan He wrote:
> Forgot cc to Boris, add him.
> 
> On 03/08/17 at 04:18pm, Dave Young wrote:
> > On 03/08/17 at 03:47pm, Baoquan He wrote:
> > > EFI allocate runtime services regions down from EFI_VA_START, -4G.
> > > It should be top-down handling.
> > > 
> > > Signed-off-by: Baoquan He <bhe@redhat.com>
> > > ---
> > >  arch/x86/platform/efi/efi_64.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > 
> > > diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
> > > index a4695da..6cbf9e0 100644
> > > --- a/arch/x86/platform/efi/efi_64.c
> > > +++ b/arch/x86/platform/efi/efi_64.c
> > > @@ -47,7 +47,7 @@
> > >  #include <asm/pgalloc.h>
> > >  
> > >  /*
> > > - * We allocate runtime services regions bottom-up, starting from -4G, i.e.
> > > + * We allocate runtime services regions top-down, starting from -4G, i.e.
> > 
> > Baoquan, I think original bottom-up is right, it is just considering
> > -68G as up, see the x86_64 mm.txt. We regard vmalloc as higher address
> > although from mathematics view it is lower then positive addresses.
> 
> Thanks for reviewing!
> 
> I am not sure. Just in efi_map_region() it gets the starting va to map
> 'size' big of region by below code:
> 	efi_va -= size;
> 
> -4G and -68G just a trick which makes people understand easily, still we
> think kernel text mapping region is in higher addr area then vmalloc. I
> personnally think.

I understand your points, there is not right or wrong. So I think drop
the words like the change in your V2 looks good.

Thanks
Dave
