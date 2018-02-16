From: Peter Jones <pjones@redhat.com>
Subject: Re: [PATCH 0/2] efivars: reading variables can generate SMIs
Date: Fri, 16 Feb 2018 17:05:37 -0500
Message-ID: <20180216220536.liew4p4kqmaxwmfh@redhat.com>
References: <20180215182208.35003-1-joe.konno@linux.intel.com>
 <CAKv+Gu80pJ5tbGoJqBm8CCKrEZXdkE83c944383KbQ5jREUC0Q@mail.gmail.com>
 <1518814319.4419.10.camel@HansenPartnership.com>
 <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F7B37942B@ORSMSX110.amr.corp.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Luck, Tony" <tony.luck@intel.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Joe Konno <joe.konno@linux.intel.com>, Matthew Garrett <mjg59@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jeremy Kerr <jk@ozlabs.org>, Andi Kleen <ak@linux.intel.com>, Benjamin Drung <benjamin.drung@profitbricks.com>
List-Id: linux-efi@vger.kernel.org

On Fri, Feb 16, 2018 at 09:09:30PM +0000, Luck, Tony wrote:
> > That said, I'm not sure how many non-root users run the toolkit to
> > extract their EFI certificates or check on the secure boot status of
> > the system, but I suspect it might be non-zero: I can see the tinfoil
> > hat people wanting at least to check the secure boot status when they
> > log in.
> 
> Another fix option might be to rate limit EFI calls for non-root users (on X86
> since only we have the SMI problem). That would:
> 
> 1) Avoid using memory to cache all the variables
> 2) Catch any other places where non-root users can call EFI

I could get behind that as well.  Currently the things I maintain do
approximately this many normal accesses with invocations you can do as a
user:

"efibootmgr -v" - six files we always try to read, plus one per Boot####
		  entry.
"fwupdate --info" - one file it always tries to read, one file for each
                    ESRT entry.
"dbxtool -l" - one file it always reads.
"mokutil --sb-state" - reads the same file twice.  I don't maintain
                       this, but I'll send a patch to Gary to make it
		       only read it once.  AFAICS all of the other
		       invocations you can currently do as a user
		       /legitimately/ read two files, though.

Some systems seem to *love* making a pile of Boot#### entries; I think
the most I've seen is something like 16.  So on that machine, one
"efibootmgr -v" invocation is ~22 efivars files read.  I've never seen a
machine that advertised more than 2 ESRT entries, but maybe we'll get
there some day.

-- 
  Peter
