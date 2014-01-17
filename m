From: Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFT][PATCH] ACPI / init: Run acpi_early_init() before
 efi_enter_virtual_mode() (was: Re: [RFC PATCH 00/14] Support timezone of
 ACPI TAD and EFI TIME)
Date: Fri, 17 Jan 2014 12:20:52 +0000
Message-ID: <20140117122052.GG27632@console-pimps.org>
References: <1387439053-8711-1-git-send-email-jlee@suse.com>
 <3476450.BMEcId2Lgj@vostro.rjw.lan>
 <20131221122148.GB29501@console-pimps.org>
 <2530951.HFPX8MI38t@vostro.rjw.lan>
 <20140112110546.GB25180@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-acpi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20140112110546.GB25180@console-pimps.org>
Sender: linux-acpi-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: "H. Peter Anvin" <hpa@zytor.com>, joeyli <jlee@suse.com>, Alessandro Zummo <a.zummo@towertech.it>, Matthew Garrett <matthew.garrett@nebula.com>, Elliott@hp.com, samer.el-haj-mahmoud@hp.com, Oliver Neukum <oneukum@suse.de>, werner@suse.com, trenn@suse.de, JBeulich@suse.com, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, x86@kernel.org, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, linux-acpi@vger.kernel.org, Borislav Petkov <bp@suse.de>
List-Id: linux-efi@vger.kernel.org

On Sun, 12 Jan, at 11:05:46AM, Matt Fleming wrote:
> On Sun, 12 Jan, at 01:30:23AM, Rafael J. Wysocki wrote:
> > On Saturday, December 21, 2013 12:21:48 PM Matt Fleming wrote:
> > > On Fri, 20 Dec, at 11:18:56PM, Rafael J. Wysocki wrote:
> > > > 
> > > > I'm not sure 100%, but I *think* we need to do that with interrupts enabled.
> > > > At least after mm_init(), because it relies on things initialized there if I
> > > > remember correctly.
> > > > 
> > > > From what I can tell at the moment, it might be possible to move it before
> > > > efi_enter_virtual_mode() if that would help.
> > > 
> > > Actually yeah, that would be super useful, and I think we'd be able to
> > > get rid of the whole efi_late_init() stuff because we'd no longer need
> > > to hang on to the EFI_BOOT_SERVICES* regions after
> > > SetVirtualAddressMap().
> > 
> > OK
> > 
> > I don't see any adverse effects of the patch below on a couple of my test
> > boxes, but (a) they are Intel-based and (b) they are non-EFI, so it would be
> > good to give it a go on as many machines as reasonably possible.
> 
> Thanks Rafael, I'll give this a spin on my test machines here.

(Sorry for replying so late)

As various other people have reported, this works fine.

-- 
Matt Fleming, Intel Open Source Technology Center
