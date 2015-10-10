From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [PATCH v7 1/2] efi: export efi_capsule_supported() function
 symbol
Date: Sat, 10 Oct 2015 23:02:02 +0100
Message-ID: <20151010220202.GH2723@codeblueprint.co.uk>
References: <1444076155-19295-1-git-send-email-hock.leong.kweh@intel.com>
 <1444076155-19295-2-git-send-email-hock.leong.kweh@intel.com>
 <20151005131350.GA26329@nazgul.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20151005131350.GA26329@nazgul.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Ong Boon Leong <boon.leong.ong@intel.com>, LKML <linux-kernel@vger.kernel.org>, linux-efi@vger.kernel.org, Sam Protsenko <semen.protsenko@linaro.org>, Peter Jones <pjones@redhat.com>, Andy Lutomirski <luto@amacapital.net>, Roy Franz <roy.franz@linaro.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, Fleming Matt <matt.fleming@intel.com>
List-Id: linux-efi@vger.kernel.org

On Mon, 05 Oct, at 03:13:50PM, Borislav Petkov wrote:
> On Tue, Oct 06, 2015 at 04:15:54AM +0800, Kweh, Hock Leong wrote:
> > From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
> > 
> > This patch export efi_capsule_supported() function symbol for capsule
> > kernel module to use.
> > 
> > Cc: Matt Fleming <matt.fleming@intel.com>
> > Signed-off-by: Kweh, Hock Leong <hock.leong.kweh@intel.com>
> > ---
> >  drivers/firmware/efi/capsule.c |    1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/drivers/firmware/efi/capsule.c b/drivers/firmware/efi/capsule.c
> > index d8cd75c0..738d437 100644
> > --- a/drivers/firmware/efi/capsule.c
> > +++ b/drivers/firmware/efi/capsule.c
> > @@ -101,6 +101,7 @@ out:
> >  	kfree(capsule);
> >  	return rv;
> >  }
> > +EXPORT_SYMBOL_GPL(efi_capsule_supported);
> 
> So this one is still a separate patch.
> 
> If you're going to ignore review comments, maybe I should stop wasting
> my time reviewing your stuff...

I agree that it makes sense to fold this patch into your PATCH 2,
because then we know why we need the above symbol to be exported.

-- 
Matt Fleming, Intel Open Source Technology Center
