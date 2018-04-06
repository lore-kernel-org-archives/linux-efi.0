From: "Luis R. Rodriguez" <mcgrof@kernel.org>
Subject: Re: [PATCH 2/2] efi: Add embedded peripheral firmware support
Date: Fri, 6 Apr 2018 14:08:32 +0000
Message-ID: <20180406140832.GF30543@wotan.suse.de>
References: <78ae4d18-8964-5748-a69f-0017d0dca5f7@redhat.com>
 <20180404171835.xvllgcqirl3b5gd5@redhat.com>
 <20180405054349.GA25653@wunner.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180405054349.GA25653@wunner.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Lukas Wunner <lukas@wunner.de>
Cc: Peter Jones <pjones@redhat.com>, Hans de Goede <hdegoede@redhat.com>, "Luis R. Rodriguez" <mcgrof@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Gleixner <tglx@linutronix.de>, Kalle Valo <kvalo@codeaurora.org>, Arend Van Spriel <arend.vanspriel@broadcom.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org, Dave Olsthoorn <dave@bewaar.me>, x86@kernel.org, linux-efi@vger.kernel.org, Will Deacon <will.deacon@arm.com>, Andy Lutomirski <luto@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Josh Triplett <josh@joshtriplett.org>, Matthew Garrett <mjg59@srcf.ucam.or>
List-Id: linux-efi@vger.kernel.org

On Thu, Apr 05, 2018 at 07:43:49AM +0200, Lukas Wunner wrote:
> On Wed, Apr 04, 2018 at 01:18:36PM -0400, Peter Jones wrote:
> > > On Tue, Apr 03, 2018 at 08:07:11PM +0200, Lukas Wunner wrote:
> > > > * Add the EFI Firmware Volume Protocol to include/linux/efi.h:
> > > >   https://www.intel.com/content/dam/doc/reference-guide/efi-firmware-file-volume-specification.pdf
> > > > 
> > > > * Amend arch/x86/boot/compressed/eboot.c to read the files with the
> > > >   GUIDs you're interested in into memory and pass the files to the
> > > >   kernel as setup_data payloads.
> > 
> > To be honest, I'm a bit skeptical about the firmware volume approach.
> > Tools like UEFITool[0] and uefi-firmware-parser[1] have existed for
> > years, still don't seem to reliably parse firmware images I see in the
> > wild, and have a fairly regular need for fixes.  These are tools
> > maintained by smart people who are making a real effort, and it still
> > looks pretty hard to do a good job that applies across a lot of
> > platforms.
> > 
> > So I'd rather use Hans's existing patches, at least for now, and if
> > someone is interested in hacking on making an efi firmware volume parser
> > for the kernel, switch them to that when such a thing is ready.
> 
> Hello?  As I've written in the above-quoted e-mail the kernel should
> read the files using EFI_FIRMWARE_VOLUME_PROTOCOL.ReadFile().
> 
> *Not* by parsing the firmware volume!
> 
> Parsing the firmware volume is only necessary to find out the GUIDs
> of the files you're looking for.  You only do that *once*.

How do you get the GUIDs for each driver BTW?

Hans, I do believe we should *try* this approach at the very least.

Why not?

Otherwise it would be wise to provide a technical reason for why
we'd choose one custom mechanism which would only serve a few tablets
over a mechanism which could serve more devices.

  Luis
