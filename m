From: joeyli <jlee@suse.com>
Subject: Re: [PATCH v2 06/16] x86/efi: Generating random HMAC key for siging
 hibernate image
Date: Sun, 13 Sep 2015 10:47:15 +0800
Message-ID: <20150913024715.GA6752@linux-rxt1.site>
References: <1439273796-25359-1-git-send-email-jlee@suse.com>
 <1439273796-25359-7-git-send-email-jlee@suse.com>
 <20150820204044.GG2567@codeblueprint.co.uk>
 <20150827090452.GB27415@linux-rxt1.site>
 <20150909121545.GD4973@codeblueprint.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-pm-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150909121545.GD4973@codeblueprint.co.uk>
Sender: linux-pm-owner@vger.kernel.org
To: Matt Fleming <matt@codeblueprint.co.uk>
Cc: "Lee, Chun-Yi" <joeyli.kernel@gmail.com>, linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Matthew Garrett <matthew.garrett@nebula.com>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Josh Boyer <jwboyer@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>, Matt Fleming <matt.fleming@intel.com>, Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Wed, Sep 09, 2015 at 01:15:45PM +0100, Matt Fleming wrote:
> On Thu, 27 Aug, at 05:04:52PM, joeyli wrote:
> > 
> > The purpose of checking attribute of hibernation key variable is 
> > in case someone created a key variable on runtime environment _before_
> > this kernel create boot service variable. That causes EFI stub may load
> > a key that from non-secure environment.
> > 
> > That's why delete non-boot service variable and create new one here.
>  
> I think bailing is more appropriate in that case, not deleting the
> variable. The environment is not what we expected it to be, so we
> shouldn't tamper with it.
> 
> But I don't feel super strongly about this point. I just wanted to
> raise the question of whether it actually makes sense to delete the
> variable that we obviously didn't create or whether it makes more
> sense to refuse to verify hibernation images.
>

Thanks for you point out. But, I want keep this logic to avoid someone
create a runtime variable with the same name-SSID to confuse the key
generator in EFI stub.
 
> > > > diff --git a/arch/x86/include/asm/suspend.h b/arch/x86/include/asm/suspend.h
> > > > index 2fab6c2..ab463c4 100644
> > > > --- a/arch/x86/include/asm/suspend.h
> > > > +++ b/arch/x86/include/asm/suspend.h
> > > > @@ -3,3 +3,12 @@
> > > >  #else
> > > >  # include <asm/suspend_64.h>
> > > >  #endif
> > > > +
> > > > +#ifdef CONFIG_HIBERNATE_VERIFICATION
> > > > +#include <linux/suspend.h>
> > > > +
> > > > +struct hibernation_keys {
> > > > +	unsigned long hkey_status;
> > > > +	u8 hibernation_key[HIBERNATION_DIGEST_SIZE];
> > > > +};
> > > > +#endif
> > > 
> > > Have you given any thought to how things are going to work if we
> > > change the hash function in the future, or provide a choice? That
> > > information doesn't appear anywhere in the above struct.
> > > 
> > 
> > Do you mean the hash function of signing hibernation image changed, so the
> > hibernation key also need to re-generate for new length?
>  
> Yeah, that kind of thing.
> 
> > I will add a field in struct to forward the length of hibernation key variable.
> > In the future kernel can check the length to handle the change.
> 
> Would it also make sense to explicitly record the hash function used
> as well as the length?
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center

The job of key generator in EFI stub is to generate appropriate length of key
for usage by later activities. It doesn't need to know how does kernel use
which kind of hash algorithm, so I think do not need record the hash function.

But, kernel should knows the exactly length of old key to decide if it needs to
use flag to trigger key regeneration process in EFI stub to create new key for
new length.

Only the other hand, the hash algorithm of hibernation was setted in kernel
compiler time even user can change  it, so I think to forward the key length
from querying efi variable is enough, don't need write the hash algorithm to
EFI boot variable.


Thanks a lot!
Joey Lee

