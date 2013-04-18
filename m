From: Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] Remove warning in efi_enter_virtual_mode
Date: Thu, 18 Apr 2013 09:33:26 -0700
Message-ID: <20130418163325.GA6884@leaf>
References: <1366127886-31460-1-git-send-email-bryan.odonoghue.lkml@nexus-software.ie>
 <516EAC4A.6040202@console-pimps.org>
 <516F1B90.9040508@nexus-software.ie>
 <516FD24A.3070502@console-pimps.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <516FD24A.3070502@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Matt Fleming <matt@console-pimps.org>
Cc: Bryan O'Donoghue <bryan.odonoghue.lkml@nexus-software.ie>, matthew.garrett@nebula.com, linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org, Darren Hart <darren.hart@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Josh Boyer <jwboyer@redhat.com>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 18, 2013 at 12:00:26PM +0100, Matt Fleming wrote:
> > No, no - we *don't* have a BGRT object at all.
> > 
> > We have a completely clean memory map - but the BGRT code is causing the
> > is_ram() failure.
>  
> You assume that mapping of the Boot Services regions is done purely for
> the benefit of pulling out the bgrt image - it's not, see the above
> commit log - and I assumed that you had an ACPI bgrt pointer in your
> memory map, but you don't.
> 
> Darren, Josh, have you ever seen an i386 machine with a bgrt pointer? If
> not, and given that we've never seen an i386 firmware that requires the
> above workaround from Matthew, combined with the fact that there are so
> few i386 implementations out there, I'm inclined to apply the patch
> below, because anything else is a lot more work. We can address this
> properly if we ever start seeing i386 machines with bgrt pointers that
> reference highmem.

The machine I developed the BGRT changes on kept the image below the 4G
mark, inside one of the memory regions reclaimable via
ExitBootServices().

- Josh Triplett
