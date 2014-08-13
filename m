From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH 3/5] efi arm64: do not enter virtual mode in case booting
 with efi=noruntime or noefi
Date: Wed, 13 Aug 2014 09:29:41 +0800
Message-ID: <20140813012941.GA2669@darkstar.nay.redhat.com>
References: <1407823822-23829-1-git-send-email-dyoung@redhat.com>
 <1407823822-23829-3-git-send-email-dyoung@redhat.com>
 <20140812104627.GI29013@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <20140812104627.GI29013@arm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Will Deacon <will.deacon@arm.com>
Cc: Alessandro Zummo <a.zummo@towertech.it>, Matt Fleming <matt.fleming@intel.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Catalin Marinas <Catalin.Marinas@arm.com>, "msalter@redhat.com" <msalter@redhat.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Leif Lindholm <leif.lindholm@linaro.org>, Ingo Molnar <mingo@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, "hpa@zytor.com" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-efi@vger.kernel.org

On 08/12/14 at 11:46am, Will Deacon wrote:
> On Tue, Aug 12, 2014 at 07:10:20AM +0100, Dave Young wrote:
> > In case efi runtime disabled via noefi kernel cmdline arm64_enter_virtual_mode
> > should error out.
> > 
> > At the same time move early_memunmap(memmap.map, mapsize) to the beginning of
> > the function or it will leak early mem.
> > 
> > Signed-off-by: Dave Young <dyoung@redhat.com>
> > ---
> >  arch/arm64/kernel/efi.c | 7 ++++---
> >  1 file changed, 4 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index e72f310..324cdd1 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c
> > @@ -386,7 +386,10 @@ static int __init arm64_enter_virtual_mode(void)
> >  	int count = 0;
> >  	unsigned long flags;
> >  
> > -	if (!efi_enabled(EFI_BOOT)) {
> > +	mapsize = memmap.map_end - memmap.map;
> > +	early_memunmap(memmap.map, mapsize);
> > +
> > +	if (!efi_enabled(EFI_BOOT) || efi_runtime_disabled()) {
> 
> Hmm, is this right? We only set EFI_BOOT if we find EFI parameters in the
> DT (see efi_init -> uefi_init), so you run the risk of unmapping something
> we never mapped here.

Good catch, I missed the case. will fix it in next update

> 
> Furthermore, there seems to be a leak in uefi_init anyway, as we return
> -EINVAL if the signature of the EFI table doesn't match without unmapping it
> first.

Yes, will add a new patch to fix the error handling in uefi_init.

BTW, Matt, I forgot to cc Xen/SGI people, will send an update soon and cc them.

Thanks
Dave
