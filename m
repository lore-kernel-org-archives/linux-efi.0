From: Thomas Gleixner <tglx@linutronix.de>
Subject: RE: [PATCH V4 3/3] x86/efi: Introduce EFI_PAGE_FAULT_HANDLER
Date: Fri, 7 Sep 2018 21:22:14 +0200 (CEST)
Message-ID: <alpine.DEB.2.21.1809072116530.1402@nanos.tec.linutronix.de>
References: <1536276468-28499-1-git-send-email-sai.praneeth.prakhya@intel.com> <1536276468-28499-4-git-send-email-sai.praneeth.prakhya@intel.com> <20180907112207.GS24106@hirez.programming.kicks-ass.net> <FFF73D592F13FD46B8700F0A279B802F485BA5C1@ORSMSX114.amr.corp.intel.com>
 <e10acaa8-f5d8-85f3-219c-86fafd793a87@redhat.com> <FFF73D592F13FD46B8700F0A279B802F485BA620@ORSMSX114.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <FFF73D592F13FD46B8700F0A279B802F485BA620@ORSMSX114.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Cc: Bhupesh Sharma <bhsharma@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Peter Zijlstra <peterz@infradead.org>
List-Id: linux-efi@vger.kernel.org

On Fri, 7 Sep 2018, Prakhya, Sai Praneeth wrote:
> > > So, if Thomas, Ingo, Andy, Ard and Boris are ok.. I will make it as
> > > default (i.e. without config).

Yes, that's the right thing to do.

> > Also, some distributions already have specific ways to handle buggy
> > firmwares which can be at times dependent on the underlying hardware
> > and the firmware versions.

If the distro patched their kernel to deal with buggy firmware, then:

 1) why did they not upstream it ?

 2) why should we worry about that ?

> > I would suggest that we enable this under a CONFIG for the first round
> > and once it is tested with wider variety of x86 machines which have
> > buggy or orphaned firmware and linux (and reboot) works fine with them,
> > we can drop the CONFIG option in future and enable this by default.

Sure and then nobody enables it and the affected machines still crash or
hang on reboot. The whole thing is simple enough now to make it
unconditional.

> Sounds fair to me, but, I would like to wait for someone experienced to
> make the final call.

Please get rid of that config knob. Buggy firmware exists and we better
deal with it by default.

Thanks,

	tglx
