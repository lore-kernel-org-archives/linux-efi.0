From: Leif Lindholm <leif.lindholm@linaro.org>
Subject: Re: [PATCH 1/2] arm64: don't make early_*map() calls post
 paging_init()
Date: Tue, 6 Jan 2015 13:39:17 +0000
Message-ID: <20150106133917.GB3827@bivouac.eciton.net>
References: <1420482835-6444-1-git-send-email-leif.lindholm@linaro.org>
 <1420482835-6444-2-git-send-email-leif.lindholm@linaro.org>
 <CAKv+Gu_EWCYYcmsLuojGGQ+6x+Lp5fWJQ+4fvR-4fqXqU2f53Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <CAKv+Gu_EWCYYcmsLuojGGQ+6x+Lp5fWJQ+4fvR-4fqXqU2f53Q@mail.gmail.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Will Deacon <will.deacon@arm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Mark Salter <msalter@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Tue, Jan 06, 2015 at 09:38:24AM +0000, Ard Biesheuvel wrote:
> > diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
> > index 6fac253..790adb5 100644
> > --- a/arch/arm64/kernel/efi.c
> > +++ b/arch/arm64/kernel/efi.c

> > @@ -393,6 +385,8 @@ static int __init arm64_enter_virtual_mode(void)
> >                                                    mapsize);
> >         memmap.map_end = memmap.map + mapsize;
> >
> > +       efi_setup_idmap();
> > +
> 
> I think this is incorrect: we may call early_alloc() here which is
> only allowed before paging_init()

Hmm...
Technically, the existing code is already breaking this restriction
then - but my patch moved that _way_ later in the boot process (early
initcall instead of setup_arch()).

I'll resend with an alternative solution that leaves the
efi_setup_idmap() ordering vs paging init() in its current state.
Since efi_setup_idmap() goes away with your "stable UEFI virtual
mappings for kexec" series, I don't want to make changes here and for
potential backports too invasive.

/
    Leif
