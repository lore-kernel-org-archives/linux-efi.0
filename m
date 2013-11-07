From: Dave Young <dyoung@redhat.com>
Subject: Re: [PATCH] efi earlyprintk fix
Date: Thu, 7 Nov 2013 20:00:12 +0800
Message-ID: <20131107120012.GA4116@dhcp-16-126.nay.redhat.com>
References: <20131103121647.GA4770@dhcp-16-126.nay.redhat.com>
 <20131104103739.GD21688@console-pimps.org>
 <20131104125853.GB5118@dhcp-16-126.nay.redhat.com>
 <20131106084921.GA22856@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20131106084921.GA22856@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: matt.fleming@intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org, linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-efi@vger.kernel.org

On 11/06/13 at 08:49am, Matt Fleming wrote:
> On Mon, 04 Nov, at 08:58:53PM, Dave Young wrote:
> > On 11/04/13 at 10:37am, Matt Fleming wrote:
> > > On Sun, 03 Nov, at 08:16:47PM, Dave Young wrote:
> > > > 
> > > > there's below one line shift problem:
> > > > 
> > > >                      ACPI=0xdabfe000  ACPI 2.0=0xdabfe014  SMBIOS=0xdaa9e000
> > > > [    0.000000] efi:  
> > > > 
> > > > In fact check efi_y and the lfb_height should be compared at the begin of the
> > > > loop of early_efi_write
> > >  
> > > Hmm... this is interesting. I can't produce this on any of my machines.
> > > Where did you see this? What hardware?
> > 
> > It's my laptop Thinkpad T420, the screen scolls very fast, I use boot_delay=500
> > to verify it with my patch for moving boot_delay param an early param.
> 
> Dave, how are you booting your laptop? Are you using grub? Does the
> earlyprintk output start at the bottom of the screen? Do you set any
> parameters for efifb?

I tried both grub and efi stub. The messages seems come from the n-1 line
of the screen. I did not set any parameters by myself.
