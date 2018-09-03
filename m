From: "Prakhya, Sai Praneeth" <sai.praneeth.prakhya@intel.com>
Subject: RE: [PATCH V2 4/6] x86/efi: Add efi page fault handler to
 fixup/recover from page faults caused by firmware
Date: Mon, 3 Sep 2018 17:16:01 +0000
Message-ID: <FFF73D592F13FD46B8700F0A279B802F485B9218@ORSMSX114.amr.corp.intel.com>
References: <1535881594-25469-1-git-send-email-sai.praneeth.prakhya@intel.com>
 <1535881594-25469-5-git-send-email-sai.praneeth.prakhya@intel.com>
 <alpine.DEB.2.21.1809031053340.1349@nanos.tec.linutronix.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.21.1809031053340.1349@nanos.tec.linutronix.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Neri, Ricardo" <ricardo.neri@intel.com>, "matt@codeblueprint.co.uk" <matt@codeblueprint.co.uk>, Lee Chun-Yi <jlee@suse.com>, Al Stone <astone@redhat.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Bhupesh Sharma <bhsharma@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>
List-Id: linux-efi@vger.kernel.org

> > The efi specific page fault handler offers us two advantages:
> > 1. Avoid panics/hangs caused by buggy firmware.
> > 2. Shout loud that the firmware is buggy and hence is not a kernel bug.
> >
> > Finally, this new mapping will not impact a reboot from kexec, as
> > kexec is only concerned about runtime memory regions.
> 
> No. This is just a horrible hack to make completely bogus firmware work and
> never fixed.
> 

Yes, that's true.

> The proper thing to do is to have a minimal page fault handler which does:
> 
>  1) Yell loudly if that ever happens
> 
>  2) Handles the reboot request gracefully
> 
>  3) Freeze and disable the EFI mess for all other cases
> 
> That does not require any hackery to make these mappings work from atomic
> context and keeps the mess confined to the EFI code where it belongs.
> 
> Ideally we just blacklist the offending system and be done with it.

This makes sense to me. I will implement the above suggested and as said should 
avoid the need for making mappings work from atomic context.

Regards,
Sai
