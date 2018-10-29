From: Russell King - ARM Linux <linux@armlinux.org.uk>
Subject: Re: [PATCH 0/8] add generic builtin command line
Date: Mon, 29 Oct 2018 10:44:41 +0000
Message-ID: <20181029104441.GF30658@n2100.armlinux.org.uk>
References: <1538067309-5711-1-git-send-email-maksym.kokhan@globallogic.com>
 <20180929181725.GB27441@fifo99.com>
 <CAMT6-xiQ0vGcKpA+SiWHQWQFwU9Oo9j=Zin+UXDoPqKTz5fbeA@mail.gmail.com>
 <CAMT6-xj1rjVAy1AWFiMHc5wH36eu=TUSMtdKU=-qRtUbwr9bkg@mail.gmail.com>
 <20181023144815.GP30658@n2100.armlinux.org.uk>
 <CAMT6-xhvqy5PeQmkQ8tsLRiML_pNJTxyq7dizRRvZTEqc7uzgg@mail.gmail.com>
 <20181024090732.GS30658@n2100.armlinux.org.uk>
 <20181029102914.GA14127@arm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20181029102914.GA14127@arm.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Will Deacon <will.deacon@arm.com>
Cc: Maksym Kokhan <maksym.kokhan@globallogic.com>, Daniel Walker <dwalker@fifo99.com>, Andrew Morton <akpm@linux-foundation.org>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Ralf Baechle <ralf@linux-mips.org>, Paul Burton <paul.burton@mips.com>, James Hogan <jhogan@kernel.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Paul Mackerras <paulus@samba.org>, Michael Ellerman <mpe@ellerman.id.au>, Daniel Walker <danielwa@cisco.com>, Andrii Bordunov <aborduno@cisco.com>, Ruslan
List-Id: linux-efi@vger.kernel.org

On Mon, Oct 29, 2018 at 10:29:15AM +0000, Will Deacon wrote:
> On Wed, Oct 24, 2018 at 10:07:32AM +0100, Russell King - ARM Linux wrote:
> > On Wed, Oct 24, 2018 at 11:57:44AM +0300, Maksym Kokhan wrote:
> > > Do you mean, that you haven't seen patch for ARM, which I sent on
> > > September 27 along with cover and patch 1? It is strange, because
> > > you was the one from recipients. If so, you can see this patch here:
> > > https://lore.kernel.org/patchwork/patch/992779/
> > 
> > It seems that I have received patch 5, _but_ it's not threaded with
> > the cover message and patch 1.  With 50k messages in my inbox, and 3k
> > messages since you sent the series, it's virtually impossible to find
> > it (I only found it by looking at my mail server logs from September
> > to find the subject, and then searching my mailbox for that subject.)
> > 
> > This is unnecessarily difficult.
> 
> This comes up surprisingly often, and I think part of the issue is that
> different maintainers have different preferences. I also prefer to receive
> the entire series and cover-letter, but I've seen people object to being
> CC'd on the whole series as well (how they manage to review things in
> isolation is another question...!)

This series has the odd situation where patch 1 is threaded to the
cover letter, but nothing else is - that makes it inconsistent.

Where I've seen people disagree with threading is when sending
follow-up series - whether that should be threaded to the previous
series or not - some people want it others hate it.

However, I haven't seen any disagreement is about having the patches
threaded to the cover.

-- 
RMK's Patch system: http://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
