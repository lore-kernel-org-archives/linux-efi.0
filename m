From: Dave Young <dyoung-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: EFI stub kexec probelm
Date: Thu, 16 Feb 2017 16:05:09 +0800
Message-ID: <20170216080509.GA2841@dhcp-128-65.nay.redhat.com>
References: <7b5d8a74-2b5d-92f9-5265-b892b3bea2aa@camlintechnologies.com>
 <87bmu21w4k.fsf@xmission.com>
 <20170216072005.GD3942@dhcp-128-65.nay.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170216072005.GD3942-0VdLhd/A9Pl+NNSt+8eSiB/sF2h8X+2i0E9HWUfgJXw@public.gmane.org>
Sender: linux-efi-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, =?utf-8?B?UGF3ZcWC?= Lenkow <p.lenkow-WZXhJxzPxo0FoECaAgFIynS5uNuOjpZe@public.gmane.org>
Cc: matt-mF/unelCI9GS6iBeEJttW/XRex20P6io@public.gmane.org, Kexec Mailing List <kexec-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>, linux-efi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ard.biesheuvel-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org
List-Id: linux-efi@vger.kernel.org

On 02/16/17 at 03:20pm, Dave Young wrote:
> On 02/16/17 at 07:35pm, Eric W. Biederman wrote:
> > Paweł Lenkow <p.lenkow-WZXhJxzPxo0FoECaAgFIynS5uNuOjpZe@public.gmane.org> writes:
> > 
> > > Hi!
> > >
> > > I am trying to run EFI stub kernel using kexec and unfortunately 2nd kernel
> > > crashes.
> > 
> > Adding the kexec list as there may be someone there who may be more
> > knowledgeable about our problem.
> > 
> > > First kernel is loaded by UEFI, starts simple init with shell and then
> > > I am loading the same image using kexec.
> > >
> > > It looks like a lack of correct mappings for EFI tables because it
> > > calls address zero (RDI register) in efi_call.
> > >
> > > Does kernel support such configuration?

Yes, it *should* works, at least works for me previously on Lenovo
laptops. What is the hardware in this case?

> > >
> > > If yes what could be wrong?
> > 
> > I don't know exactly where the support is, I haven't looked recently.
> > 
> > There is a major challenge with efi.  The call to place efi in virtual
> > mode may be called exactly once.  There has been work on at least ia64
> > to make it possible to capture the efi virtual address bass and pass it
> > through to the kernel calling kexec.  I don't remember seeing the work
> > to do that happen on other platforms.
> > 
> > I personally think we should just abandon running efi in virtual mode
> > and always run efi in physicall mode, but the feedback when I suggested
> > that was that efi didn't actually work if you did that.  *Shrug*
> > 
> > Given that efi_enter_virtual_mode is in your call trace I am guessing
> > that the problem is the historical problem I have mentioned above.

In latest kernel we have a stable va address space for efi runtime,
kexec-tools will copy the runtime maps in 1st kernel so that efi runtime
still can be still usable after kexec kernel boot up but do not entering
virtual mode again.

There might be some bug either in kernel or some special firmware
problem..

> > 
> > Eric
> > 
> > 
> > 
> > > Using grub-efi all works fine, but it is not enough for me.
> > >
> > > See log below:
> > >
> > >
> > > / # kexec -l /mnt/INSTALL/vmlinuz -s
> 
> What is the kexec-tools version? And does kexec -l works (without -s)?
> 
> A test with efi=debug parameters may help, also full logs of both
> pre-kexec boot and post-kexec boot could also help to find something..

This questions obviously are for Paweł Lenkow, add him to "To" list..

> 
> Thanks
> Dave
