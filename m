From: Roy Franz <roy.franz@linaro.org>
Subject: Re: fwupdate
Date: Mon, 9 Mar 2015 18:54:12 -0700
Message-ID: <CAFECyb8xq+Ozn9Op4EHkiGGdn4q64h1fE_X+GHw=0X5d3r_9_w@mail.gmail.com>
References: <F54AEECA5E2B9541821D670476DAE19C2B8AD9CA@PGSMSX102.gar.corp.intel.com>
	<20150302122955.GB24476@codeblueprint.co.uk>
	<F54AEECA5E2B9541821D670476DAE19C2B8ADC41@PGSMSX102.gar.corp.intel.com>
	<CALCETrXfjbKcYSSRQXZbam7TgHU34LXM0BhvMuba_vYyCCPTig@mail.gmail.com>
	<F54AEECA5E2B9541821D670476DAE19C2B8AF4F2@PGSMSX102.gar.corp.intel.com>
	<CALCETrWKwQVe46gASNbb0miwcuHe+wirVSO-pQt6uF-Jd6e-bw@mail.gmail.com>
	<20150306081334.GA3514@pd.tnic>
	<F54AEECA5E2B9541821D670476DAE19C2B8AF844@PGSMSX102.gar.corp.intel.com>
	<20150306144725.GF3514@pd.tnic>
	<20150309212322.GG9234@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150309212322.GG9234@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
To: Borislav Petkov <bp@alien8.de>
Cc: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>, Andy Lutomirski <luto@amacapital.net>, Matt Fleming <matt@console-pimps.org>, "Ong, Boon Leong" <boon.leong.ong@intel.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sam Protsenko <semen.protsenko@linaro.org>, LKML <linux-kernel@vger.kernel.org>, Ming Lei <ming.lei@canonical.com>, Peter Jones <pjones@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Mon, Mar 9, 2015 at 2:23 PM, Borislav Petkov <bp@alien8.de> wrote:
> + pjones.
>
> So reportedly, there is already a capsule-loading thing which doesn't
> need the kernel at all:
>
> https://github.com/rhinstaller/fwupdate
>
> So why are we even wasting energy with this discussion here?
>
> --
> Regards/Gruss,
>     Boris.

The network boot case can be taken care of as Peter described (ie
taking network device paths, instead of just file paths), so
this should work for those cases as well.  There would be some extra
setup, as for this to work the EFI firmware update program
would need to be run at boot (via the BootNext variable), but I don't
think this is unreasonable.
It looks like GnuEFI now supports Aarch64, so building the firmware
update utility shouldn't be a problem.  Peter - have you you tried
building
this on Aarch64 yet?  If not I'll give it a try.

I think there is some value in using runtime update capsule calls, as
that will help make sure the feature works in the firmware.  I think
with arm64 servers
in an early stage of development, we can influence the firmware
support of various features by using them.  I don't know that this is
a sufficient reason, but if
runtime capsules are never used then there is a good chance that there
will be many broken implementations.

Roy
