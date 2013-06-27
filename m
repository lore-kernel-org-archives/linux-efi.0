From: Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH 1/4] Documentation: arm: [U]EFI runtime services
Date: Thu, 27 Jun 2013 15:37:14 +0100
Message-ID: <20130627143714.GA12900@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-2-git-send-email-leif.lindholm@linaro.org>
 <51CA2B03.4080106@wwwdotorg.org>
 <CACxGe6vsBKnbipR-Zd1T9Ox1J2ugFmShrGXGUzPa_=D9TJvFQw@mail.gmail.com>
 <20130626135311.GA9078@rocoto.smurfnet.nu>
 <20130626135933.GQ22026@console-pimps.org>
 <1372257499.2168.5.camel@dabdike>
 <20130627013219.GA346@srcf.ucam.org>
 <CACxGe6uFkbuJ3BxM=A0Lu=jZQ79Ba8SmNsdBdTOO13szTfTZ=Q@mail.gmail.com>
 <1372314821.557.33.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-doc-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1372314821.557.33.camel@dabdike>
Sender: linux-doc-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Matt Fleming <matt@console-pimps.org>, Leif Lindholm <leif.lindholm@linaro.org>, Stephen Warren <swarren@wwwdotorg.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, linux-efi@vger.kernel.org, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "patches@linaro.org" <patches@linaro.org>, "H. Peter Anvin" <hpa@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
List-Id: linux-efi@vger.kernel.org

On Wed, Jun 26, 2013 at 11:33:41PM -0700, James Bottomley wrote:
> On Thu, 2013-06-27 at 07:23 +0100, Grant Likely wrote:
> > What is the problem trying to be avoided by not using the virtual map?
> > Is it passing the virtual mapping data from one kernel to the next
> > when kexecing? Or something else?
> 
> Where to begin ... SetVirtualAddressMap() is one massive hack job ...
> just look at the tiano core implementation.   Basically it has a fixed
> idea of where all the pointers are and it tries to convert them all to
> the new address space.  The problem we see in x86 is that this
> conversion process isn't exhaustive due to implementation cockups, so
> the post virtual address map image occasionally tries to access
> unconverted pointers via the old physical address and oopses the kernel.

And yet it's the only mode in which the firmrware is actually tested 
against an OS, so we don't have any real choice in the matter.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
