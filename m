From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 4.4 05/27] x86/efi: Build our own page table structures
Date: Thu, 14 Dec 2017 21:27:26 +0100
Message-ID: <20171214202726.GA32443@kroah.com>
References: <20171204155942.271814507@linuxfoundation.org>
 <20171204155942.482436478@linuxfoundation.org>
 <1512686629.18523.217.camel@codethink.co.uk>
 <20171210212651.GA18497@kroah.com>
 <BN6PR1201MB013116597F8BD048AD3080FDF8340@BN6PR1201MB0131.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <BN6PR1201MB013116597F8BD048AD3080FDF8340@BN6PR1201MB0131.namprd12.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: "Ghannam, Yazen" <Yazen.Ghannam@amd.com>
Cc: Ben Hutchings <ben.hutchings@codethink.co.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Borislav Petkov <bp@suse.de>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, Dave Jones <davej@codemonkey.org.uk>, Denys Vlasenko <dvlasenk@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Sai Praneeth Prakhya <sai.praneeth.prakhya@intel.com>, Stephen Smalley <sds@tycho.nsa.gov>, Thoma
List-Id: linux-efi@vger.kernel.org

On Tue, Dec 12, 2017 at 05:24:32PM +0000, Ghannam, Yazen wrote:
> > -----Original Message-----
> > From: Greg Kroah-Hartman [mailto:gregkh@linuxfoundation.org]
> > Sent: Sunday, December 10, 2017 4:27 PM
> > To: Ben Hutchings <ben.hutchings@codethink.co.uk>; Ghannam, Yazen
> > <Yazen.Ghannam@amd.com>
> > Cc: linux-kernel@vger.kernel.org; stable@vger.kernel.org; Matt Fleming
> > <matt@codeblueprint.co.uk>; Borislav Petkov <bp@suse.de>; Andrew
> > Morton <akpm@linux-foundation.org>; Andy Lutomirski
> > <luto@amacapital.net>; Andy Lutomirski <luto@kernel.org>; Ard Biesheuvel
> > <ard.biesheuvel@linaro.org>; Borislav Petkov <bp@alien8.de>; Brian Gerst
> > <brgerst@gmail.com>; Dave Jones <davej@codemonkey.org.uk>; Denys
> > Vlasenko <dvlasenk@redhat.com>; H. Peter Anvin <hpa@zytor.com>; Linus
> > Torvalds <torvalds@linux-foundation.org>; Peter Zijlstra
> > <peterz@infradead.org>; Sai Praneeth Prakhya
> > <sai.praneeth.prakhya@intel.com>; Stephen Smalley <sds@tycho.nsa.gov>;
> > Thomas Gleixner <tglx@linutronix.de>; Toshi Kani <toshi.kani@hp.com>;
> > linux-efi@vger.kernel.org; Ingo Molnar <mingo@kernel.org>; Ghannam,
> > Yazen <Yazen.Ghannam@amd.com>; Alex Thorlton <athorlton@sgi.com>
> > Subject: Re: [PATCH 4.4 05/27] x86/efi: Build our own page table structures
> > 
> > On Thu, Dec 07, 2017 at 10:43:49PM +0000, Ben Hutchings wrote:
> > > On Mon, 2017-12-04 at 16:59 +0100, Greg Kroah-Hartman wrote:
> > > > 4.4-stable review patch.  If anyone has any objections, please let me
> > know.
> > > >
> > > > ------------------
> > > >
> > > > From: Matt Fleming <matt@codeblueprint.co.uk>
> > > >
> > > > commit 67a9108ed4313b85a9c53406d80dc1ae3f8c3e36 upstream.
> > > [...]
> > >
> > > It looks like this will cause regressions unless you also apply:
> > >
> > > 21cdb6b56843 x86/mm: Page align the '_end' symbol to avoid pfn
> > conversion bugs
> > > b61a76f8850d x86/efi: Map RAM into the identity page table for mixed
> > mode
> > > 753b11ef8e92 x86/efi: Setup separate EFI page tables in kexec paths
> > >
> > > and possibly also:
> > >
> > > 08914f436bdd x86/platform/UV: Bring back the call to map_low_mmrs in
> > uv_system_init
> > > 683ad8092cd2 x86/efi: Fix 7-parameter efi_call()s
> > > 80e75596079f efi: Convert efi_call_virt() to efi_call_virt_pointer()
> > > d1be84a232e3 x86/uv: Update uv_bios_call() to use efi_call_virt_pointer()
> > 
> > Ugh, that's a mess.  Yazen is the one who reported this patch, and 2
> > others, were needed to resolve an issue on their hardware.
> > 
> > Yazen, any thoughts here?  Should I just revert the 3 patches, or do you
> > also feel I need all 7 of these to ensure everything works properly?
> > 
> 
> I think it's okay to revert the 3 patches.

Ugh, messy.  Ok, all now reverted.

Thanks Ben for the review, much appreciated.

greg k-h
