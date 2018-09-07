From: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Fri, 7 Sep 2018 22:13:34 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809072200030.1402@nanos.tec.linutronix.de>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com> <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com> <20180907112207.GS24106@hirez.programming.kicks-ass.net> <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
 <e10acaa8-f5d8-85f3-219c-86fafd793a87@redhat.com> <FFF73D592F13FD46B8700F0A279B802F485BA620@ORSMSX114.amr.corp.intel.com> <alpine.DEB.2.21.1809072116530.1402@nanos.tec.linutronix.de> <CACi5LpM4QoRn5bAwR-ZJHhaih7N41HYGx6MPZXAY78jFsbu9dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CACi5LpM4QoRn5bAwR-ZJHhaih7N41HYGx6MPZXAY78jFsbu9dg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bhupesh Sharma <bhsharma@redhat.com>
Cc: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Sat, 8 Sep 2018, Bhupesh Sharma wrote:
> On Sat, Sep 8, 2018 at 12:52 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> > If the distro patched their kernel to deal with buggy firmware, then:
> >
> >  1) why did they not upstream it ?
> 
> Because some of the kernel fixes are (for such cases), well to be
> honest, ugly.. and probably not suitable for placement in quirks
> files/common code present upstream as they introduce lots of #ifdef
> jugglery.
> 
> Also the x86 machines with such buggy BIOS firmwares are too old (but
> still used in some production environment) and the OS workarounds are
> suggested by the vendors themselves and they historically had issues
> getting the quirks upstream.

Right, because they did not even try. And the distros just integrated that
mess instead of telling them to fix the crappy firmware. And that can be
fixed. I know for sure because the RT qualification program at RH has made
vendors to fix their crap in order to get the rubber stamp.

> >  2) why should we worry about that ?
> 
> As this allows one to still promote upgrading such machines to
> upstream kernel versions and keep the kernel running on them as close
> as possible to mainline.

If the firmware is buggy and trips faults in the EFI mess then mainline
will just crash and burn.

So how are you going to upgrade these machines to a mainline kernel with
that fault handler disabled? Not at all.

If you need to patch the kernel in order to make it work on mainline, then
still that EFI fault handler has ZERO impact. Because those patches need to
prevent the firmware from faulting in the first place. If they have magic
fault handlers for this crap themself, then the patches will conflict
anyway, config switch or not.

You have to come up with something more convincing.

Thanks,

	tglx
